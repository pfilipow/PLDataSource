//
//  ExampleFetchedResultsDataSource.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import <PLDataSource/PLFetchedResultsDataSource.h>
#import "SortOption.h"
@class PLCoreDataStack;

@interface ExampleFetchedResultsDataSource : PLFetchedResultsDataSource {
    @private
    PLCoreDataStack* _coreDataStack;
}

-(instancetype)initWithCoreDataStack:(PLCoreDataStack*)coreDataStack;

@property (nonatomic, assign) PLSortOption sortOption;

@end
