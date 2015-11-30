//
//  PLBasicDataSource.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-08-13.
//  Copyright (c) 2015 Pendar Labs. All rights reserved.
//

#import "PLBasicDataSource.h"

@implementation PLBasicDataSource

-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.row];
}

-(NSIndexPath *)indexPathOfObject:(id)object
{
    if ([self.items containsObject:object]) {
        return [NSIndexPath indexPathForRow:[self.items indexOfObject:object]
                                  inSection:0];
    }
    return nil;
}

-(NSArray *)allObjects
{
    return [self.items copy];
}

-(void)setItems:(NSArray *)items
{
    [self setItems:items animated:NO];
}

-(BOOL)delegateCanAnimateChanges
{
    return self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(dataSourceWillChangeContent:)] &&
        [self.delegate respondsToSelector:@selector(dataSourceDidChangeContent:)] &&
        [self.delegate respondsToSelector:@selector(dataSource:didRemoveObject:atIndexPath:)] &&
        [self.delegate respondsToSelector:@selector(dataSource:didInsertObject:atIndexPath:)] &&
        [self.delegate respondsToSelector:@selector(dataSource:didMoveObject:atIndexPath:toIndexPath:)];
}

-(void)setItems:(NSArray *)items animated:(BOOL)animated
{
    if (_items == items || [items isEqualToArray:_items]) {
        return;
    }
    
    BOOL shouldAnimateChanges = animated && [self delegateCanAnimateChanges];
    
    if (!shouldAnimateChanges) {
        _items = [items copy];
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(dataSource:didRefreshSections:)]) {
            [self.delegate dataSource:self
                   didRefreshSections:[NSIndexSet indexSetWithIndex:0]];
        }
        return;
    }
    
    NSOrderedSet* oldItemSet = [NSOrderedSet orderedSetWithArray:_items];
    NSOrderedSet* newItemSet = [NSOrderedSet orderedSetWithArray:items];
    
    NSMutableOrderedSet* deletedSet = [oldItemSet mutableCopy];
    [deletedSet minusOrderedSet:newItemSet];
    
    NSMutableOrderedSet* insertedSet = [newItemSet mutableCopy];
    [insertedSet minusOrderedSet:oldItemSet];
    
    NSMutableOrderedSet* movedSet = [newItemSet mutableCopy];
    [movedSet intersectOrderedSet:oldItemSet];
    
    NSMutableArray* deletedIndexPaths = [NSMutableArray arrayWithCapacity:[deletedSet count]];
    for (id object in deletedSet) {
        [deletedIndexPaths addObject:[self indexPathOfObject:object]];
    }
    
    NSMutableArray* insertedIndexPaths = [NSMutableArray arrayWithCapacity:[insertedSet count]];
    for (id object in insertedSet) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:[items indexOfObject:object]
                                                         inSection:0]];
    }
    
    NSMutableArray* fromIndexPaths = [NSMutableArray arrayWithCapacity:[movedSet count]];
    NSMutableArray* toIndexPaths = [NSMutableArray arrayWithCapacity:[movedSet count]];
    for (id object in movedSet) {
        [fromIndexPaths addObject:[NSIndexPath indexPathForRow:[_items indexOfObject:object]
                                                     inSection:0]];
        [toIndexPaths addObject:[NSIndexPath indexPathForRow:[items indexOfObject:object]
                                                   inSection:0]];
    }
    
    NSArray* oldItems = [_items copy];
    _items = [items copy];
    
    [self.delegate dataSourceWillChangeContent:self];
    for (NSIndexPath* indexPath in deletedIndexPaths) {
        [self.delegate dataSource:self
                  didRemoveObject:[oldItems objectAtIndex:indexPath.row]
                      atIndexPath:indexPath];
    }
    
    for (NSIndexPath* indexPath in insertedIndexPaths) {
        [self.delegate dataSource:self
                  didInsertObject:[_items objectAtIndex:indexPath.row]
                      atIndexPath:indexPath];
    }
    
    for (NSUInteger index = 0; index < [movedSet count]; index++) {
        id object = [movedSet objectAtIndex:index];
        NSIndexPath* fromIndexPath = [fromIndexPaths objectAtIndex:index];
        NSIndexPath* toIndexPath = [toIndexPaths objectAtIndex:index];
        if (fromIndexPath && toIndexPath && ![fromIndexPath isEqual:toIndexPath])
        {
            [self.delegate dataSource:self
                        didMoveObject:object
                          atIndexPath:fromIndexPath
                          toIndexPath:toIndexPath];
        }
    }
    [self.delegate dataSourceDidChangeContent:self];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

@end
