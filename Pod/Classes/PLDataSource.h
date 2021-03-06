//
//  PLDataSource.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-07-27.
//  Copyright (c) 2015 Pendar Labs. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PLDataSource;

@protocol PLDataSourceDelegate <NSObject>

NS_ASSUME_NONNULL_BEGIN

@optional
-(void)dataSourceWillChangeContent:(PLDataSource*)dataSource;
-(void)dataSource:(PLDataSource*)dataSource didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(PLDataSource*)dataSource didRemoveObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(PLDataSource*)dataSource didChangeObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(PLDataSource*)dataSource didMoveObject:(id)object atIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*)newIndexPath;
-(void)dataSource:(PLDataSource*)dataSource didInsertSectionAtIndex:(NSUInteger)sectionIndex;
-(void)dataSource:(PLDataSource*)dataSource didRemoveSectionAtIndex:(NSUInteger)sectionIndex;
-(void)dataSourceDidChangeContent:(PLDataSource*)dataSource;

-(void)dataSource:(PLDataSource*)dataSource didRefreshRowAtIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(PLDataSource*)dataSource didRefreshSections:(NSIndexSet*)sectionIndices;

NS_ASSUME_NONNULL_END

@end


@interface PLDataSource : NSObject <UITableViewDataSource>

/// The title of this data source
@property (nonatomic, copy, nullable) NSString* title;
/// The number of sub-data-sources in this data source (default 1)
@property (nonatomic, readonly) NSUInteger numberOfSections;
/// The data source delegate that will respond to the content changes
@property (nonatomic, weak, nullable) id<PLDataSourceDelegate> delegate;

/// The table view whose data this data source manages. 
@property (nonatomic, weak, nullable) UITableView* tableView;

/// Tells the data source to load its content, if applicable (default implementation does nothing).
-(void)loadContent;
/// Tells the data source to reload its content (default implementation does nothing).
-(void)resetContent;

/// Returns the object at a given index path
-(nullable id)objectAtIndexPath:(nonnull NSIndexPath*)indexPath;
/// Provides an index path in the table view for the given object
-(nullable NSIndexPath*)indexPathOfObject:(nonnull id)object;

/// Returns all objects in the data source
@property (nonatomic, readonly, nullable) NSArray* allObjects;

/// @name Subclassing Hooks

/// The reuse identifier of cells that have been registered with the table view.
/// If you have registered a cell or Nib for reuse, simply override this method.
/// Otherwise, this method returns `nil` by default, and you will need to use
/// the following two methods.
///
/// Returning `nil` makes `PLDataSource` dequeue or create a UITableViewCell with
/// reuse identifier returned from `cellReuseIdentifierForRowAtIndexPath:` with a
/// possible call to `createCellwithReuseIdentifier:`.
-(nullable NSString*)registeredCellReuseIdentifierForRowAtIndexPath:(nonnull NSIndexPath*)indexPath;
/// Fallback if we have no registered cells.
-(nonnull NSString*)cellReuseIdentifierForRowAtIndexPath:(nonnull NSIndexPath*)indexPath;
-(nonnull UITableViewCell*)createCellWithReuseIdentifier:(nonnull NSString*)identifier;
/// Override this method to configure your cells.
-(void)tableView:(nonnull UITableView*)tableView
   configureCell:(nonnull UITableViewCell*)cell
       forObject:(nonnull id)object
     atIndexPath:(nonnull NSIndexPath*)indexPath;

/// @name UITableViewDelegate Forwarding

/// Some methods contained in the `UITableViewDelegate` protocol are really
/// relevant to the data source. These methods allow these requests to be
/// forwarded to the data source for better separation of concerns.

-(CGFloat)heightForRowAtIndexPath:(nonnull NSIndexPath*)indexPath;

/// @name Search

/// These methods are optionally implemented by subclasses to provide
/// search functionality.

/// Returns a new data source that is suitable for filtering content
/// with a query.
-(nullable PLDataSource*)searchDataSource;
/// Filters the data source's content by the provided query and scope
/// and triggers appropriate delegate callbacks.
-(void)filterContentByQuery:(nullable NSString*)query scope:(NSInteger)scope;

@end
