//
//  PLCoreDataStack.h
//  PLDataSource
//
//  Created by Hirad Motamed on 2015-11-15.
//  Copyright © 2015 Hirad Motamed. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface PLCoreDataStack : NSObject

@property (nonatomic, readonly) NSManagedObjectContext* managedObjectContext;

-(void)save;

@end
