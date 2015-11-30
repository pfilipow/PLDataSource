//
//  PLCoreDataStack.m
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import "PLCoreDataStack.h"
#import <CoreData/CoreData.h>

@implementation PLCoreDataStack
@synthesize managedObjectContext = _managedObjectContext;

-(void)setupStack {
    NSManagedObjectModel* mom = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSError* storeError;
    if (![psc addPersistentStoreWithType:NSInMemoryStoreType
                           configuration:nil
                                     URL:nil
                                 options:nil
                                   error:&storeError]) {
        NSAssert(NO, @"Failed to set up core data stack: %@; %@",
                 [storeError localizedDescription], [storeError userInfo]);
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = psc;
}

-(NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        [self setupStack];
    }
    
    return _managedObjectContext;
}

-(void)save {
    NSError* saveError;
    if (![self.managedObjectContext save:&saveError]) {
        NSLog(@"Failed to save managed object context: %@; %@",
              [saveError localizedDescription], [saveError userInfo]);
    }
}

@end
