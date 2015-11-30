//
//  NSManagedObjectContext+UBICoreData.m
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import "NSManagedObjectContext+UBICoreData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSManagedObjectContext (UBICoreData)

+ (NSManagedObjectContext *)mainQueueContextWithParentContext:(NSManagedObjectContext *)parentContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.parentContext = parentContext;
    
    return context;
}

+ (NSManagedObjectContext *)privateQueueContextWithParentContext:(NSManagedObjectContext *)parentContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = parentContext;
    
    return context;
}

- (BOOL)save
{
    if (![self hasChanges]) {
        return YES;
    }
    
    NSError* error = nil;
    
    if (![self save:&error]) {
#ifdef DEBUG
        NSLog(@"%s - error: %@", __PRETTY_FUNCTION__, [error userInfo]);
#endif
        return NO;
    }
    
    return YES;
}

- (BOOL)saveToPersistentStore
{
    NSSet *insertedObjects = self.insertedObjects;
    if (insertedObjects.count > 0) {
        NSError *error = nil;
        NSAssert([self obtainPermanentIDsForObjects:insertedObjects.allObjects error:&error], @"%s - error: %@", __PRETTY_FUNCTION__, error);
    }
    
    if ([self save]) {
        NSManagedObjectContext *context = [self parentContext];
        
        if (!context) {
            return YES;
        }
        
        __block BOOL save = NO;
        
        [context performBlockAndWait:^{
            save = [context saveToPersistentStore];
        }];
        
        return save;
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END
