//
//  PLFetchedResultsDataSourceTests.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PLDataSource/PLFetchedResultsDataSource.h>
#import "PLCoreDataStack.h"


@interface TestDataSource : PLFetchedResultsDataSource
@end

@implementation TestDataSource

-(NSFetchRequest *)defaultFetchRequest {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TextEntity"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES]];
    return request;
}

-(NSString *)sectionNameKeyPath {
    return @"text";
}

@end



@interface PLFetchedResultsDataSourceTests : XCTestCase {
    PLCoreDataStack* stack;
}

@end

@implementation PLFetchedResultsDataSourceTests

-(void)setUp {
    [super setUp];
    
    stack = [PLCoreDataStack new];
}

- (void)testUsesDefaultFetchRequest {
    TestDataSource* dataSource = [[TestDataSource alloc] initWithManagedObjectContext:stack.managedObjectContext];
    NSFetchedResultsController* frc = [dataSource fetchedResultsController];
    XCTAssertEqualObjects(frc.fetchRequest.entityName, @"TextEntity");
}

-(void)testUsesSectionNameKeyPath {
    TestDataSource* dataSource = [[TestDataSource alloc] initWithManagedObjectContext:stack.managedObjectContext];
    NSFetchedResultsController* frc = [dataSource fetchedResultsController];
    XCTAssertEqualObjects(frc.sectionNameKeyPath, @"text");
}

@end
