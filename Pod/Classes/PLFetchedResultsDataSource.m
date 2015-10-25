//
//  PLFetchedResultsDataSource.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-07-27.
//  Copyright (c) 2015 Pendar Labs. All rights reserved.
//

#import "PLFetchedResultsDataSource.h"
#import "PLDataSourceConstants.h"


@interface PLFetchedResultsDataSource ()

@property (nonatomic, readwrite) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, readwrite) NSArray* allObjects;

@end


@implementation PLFetchedResultsDataSource

@synthesize allObjects = _allObjects;

-(nullable instancetype)initWithManagedObjectContext:(nonnull NSManagedObjectContext *)context {
    if (self = [super init]) {
        _managedObjectContext = context;
        [self listenForChanges];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadContent
{
    NSParameterAssert(self.managedObjectContext);
    
    NSError* error = nil;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"%@ failed to fetch data: %@; %@",
             self, [error localizedDescription], [error userInfo]);
        return;
    }
    
    [self refreshObjects];
}

-(void)refreshObjects
{
    self.allObjects = [self.fetchedResultsController fetchedObjects];
}

-(void)resetContent
{
    self.fetchedResultsController = nil;
    [self loadContent];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

-(NSIndexPath *)indexPathOfObject:(id)object
{
    return [self.fetchedResultsController indexPathForObject:object];
}

-(NSArray *)allObjects
{
    return _allObjects;
}

-(void)setAllObjects:(NSArray *)allObjects
{
    _allObjects = allObjects;
}

-(NSFetchRequest *)currentFetchRequest
{
    if (_currentFetchRequest == nil) {
        _currentFetchRequest = [self defaultFetchRequest];
    }
    return _currentFetchRequest;
}

-(NSUInteger)numberOfSections
{
    return [[self.fetchedResultsController sections] count];
}

#pragma mark - Subclassing Hooks

-(NSFetchRequest *)defaultFetchRequest
{
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

-(NSString *)sectionNameKeyPath
{
    return nil;
}

#pragma mark - fetchedResultsController setup 

-(void)listenForChanges
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

-(void)contextDidSave:(NSNotification*)notification
{
    NSManagedObjectContext* moc = self.managedObjectContext;
    NSManagedObjectContext* savedContext = (NSManagedObjectContext*)notification.object;
    if ([savedContext persistentStoreCoordinator] == [moc persistentStoreCoordinator] &&
        savedContext.parentContext == nil) {
        [moc performBlock:^{
            [moc mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* request = [self currentFetchRequest];
    NSManagedObjectContext* context = self.managedObjectContext;
    NSAssert(request != nil && context != nil,
             @"NSFetchedResultsController cannot be initialized without"
             " a valid fetch request and managed object context.");
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:context
                                                                      sectionNameKeyPath:[self sectionNameKeyPath]
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.delegate) {
        [self.delegate dataSourceWillChangeContent:self];
    }
}

-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.delegate) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.delegate dataSource:self didInsertObject:anObject atIndexPath:newIndexPath];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.delegate dataSource:self didRemoveObject:anObject atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.delegate dataSource:self didChangeObject:anObject atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeMove:
                [self.delegate dataSource:self didMoveObject:anObject atIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    }
}

-(void)controller:(NSFetchedResultsController *)controller
 didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
          atIndex:(NSUInteger)sectionIndex
    forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.delegate) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.delegate dataSource:self didInsertSectionAtIndex:sectionIndex];
                break;
            case NSFetchedResultsChangeDelete:
                [self.delegate dataSource:self didRemoveSectionAtIndex:sectionIndex];
                break;
            default:
                break;
        }
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self refreshObjects];
    if (self.delegate) {
        [self.delegate dataSourceDidChangeContent:self];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    PLFetchedResultsDataSource* newDataSource = [[self class] new];
    newDataSource.managedObjectContext = self.managedObjectContext;
    newDataSource.delegate = self.delegate;
    return newDataSource;
}

@end
