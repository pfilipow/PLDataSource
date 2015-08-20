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

-(Class)tableViewCellClass
{
    if (_tableViewCellClass == nil) {
        _tableViewCellClass = [UITableViewCell class];
    }
    return _tableViewCellClass;
}

-(NSString *)cellReuseIdentifier
{
    if (_cellReuseIdentifier == nil) {
        _cellReuseIdentifier = @"Cell";
    }
    
    return _cellReuseIdentifier;
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
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

@end
