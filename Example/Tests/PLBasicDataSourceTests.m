//
//  PLBasicDataSourceTests.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-13.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PLDataSource/PLBasicDataSource.h>
#import <OCMock/OCMock.h>
#import "TestHelpers.h"


@interface PLBasicDataSourceTests : XCTestCase

@property (nonatomic, strong) PLBasicDataSource* dataSource;

@end

@implementation PLBasicDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.dataSource = [[PLBasicDataSource alloc] init];
    self.dataSource.items = @[@"A", @"B", @"C"];
}

- (void)testReportsDeletedObjects {
    id delegateMock = OCMProtocolMock(@protocol(PLDataSourceDelegate));
    self.dataSource.delegate = delegateMock;
    
    NSArray* newItems = @[@"A", @"C"];
    NSIndexPath* removedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    [self.dataSource setItems:newItems animated:YES];
    
    BOOL (^checkCorrectParameter)(id) = ^BOOL(id obj) {
        return obj == self.dataSource;
    };
    OCMVerify([delegateMock dataSourceWillChangeContent:[OCMArg checkWithBlock:checkCorrectParameter]]);
    OCMVerify([delegateMock dataSource:[OCMArg checkWithBlock:checkCorrectParameter]
                       didRemoveObject:CHECK_ARG([@"B" isEqualToString:arg])
                           atIndexPath:CHECK_ARG([removedIndexPath isEqual:arg])]);
    OCMVerify([delegateMock dataSourceDidChangeContent:[OCMArg checkWithBlock:checkCorrectParameter]]);
}

-(void)testReportsAddedObjects {
    id delegateMock = OCMProtocolMock(@protocol(PLDataSourceDelegate));
    self.dataSource.delegate = delegateMock;
    
    NSArray* newItems = @[@"A", @"D", @"B", @"C"];
    NSIndexPath* addedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    [self.dataSource setItems:newItems animated:YES];
    
    BOOL (^checkCorrectParameter)(id) = ^BOOL(id obj) {
        return obj == self.dataSource;
    };
    OCMVerify([delegateMock dataSourceWillChangeContent:[OCMArg checkWithBlock:checkCorrectParameter]]);
    OCMVerify([delegateMock dataSource:[OCMArg checkWithBlock:checkCorrectParameter]
                       didInsertObject:CHECK_ARG([@"D" isEqualToString:arg])
                           atIndexPath:CHECK_ARG([addedIndexPath isEqual:arg])]);
    OCMVerify([delegateMock dataSourceDidChangeContent:[OCMArg checkWithBlock:checkCorrectParameter]]);
}

-(void)testReportsMovedObjects {
    id delegateMock = OCMProtocolMock(@protocol(PLDataSourceDelegate));
    self.dataSource.delegate = delegateMock;
    
    NSArray* newItems = @[@"A", @"C", @"B"];
    NSIndexPath* fromIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath* toIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    [self.dataSource setItems:newItems animated:YES];
    
    BOOL (^checkCorrectParameter)(id) = ^BOOL(id obj) {
        return obj == self.dataSource;
    };
    OCMVerify([delegateMock dataSourceWillChangeContent:[OCMArg checkWithBlock:checkCorrectParameter]]);
    OCMVerify([delegateMock dataSource:[OCMArg checkWithBlock:checkCorrectParameter]
                         didMoveObject:CHECK_ARG([@"B" isEqualToString:arg])
                           atIndexPath:CHECK_ARG([fromIndexPath isEqual:arg])
                           toIndexPath:CHECK_ARG([toIndexPath isEqual:arg])]);
    OCMVerify([delegateMock dataSourceDidChangeContent:[OCMArg checkWithBlock:checkCorrectParameter]]);
}

@end
