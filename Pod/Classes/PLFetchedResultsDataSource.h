//
//  PLFetchedResultsDataSource.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-07-27.
//  Copyright (c) 2015 Pendar Labs. All rights reserved.
//

#import "PLDataSource.h"
#import <CoreData/CoreData.h>

@interface PLFetchedResultsDataSource : PLDataSource
<NSFetchedResultsControllerDelegate, NSCopying>

-(nullable instancetype)initWithManagedObjectContext:(nonnull NSManagedObjectContext*)context NS_DESIGNATED_INITIALIZER;

-(nullable instancetype)init __attribute__((unavailable));

@property (nonatomic, readonly, nullable) NSFetchedResultsController* fetchedResultsController;

/// The managed object context to use for fetch.
@property (nonatomic, strong, nonnull) NSManagedObjectContext* managedObjectContext;

/// The fetch request currently being used to load table content.
/// Subclasses must override.
@property (nonatomic, strong, nonnull) NSFetchRequest* currentFetchRequest;


/// @name Subclassing Hooks

/// The default data request used if the above property is nil.
-(nonnull NSFetchRequest*)defaultFetchRequest;

/// The section name key path used on the fetched results controller to break up
/// the table view content. Default implementation returns nil.
-(nullable NSString*)sectionNameKeyPath;

@end
