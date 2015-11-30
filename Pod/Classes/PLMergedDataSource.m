//
//  PLMergedDataSource.m
//  Pods
//
//  Created by Hirad Motamed on 2015-11-15.
//
//

#import "PLMergedDataSource.h"

@interface PLMergedDataSource ()

@property (nonatomic, assign) NSInteger activeContentChangers;

@end


@implementation PLMergedDataSource
@synthesize tableView = _tableView;

-(instancetype)init {
    return [self initWithDataSources:@[]];
}

-(instancetype)initWithDataSources:(NSArray *)dataSources {
    if (self = [super init]) {
        NSParameterAssert(dataSources);
        _activeContentChangers = 0;
        _dataSources = dataSources;
        [self setAllChildDelegates];
    }
    
    return self;
}

-(void)setAllChildDelegates {
    [self.dataSources makeObjectsPerformSelector:@selector(setDelegate:)
                                      withObject:self];
}

-(void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    for (PLDataSource* ds in self.dataSources) {
        [ds setTableView:tableView];
    }
}

-(void)loadContent {
    [self.dataSources makeObjectsPerformSelector:@selector(loadContent)];
}

-(void)resetContent {
    [self.dataSources makeObjectsPerformSelector:@selector(resetContent)];
}

-(void)filterContentByQuery:(NSString *)query scope:(NSInteger)scope {
    [self.dataSources enumerateObjectsUsingBlock:^(PLDataSource* ds, NSUInteger idx, BOOL *stop) {
        [ds filterContentByQuery:query scope:scope];
    }];
}

-(NSUInteger)numberOfSections {
    return [self totalSectionsInSourcesAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.dataSources count])]];
}

-(NSIndexPath *)indexPathOfObject:(id)object {
    for (int i = 0; i < [self.dataSources count]; i++) {
        PLDataSource* ds = self.dataSources[i];
        NSIndexPath* indexPath = [ds indexPathOfObject:object];
        if (indexPath != nil) {
            return [self globalIndexPathFromIndexPath:indexPath inDataSource:ds];
        }
    }
    
    return nil;
}

#define FORWARD_TO_CHILD(_CMD_) \
PLDataSource* childDataSource = [self dataSourceForGlobalIndexPath:indexPath];\
NSIndexPath* childIndexPath = [self indexPathInDataSource:childDataSource fromGlobalIndexPath:indexPath];\
return [childDataSource _CMD_ childIndexPath]

-(id)objectAtIndexPath:(NSIndexPath *)indexPath {
    FORWARD_TO_CHILD(objectAtIndexPath:);
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FORWARD_TO_CHILD(heightForRowAtIndexPath:);
}

-(NSString *)registeredCellReuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    FORWARD_TO_CHILD(registeredCellReuseIdentifierForRowAtIndexPath:);
}

-(NSString *)cellReuseIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    FORWARD_TO_CHILD(cellReuseIdentifierForRowAtIndexPath:);
}

#undef FORWARD_TO_CHILD

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PLDataSource* ds = [self dataSourceForSection:section];
    NSInteger localSection = [self sectionIndexInDataSource:ds fromGlobalSection:section];
    NSInteger rows = [ds tableView:tableView numberOfRowsInSection:localSection];
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLDataSource* ds = [self dataSourceForGlobalIndexPath:indexPath];
    
    UITableViewCell* cell = [self createAndConfigureRegisteredCellInTableView:tableView
                                                                   dataSource:ds
                                                              globalIndexPath:indexPath];
    if (cell == nil) {
        cell = [self createAndConfigureCellInTableView:tableView
                                            dataSource:ds
                                       globalIndexPath:indexPath];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    PLDataSource* ds = [self dataSourceForSection:section];
    
    if (![ds respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return nil;
    }
    
    NSUInteger localSection = [self sectionIndexInDataSource:ds fromGlobalSection:section];
    return [ds tableView:tableView titleForHeaderInSection:localSection];
}

#pragma mark Cell Configuration/Dequeue Helpers

-(UITableViewCell*)createAndConfigureRegisteredCellInTableView:(UITableView*)tableView
                                                    dataSource:(PLDataSource*)dataSource
                                               globalIndexPath:(NSIndexPath*)indexPath {
    NSString* reuseIdentifier = [self registeredCellReuseIdentifierForRowAtIndexPath:indexPath];
    if (!reuseIdentifier) {
        return nil;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                            forIndexPath:indexPath];
    
    [dataSource tableView:tableView
            configureCell:cell
                forObject:[self objectAtIndexPath:indexPath]
              atIndexPath:[self indexPathInDataSource:dataSource fromGlobalIndexPath:indexPath]];
    
    return cell;
}

-(UITableViewCell*)createAndConfigureCellInTableView:(UITableView*)tableView
                                          dataSource:(PLDataSource*)dataSource
                                     globalIndexPath:(NSIndexPath*)indexPath {
    NSString* reuseIdentifier = [self cellReuseIdentifierForRowAtIndexPath:indexPath];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [self createCellWithReuseIdentifier:reuseIdentifier];
    }
    
    [dataSource tableView:tableView
            configureCell:cell
                forObject:[self objectAtIndexPath:indexPath]
              atIndexPath:[self indexPathInDataSource:dataSource fromGlobalIndexPath:indexPath]];
    
    return cell;
}

#pragma mark Index Path Conversion Helpers

/// Calculates the total number of sections in the data sources at the range indicated by `indexSet`.
-(NSUInteger)totalSectionsInSourcesAtIndexes:(NSIndexSet*)indexSet {
    NSArray* sources = [self.dataSources objectsAtIndexes:indexSet];
    NSUInteger count = 0;
    for (PLDataSource* ds in sources) {
        count += [ds numberOfSections];
    }
    return count;
}

