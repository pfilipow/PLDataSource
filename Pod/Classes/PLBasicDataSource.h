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
-(void)setItems:(NSArray *)items animated:(BOOL)animated;

@end