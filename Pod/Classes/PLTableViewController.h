//
//  PLTableViewController.h
//  Pods
//
//  Created by Hirad Motamed on 2015-11-12.
//
//

#import <UIKit/UIKit.h>
#import "PLDataSource.h"

@interface PLTableViewController : UITableViewController
<PLDataSourceDelegate>

@property (nonatomic, strong) PLDataSource* dataSource;

/// @name Subclassing Hooks

-(void)initializeDataSources;

/// Defaults to UITableViewRowAnimationAutomatic
-(UITableViewRowAnimation)rowAnimationForInsertion;

/// Defaults to UITableViewRowAnimationAutomatic
-(UITableViewRowAnimation)rowAnimationForChange;

/// Defaults to UITableViewRowAnimationAutomatic
-(UITableViewRowAnimation)rowAnimationForDeletion;

@end
