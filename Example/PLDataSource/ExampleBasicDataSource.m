//
//  ExampleBasicDataSource.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-12.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import "ExampleBasicDataSource.h"

@implementation ExampleBasicDataSource

-(NSString *)registeredCellReuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"DefaultCell";
}

-(void)tableView:(UITableView *)tableView
   configureCell:(UITableViewCell *)cell
       forObject:(id)object
     atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [self objectAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id object = [self objectAtIndexPath:indexPath];
        NSMutableArray* newContent = [self.items mutableCopy];
        [newContent removeObject:object];
        [self setItems:[NSArray arrayWithArray:newContent] animated:YES];
    }
}

@end