/// Calculates the total number of sections in child data sources up to (but not including)
/// the provided data source.
-(NSUInteger)totalSectionsUpToDataSource:(PLDataSource*)dataSource {
    NSUInteger indexOfDataSource = [self.dataSources indexOfObject:dataSource];
    if (indexOfDataSource == 0) {
        return 0;
    }
    
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, indexOfDataSource)];
    NSUInteger sectionsCount = [self totalSectionsInSourcesAtIndexes:indexSet];
    return sectionsCount;
}

/// Given a global index path, returns the child data source that provides data for that section.
-(PLDataSource*)dataSourceForGlobalIndexPath:(NSIndexPath*)indexPath {
    return [self dataSourceForSection:indexPath.section];
}

-(PLDataSource*)dataSourceForSection:(NSUInteger)section {
    __block PLDataSource* ds = nil;
    __block NSUInteger sectionsCount = 0;
    [self.dataSources enumerateObjectsUsingBlock:^(PLDataSource* dataSource, NSUInteger idx, BOOL *stop) {
        sectionsCount += [dataSource numberOfSections];
        if (section < sectionsCount) {
            *stop = YES;
            ds = dataSource;
        }
    }];
    return ds;
}

-(NSUInteger)globalSectionIndexFromIndex:(NSUInteger)sectionIndex inDataSource:(PLDataSource*)source {
    NSUInteger sectionsCount = [self totalSectionsUpToDataSource:source];
    return sectionsCount + sectionIndex;
}

-(NSIndexPath*)globalIndexPathFromIndexPath:(NSIndexPath*)indexPath inDataSource:(PLDataSource*)source {
    return [NSIndexPath indexPathForRow:indexPath.row
                              inSection:[self globalSectionIndexFromIndex:indexPath.section
                                                             inDataSource:source]];
}

-(NSUInteger)sectionIndexInDataSource:(PLDataSource*)dataSource fromGlobalSection:(NSUInteger)section {
    NSUInteger sectionsCount = [self totalSectionsUpToDataSource:dataSource];
    return section - sectionsCount;
}

-(NSIndexPath*)indexPathInDataSource:(PLDataSource*)dataSource fromGlobalIndexPath:(NSIndexPath*)globalIndexPath {
    return [NSIndexPath indexPathForRow:globalIndexPath.row
                              inSection:[self sectionIndexInDataSource:dataSource
                                                     fromGlobalSection:globalIndexPath.section]];
}

#pragma mark PLDataSourceDelegate

-(void)dataSourceWillChangeContent:(PLDataSource *)dataSource
{
    if (self.activeContentChangers == 0) {
        [self.delegate dataSourceWillChangeContent:self];
    }
    self.activeContentChangers++;
}

-(void)dataSource:(PLDataSource *)dataSource didInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* globalIndexPath = [self globalIndexPathFromIndexPath:indexPath
                                                         inDataSource:dataSource];
    [self.delegate dataSource:self didInsertObject:object atIndexPath:globalIndexPath];
}

-(void)dataSource:(PLDataSource *)dataSource didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* globalIndexPath = [self globalIndexPathFromIndexPath:indexPath
                                                         inDataSource:dataSource];
    [self.delegate dataSource:self didChangeObject:object atIndexPath:globalIndexPath];
}

-(void)dataSource:(PLDataSource *)dataSource
    didMoveObject:(id)object
      atIndexPath:(NSIndexPath *)indexPath
      toIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath* globalIndexPath = [self globalIndexPathFromIndexPath:indexPath
                                                         inDataSource:dataSource];
    NSIndexPath* globalNewIndexPath = [self globalIndexPathFromIndexPath:newIndexPath
                                                            inDataSource:dataSource];
    
    [self.delegate dataSource:self
                didMoveObject:object
                  atIndexPath:globalIndexPath
                  toIndexPath:globalNewIndexPath];
}

-(void)dataSource:(PLDataSource *)dataSource didRemoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* globalIndexPath = [self globalIndexPathFromIndexPath:indexPath inDataSource:dataSource];
    [self.delegate dataSource:self
              didRemoveObject:object
                  atIndexPath:globalIndexPath];
}

-(void)dataSource:(PLDataSource *)dataSource didInsertSectionAtIndex:(NSUInteger)sectionIndex
{
    NSUInteger globalSection = [self globalSectionIndexFromIndex:sectionIndex inDataSource:dataSource];
    [self.delegate dataSource:self didInsertSectionAtIndex:globalSection];
}

-(void)dataSource:(PLDataSource *)dataSource didRemoveSectionAtIndex:(NSUInteger)sectionIndex
{
    NSUInteger globalSection = [self globalSectionIndexFromIndex:sectionIndex inDataSource:dataSource];
    [self.delegate dataSource:self didRemoveSectionAtIndex:globalSection];
}

-(void)dataSourceDidChangeContent:(PLDataSource *)dataSource
{
    if ((--self.activeContentChangers) == 0) {
        [self.delegate dataSourceDidChangeContent:self];
    }
}

-(void)dataSource:(PLDataSource *)dataSource didRefreshSections:(NSIndexSet *)sectionIndices
{
    NSMutableIndexSet* globalIndexSet = [NSMutableIndexSet new];
    [sectionIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSUInteger globalIndex = [self globalSectionIndexFromIndex:idx inDataSource:dataSource];
        [globalIndexSet addIndex:globalIndex];
    }];
    [self.delegate dataSource:self
           didRefreshSections:globalIndexSet];
}
@end
