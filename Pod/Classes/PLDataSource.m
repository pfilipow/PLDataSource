//
//  PLDataSource.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-07-27.
//  Copyright (c) 2015 Pendar Labs. All rights reserved.
//

#import "PLDataSource.h"
#import "PLDataSourceConstants.h"

@implementation PLDataSource

-(NSUInteger)numberOfSections
{
    return 1;
}

-(NSIndexPath *)indexPathOfObject:(id)object
{
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

-(NSArray *)allObjects
{
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

-(PLDataSource *)searchDataSource
{
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

-(void)filterContentByQuery:(NSString *)query scope:(NSInteger)scope
{
    
}

-(void)loadContent
{
    
}

-(void)resetContent
{
    
}

-(NSString *)registeredCellReuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSString *)cellReuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Cell";
}

-(void)tableView:(UITableView *)tableView
   configureCell:(UITableViewCell *)cell
       forObject:(id)object
     atIndexPath:(NSIndexPath *)indexPath {
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

#pragma mark UITableViewDelegate Forwarding

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectAtIndexPath:indexPath];
    
    UITableViewCell* cell = [self createAndConfigureRegisteredCell:tableView :indexPath :object];
    if (!cell) {
        cell = [self createAndConfigureUnregisteredCell:tableView :indexPath :object];
    }
    
    return cell;
}

#pragma mark - Helpers

-(UITableViewCell*)createAndConfigureRegisteredCell:(UITableView*)tableView
                                                   :(NSIndexPath*)indexPath
                                                   :(id)object
{
    NSString* reuseIdentifier = [self registeredCellReuseIdentifierForRowAtIndexPath:indexPath];
    if (!reuseIdentifier) {
        return nil;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                            forIndexPath:indexPath];
    
    [self tableView:tableView configureCell:cell forObject:object atIndexPath:indexPath];
    
    return cell;
}

-(UITableViewCell*)createAndConfigureUnregisteredCell:(UITableView*)tableView
                                                     :(NSIndexPath*)indexPath
                                                     :(id)object
{
    NSString* reuseIdentifier = [self cellReuseIdentifierForRowAtIndexPath:indexPath];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [self createCellWithReuseIdentifier:reuseIdentifier];
    }
    
    [self tableView:tableView configureCell:cell forObject:object atIndexPath:indexPath];
    return cell;
}

@end
