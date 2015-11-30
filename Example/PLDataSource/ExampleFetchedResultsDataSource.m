//
//  ExampleFetchedResultsDataSource.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import "ExampleFetchedResultsDataSource.h"
#import "PLCoreDataStack.h"

@implementation ExampleFetchedResultsDataSource

-(instancetype)initWithCoreDataStack:(PLCoreDataStack *)coreDataStack
{
    if (self = [super initWithManagedObjectContext:coreDataStack.managedObjectContext]) {
        _coreDataStack = coreDataStack;
    }
    
    return self;
}

-(NSArray<NSSortDescriptor*>*)sortDescriptorsForSortOption:(PLSortOption)sortOption
{
    switch (sortOption) {
        case PLSortOptionAlphabetical:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES]];
            break;
        case PLSortOptionByLength:
            return @[[NSSortDescriptor sortDescriptorWithKey:@"text"
                                                   ascending:YES
                                                  comparator:^(id obj1, id obj2) {
                                                      NSInteger len1 = [obj1 length];
                                                      NSInteger len2 = [obj2 length];
                                                      if (len1 < len2) return NSOrderedAscending;
                                                      if (len1 > len2) return NSOrderedDescending;
                                                      return NSOrderedSame;
                                                  }]];
            
        default:
            break;
    }
}

-(void)setSortOption:(PLSortOption)sortOption
{
    _sortOption = sortOption;
    self.currentFetchRequest.sortDescriptors = [self sortDescriptorsForSortOption:sortOption];
}

-(NSFetchRequest *)defaultFetchRequest
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TextEntity"];
    fetchRequest.sortDescriptors = [self sortDescriptorsForSortOption:self.sortOption];
    
    return fetchRequest;
}

-(NSString *)registeredCellReuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"cell";
}

-(void)tableView:(UITableView *)tableView
   configureCell:(UITableViewCell *)cell
       forObject:(id)object
     atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [object valueForKey:@"text"];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext* context = _coreDataStack.managedObjectContext;
        [context deleteObject:[self objectAtIndexPath:indexPath]];
        [_coreDataStack save];
    }
}

@end
