//
//  PLMergedDataSource.h
//  Pods
//
//  Created by Hirad Motamed on 2015-11-15.
//
//

#import <PLDataSource/PLDataSource.h>

@interface PLMergedDataSource : PLDataSource <PLDataSourceDelegate>

-(instancetype)initWithDataSources:(NSArray*)dataSources NS_DESIGNATED_INITIALIZER;

/// All child data sources - provided at initialization.
@property (nonatomic, readonly) NSArray<PLDataSource*>* dataSources;

@end