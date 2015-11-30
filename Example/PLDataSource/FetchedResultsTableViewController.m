//
//  FetchedResultsTableViewController.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import "FetchedResultsTableViewController.h"
#import "ExampleFetchedResultsDataSource.h"
#import "PLCoreDataStack.h"
#import "SortOption.h"

@interface FetchedResultsTableViewController ()

@property (nonatomic, strong) PLCoreDataStack* coreDataStack;

@end

@implementation FetchedResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initializeDataSources {
    self.coreDataStack = [[PLCoreDataStack alloc] init];
    
    ExampleFetchedResultsDataSource* ds = [[ExampleFetchedResultsDataSource alloc] initWithManagedObjectContext:self.coreDataStack.managedObjectContext];
    ds.sortOption = PLSortOptionAlphabetical;
    self.dataSource = ds;
}

-(ExampleFetchedResultsDataSource*)fetchedResultsDataSource {
    return (ExampleFetchedResultsDataSource*)self.dataSource;
}

-(IBAction)shuffle:(id)sender {
    PLSortOption newSortOption = self.fetchedResultsDataSource.sortOption == PLSortOptionAlphabetical ? PLSortOptionByLength : PLSortOptionAlphabetical;
    [[self fetchedResultsDataSource] setSortOption:newSortOption];
    [[self fetchedResultsDataSource] resetContent];
    [self.tableView reloadData];
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
    NSManagedObjectContext* context = self.coreDataStack.managedObjectContext;
    NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:@"TextEntity"
                                                            inManagedObjectContext:context];
    [object setValue:entry forKey:@"text"];
    
    [self.coreDataStack save];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
