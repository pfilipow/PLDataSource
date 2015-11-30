//
//  PLBasicDataSource.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-08-13.
//  Copyright (c) 2015 Pendar Labs. All rights reserved.
//

#import "PLDataSource.h"

/// A basic data source to display a list of items in one section
@interface PLBasicDataSource : PLDataSource

/// The items to display in the table view
@property (nonatomic, copy) NSArray* items;

/// Use this method to change the items with optional animation.
/// Note: when animated, the receiver informs its delegate of all
/// additions, deletions, and moves of the items it manages. That
/// depends on being able to distinguish equality of the objects.
/// Since NSOrderedSets are used for this, displaying data with
/// duplicate objects may also be problematic.
-(void)setItems:(NSArray *)items animated:(BOOL)animated;

@end