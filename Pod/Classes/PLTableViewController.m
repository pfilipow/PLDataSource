//
//  PLTableViewController.m
//  Pods
//
//  Created by Hirad Motamed on 2015-11-12.
//
//

#import "PLTableViewController.h"
#import "PLDataSourceConstants.h"

@interface PLTableViewController ()

@end

@implementation PLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self.dataSource;
    
    [self.dataSource loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeDataSources {
    THROW_UNIMPLEMENTED_METHOD_EXCEPTION;
}

-(PLDataSource *)dataSource {
    if (_dataSource == nil) {
        [self initializeDataSources];
        NSAssert(_dataSource, @"[%@ dataSource] cannot be nil after a call to -initializeDataSources",
                 NSStringFromClass([self class]));
        _dataSource.delegate = self;
    }
    
    return _dataSource;
}

-(UITableViewRowAnimation)rowAnimationForInsertion {
    return UITableViewRowAnimationAutomatic;
}

-(UITableViewRowAnimation)rowAnimationForChange {
    return UITableViewRowAnimationAutomatic;
}

-(UITableViewRowAnimation)rowAnimationForDeletion {
    return UITableViewRowAnimationAutomatic;
}

#pragma mark - PLDataSourceDelegate

-(void)dataSourceWillChangeContent:(PLDataSource *)dataSource {
    [self.tableView beginUpdates];
}

-(void)dataSource:(PLDataSource *)dataSource didInsertSectionAtIndex:(NSUInteger)sectionIndex {
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:[self rowAnimationForInsertion]];
}

-(void)dataSource:(PLDataSource *)dataSource didRefreshSections:(NSIndexSet *)sectionIndices {
    [self.tableView reloadSections:sectionIndices
                  withRowAnimation:[self rowAnimationForChange]];
}

-(void)dataSource:(PLDataSource *)dataSource didRemoveSectionAtIndex:(NSUInteger)sectionIndex {
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:[self rowAnimationForDeletion]];
}

-(void)dataSource:(PLDataSource *)dataSource
  didInsertObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:[self rowAnimationForInsertion]];
}

-(void)dataSource:(PLDataSource *)dataSource
  didChangeObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:[self rowAnimationForChange]];
}

-(void)dataSource:(PLDataSource *)dataSource
    didMoveObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath
      toIndexPath:(NSIndexPath *)newIndexPath {
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

-(void)dataSource:(PLDataSource *)dataSource didRefreshRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:[self rowAnimationForChange]];
}

-(void)dataSource:(PLDataSource *)dataSource
  didRemoveObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:[self rowAnimationForDeletion]];
}

-(void)dataSourceDidChangeContent:(PLDataSource *)dataSource {
    [self.tableView endUpdates];
}

@end
