//
//  NSManagedObjectContext+UBICoreData.m
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import "NSManagedObjectContext+UBICoreData.h"
#import "UBICoreDataCommon.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSManagedObjectContext (UBICoreData)

- (NSManagedObjectContext *)newMainQueueContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.parentContext = self;
    
    return context;
}

- (NSManagedObjectContext *)newPrivateQueueContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = self;
    
    return context;
}

- (BOOL)save
{
    return [self saveWithError:nil];
}

- (BOOL)saveWithError:(NSError **)error
{
    if (![self hasChanges]) {
        return YES;
    }
    
    NSError* localError = nil;
    
    if (![self save:&localError]) {
#ifdef DEBUG
        NSLog(@"%s - error: %@", __PRETTY_FUNCTION__, [localError userInfo]);
#endif
        if (error) {
            *error = localError;
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL)saveToPersistentStore
{
    return [self saveToPersistentStoreWithError:nil];
}

- (BOOL)saveToPersistentStoreWithError:(NSError **)error
{
    NSSet *insertedObjects = self.insertedObjects;
    if (insertedObjects.count > 0) {
        NSError *error = nil;
        if (![self obtainPermanentIDsForObjects:insertedObjects.allObjects error:&error]) {
#ifdef DEBUG
            [NSException raise:UBICoreDataExceptionName format:@"%s - error: %@", __PRETTY_FUNCTION__, error];
#endif
        }
    }
    
    if ([self saveWithError:error]) {
        NSManagedObjectContext *context = [self parentContext];
        
        if (!context) {
            return YES;
        }
        
        __block BOOL save = NO;
        
        [context performBlockAndWait:^{
            save = [context saveToPersistentStoreWithError:error];
        }];
        
        return save;
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END
