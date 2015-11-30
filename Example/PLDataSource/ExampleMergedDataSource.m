//
//  ExampleMergedDataSource.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import "ExampleMergedDataSource.h"
#import "PLCoreDataStack.h"
#import "ExampleBasicDataSource.h"
#import "ExampleFetchedResultsDataSource.h"


@interface ExampleMergedDataSource ()
@property (nonatomic, strong) PLCoreDataStack* coreDataStack;
@end


@implementation ExampleMergedDataSource

-(instancetype)initWithCoreDataStack:(PLCoreDataStack *)stack {
    ExampleFetchedResultsDataSource* frDataSource = [[ExampleFetchedResultsDataSource alloc] initWithCoreDataStack:stack];
    ExampleBasicDataSource* basicDataSource = [ExampleBasicDataSource new];
    basicDataSource.items = @[@"Hello", @"World"];
    
    if (self = [super initWithDataSources:@[frDataSource, basicDataSource]]) {
        _coreDataStack = stack;
    }
    
    return self;
}

-(instancetype)initWithDataSources:(NSArray *)dataSources {
    return [self initWithCoreDataStack:nil];
}

@end
