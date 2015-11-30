//
//  ExampleMergedDataSource.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import <PLDataSource/PLMergedDataSource.h>

@class PLCoreDataStack;

@interface ExampleMergedDataSource : PLMergedDataSource

-(instancetype)initWithCoreDataStack:(PLCoreDataStack*)stack NS_DESIGNATED_INITIALIZER;

@end
