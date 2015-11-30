//
//  MergedDataViewController.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import "MergedDataViewController.h"
#import "ExampleMergedDataSource.h"
#import "PLCoreDataStack.h"
#import <CoreData/CoreData.h>

@interface MergedDataViewController ()
@property (nonatomic, strong) PLCoreDataStack* stack;
@end

@implementation MergedDataViewController

-(void)initializeDataSources {
    self.stack = [PLCoreDataStack new];
    ExampleMergedDataSource* ds = [[ExampleMergedDataSource alloc] initWithCoreDataStack:self.stack];
    self.dataSource = ds;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSampleData];
    });
}

-(void)addSampleData {
    NSManagedObject* obj1 = [NSEntityDescription insertNewObjectForEntityForName:@"TextEntity"
                                                          inManagedObjectContext:self.stack.managedObjectContext];
    [obj1 setValue:@"AAA" forKey:@"text"];
    
    NSManagedObject* obj2 = [NSEntityDescription insertNewObjectForEntityForName:@"TextEntity"
                                                          inManagedObjectContext:self.stack.managedObjectContext];
    [obj2 setValue:@"BBB" forKey:@"text"];
    
    [self.stack save];
}

@end
