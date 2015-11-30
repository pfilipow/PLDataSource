//
//  PLBasicDataViewController.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-12.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import "PLBasicDataViewController.h"
#import <PLDataSource/PLBasicDataSource.h>
#import "SortOption.h"
#import "ExampleBasicDataSource.h"

@interface NSString (LengthComparator)

-(NSComparisonResult)lengthCompare:(NSString*)otherString;

@end

@implementation NSString (LengthComparator)

-(NSComparisonResult)lengthCompare:(NSString *)otherString {
    return [self length] > [otherString length] ? NSOrderedDescending : NSOrderedAscending;
}

@end

#pragma mark -

@interface PLBasicDataViewController ()
@property (nonatomic, assign) PLSortOption sortOption;
@end

@implementation PLBasicDataViewController

-(SEL)sortSelectorForSortOption:(PLSortOption)sortOption {
    if (sortOption == PLSortOptionByLength) {
        return @selector(lengthCompare:);
    }
    
    return @selector(localizedCaseInsensitiveCompare:);
}

-(void)initializeDataSources {
    ExampleBasicDataSource* basicDataSource = [[ExampleBasicDataSource alloc] init];
    basicDataSource.items = [@[@"Lorem", @"ipsum", @"dolor", @"sit", @"amet", @"elementary"] sortedArrayUsingSelector:[self sortSelectorForSortOption:self.sortOption]];
    
    self.dataSource = basicDataSource;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray* newItems = [self.basicDataSource.items mutableCopy];
        [newItems insertObject:@"AAA" atIndex:2];
        [self.basicDataSource setItems:newItems animated:YES];
    });
}

-(ExampleBasicDataSource*)basicDataSource {
    return (ExampleBasicDataSource*)self.dataSource;
}

-(IBAction)shuffle:(id)sender {
    if (self.sortOption == PLSortOptionByLength) {
        self.sortOption = PLSortOptionAlphabetical;
    }
    else {
        self.sortOption = PLSortOptionByLength;
    }
    
    NSArray* newItems = [self.basicDataSource.items sortedArrayUsingSelector:[self sortSelectorForSortOption:self.sortOption]];
    [self.basicDataSource setItems:newItems animated:YES];
}

-(IBAction)addItem:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    UIAlertAction* addAction = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          __strong typeof(self) strongSelf = weakSelf;
                                                          UITextField* textField = alertController.textFields[0];
                                                          NSString* newText = textField.text;
                                                          [strongSelf addNewEntry:newText];
                                                      }];
    [alertController addTextFieldWithConfigurationHandler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:addAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)addNewEntry:(NSString*)entry {
    NSArray* newSet = [self.basicDataSource.items arrayByAddingObject:entry];
    newSet = [newSet sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.basicDataSource setItems:newSet animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
