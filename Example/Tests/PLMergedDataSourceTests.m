//
//  PLMergedDataSourceTests.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PLDataSource/PLMergedDataSource.h>
#import <PLDataSource/PLBasicDataSource.h>
#import <PLDataSource/PLFetchedResultsDataSource.h>
#import "PLCoreDataStack.h"
#import <OCMock/OCMock.h>
#import "TestHelpers.h"


@interface TestFetchedResultsDataSource : PLFetchedResultsDataSource
@end

@implementation TestFetchedResultsDataSource

-(NSFetchRequest *)defaultFetchRequest {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TextEntity"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES]];
    return request;
}

-(NSString *)sectionNameKeyPath {
    return @"text";
}

@end

#pragma mark -

@interface PLMergedDataSourceTests : XCTestCase {
    id delegateMock;
}

@property (nonatomic, strong) PLMergedDataSource* dataSource;
@property (nonatomic, strong) NSArray* children;

@property (nonatomic, strong) PLCoreDataStack* coreDataStack;

@end


@implementation PLMergedDataSourceTests

-(void)createTestObjects {
    NSManagedObject* obj1 = [NSEntityDescription insertNewObjectForEntityForName:@"TextEntity"
                                                          inManagedObjectContext:self.coreDataStack.managedObjectContext];
    [obj1 setValue:@"AAA" forKey:@"text"];
    
    NSManagedObject* obj2 = [NSEntityDescription insertNewObjectForEntityForName:@"TextEntity"
                                                          inManagedObjectContext:self.coreDataStack.managedObjectContext];
    [obj2 setValue:@"BBB" forKey:@"text"];
    
    [self.coreDataStack save];
}

- (void)setUp {
    [super setUp];
    
    self.coreDataStack = [[PLCoreDataStack alloc] init];
    [self createTestObjects];
    
    TestFetchedResultsDataSource* ds1 = [[TestFetchedResultsDataSource alloc] initWithManagedObjectContext:self.coreDataStack.managedObjectContext];
    
    PLBasicDataSource* ds2 = [PLBasicDataSource new];
    ds2.items = @[@1, @2, @3];
    
    self.children = @[ds1, ds2];
    self.dataSource = [[PLMergedDataSource alloc] initWithDataSources:self.children];
    
    delegateMock = OCMProtocolMock(@protocol(PLDataSourceDelegate));
    self.dataSource.delegate = delegateMock;
    
    [self.dataSource loadContent];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReportsCorrectNumberOfSections {
    XCTAssert([self.dataSource numberOfSections] == 3,
              @"Should have sections from all child data sources.");
}

-(void)testReportsCorrectNumberOfRowsInEachSection {
    UITableView* dummyTableView = [[UITableView alloc] init];
    
    NSInteger rowsInSection0 = [self.dataSource tableView:dummyTableView
                                    numberOfRowsInSection:0];
    NSInteger rowsInSection1 = [self.dataSource tableView:dummyTableView
                                    numberOfRowsInSection:1];
    NSInteger rowsInSection2 = [self.dataSource tableView:dummyTableView
                                    numberOfRowsInSection:2];
    BOOL rowsMatch = (rowsInSection0 == 1) && (rowsInSection1 == 1) && (rowsInSection2 == 3);
    XCTAssert(rowsMatch, @"Should have the right number of rows in each section");
}

-(void)testDetectsAdditionsInChildDataSources {
    [self.children[1] setItems:@[@1, @2, @3, @4] animated:YES];
    NSIndexPath* insertedIndexPath = [NSIndexPath indexPathForRow:3 inSection:2];
    
    OCMVerify([delegateMock dataSourceWillChangeContent:CHECK_ARG(arg == self.dataSource)]);
    OCMVerify([delegateMock dataSource:CHECK_ARG(arg == self.dataSource)
                       didInsertObject:CHECK_ARG([@4 isEqualToNumber:arg])
                           atIndexPath:CHECK_ARG([insertedIndexPath isEqual:arg])]);
    OCMVerify([delegateMock dataSourceDidChangeContent:CHECK_ARG(arg == self.dataSource)]);
}

-(void)testDetectsDeletionsInChildDataSources {
    [self.children[1] setItems:@[@1, @3] animated:YES];
    NSIndexPath* deletedIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    
    OCMVerify([delegateMock dataSourceWillChangeContent:CHECK_ARG(arg == self.dataSource)]);
    OCMVerify([delegateMock dataSource:CHECK_ARG(arg == self.dataSource)
                       didRemoveObject:CHECK_ARG([@2 isEqualToNumber:arg])
                           atIndexPath:CHECK_ARG([deletedIndexPath isEqual:arg])]);
    OCMVerify([delegateMock dataSourceDidChangeContent:CHECK_ARG(arg == self.dataSource)]);
}

-(void)testDetectsMovesInChildDataSources {
    [self.children[1] setItems:@[@1, @3, @2] animated:YES];
    NSIndexPath* fromIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    NSIndexPath* toIndexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    
    OCMVerify([delegateMock dataSourceWillChangeContent:CHECK_ARG(arg == self.dataSource)]);
    OCMVerify([delegateMock dataSource:CHECK_ARG(arg == self.dataSource)
                         didMoveObject:CHECK_ARG([@2 isEqualToNumber:arg])
                           atIndexPath:CHECK_ARG([fromIndexPath isEqual:arg])
                           toIndexPath:CHECK_ARG([toIndexPath isEqual:arg])]);
    OCMVerify([delegateMock dataSourceDidChangeContent:CHECK_ARG(arg == self.dataSource)]);
}

-(void)testDetectsSectionAdditions {
    NSManagedObject* newText = [NSEntityDescription insertNewObjectForEntityForName:@"TextEntity"
                                                             inManagedObjectContext:self.coreDataStack.managedObjectContext];
    [newText setValue:@"CCC" forKey:@"text"];
    
    NSUInteger insertedSection = 2;
    
    [self.coreDataStack save];
    
    OCMVerify([delegateMock dataSourceWillChangeContent:CHECK_ARG(arg == self.dataSource)]);
    OCMVerify([delegateMock dataSource:CHECK_ARG(arg == self.dataSource) didInsertSectionAtIndex:insertedSection]);
    OCMVerify([delegateMock dataSourceDidChangeContent:CHECK_ARG(arg == self.dataSource)]);
}

-(void)testDetectsSectionDeletions {
    NSIndexPath* deletedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSManagedObject* obj = (NSManagedObject*)[self.children[0] objectAtIndexPath:deletedIndexPath];
    [self.coreDataStack.managedObjectContext deleteObject:obj];
    
    [self.coreDataStack save];
    
    OCMVerify([delegateMock dataSourceWillChangeContent:CHECK_ARG(arg == self.dataSource)]);
    OCMVerify([delegateMock dataSource:CHECK_ARG(arg == self.dataSource) didRemoveSectionAtIndex:0]);
    OCMVerify([delegateMock dataSourceDidChangeContent:CHECK_ARG(arg == self.dataSource)]);
}

@end
