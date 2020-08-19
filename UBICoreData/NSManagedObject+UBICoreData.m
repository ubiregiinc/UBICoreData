//
//  NSManagedObject+UBICoreData.m
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import "NSManagedObject+UBICoreData.h"
#import "NSManagedObjectContext+UBICoreData.h"
#import "NSFetchedResultsController+UBICoreData.h"
#import "NSFetchRequest+UBICoreData.h"
#import "UBICoreDataCommon.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSManagedObject (UBICoreData)

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

+ (instancetype)insertInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

- (void)delete
{
    [[self managedObjectContext] deleteObject:self];
}

+ (void)deleteWithRequest:(void (^)(NSFetchRequest *request))block context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[self class] context:context];
    
    if (block) {
        block(request);
    }
    
    [request setIncludesPropertyValues:NO];
    
    NSError *error;
    NSArray<__kindof NSManagedObject *> *objects = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in objects) {
        [context deleteObject:object];
    }
}

+ (void)deleteInContext:(NSManagedObjectContext *)context predicate:(id)predicateOrString, ...
{
    UBI_SET_PREDICATE_WITH_VARIADIC_ARGS
    
    [self deleteWithRequest:^(NSFetchRequest *request) {
        [request setPredicate:predicate];
    } context:context];
}

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context predicate:(id)predicateOrString, ...
{
    UBI_SET_PREDICATE_WITH_VARIADIC_ARGS
    return [self countWithRequest:^(NSFetchRequest *request) {
        [request setPredicate:predicate];
    } context:context];
}

+ (NSUInteger)countWithRequest:(void (^)(NSFetchRequest *request))block context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[self class] context:context];
    
    if (block) {
        block(request);
    }
    
    NSError *error;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    
    NSAssert(count != NSNotFound, @"%s - %@", __PRETTY_FUNCTION__, error);
    
    return count;
}

+ (nullable instancetype)fetchWithObjectID:(NSManagedObjectID *)objectID context:(NSManagedObjectContext *)context
{
    id object = [context objectRegisteredForID:objectID];
    
    if (object) {
        return object;
    }
    
    object = [context objectWithID:objectID];
    
    if (![object isFault]) {
        return object;
    }
    
    NSError *error;
    object = [context existingObjectWithID:objectID error:&error];
    
    return object;
}

+ (nullable NSArray<__kindof NSManagedObject *> *)fetchWithRequest:(void (^)(NSFetchRequest *request))block context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[self class] context:context];
    
    if (block) {
        block(request);
    }
    
    NSError *error;
    NSArray<__kindof NSManagedObject *> *objects = [context executeFetchRequest:request error:&error];
    
#ifdef DEBUG
    if (error) {
        NSLog(@"%s - error: %@", __PRETTY_FUNCTION__, error);
    }
#endif
    
    return objects;
}

+ (nullable NSArray<__kindof NSManagedObject *> *)fetchInContext:(NSManagedObjectContext *)context predicate:(nullable id)predicateOrString, ...
{
    UBI_SET_PREDICATE_WITH_VARIADIC_ARGS
    
    return [self fetchWithRequest:^(NSFetchRequest *request) {
        [request setPredicate:predicate];
    } context:context];
}

+ (nullable instancetype)fetchSingleInContext:(NSManagedObjectContext *)context predicate:(nullable id)predicateOrString, ...
{
    UBI_SET_PREDICATE_WITH_VARIADIC_ARGS
    
    return [self fetchSingleInContext:context sortByKey:nil ascending:NO predicate:predicate];
}

+ (nullable instancetype)fetchSingleInContext:(NSManagedObjectContext *)context
                                    sortByKey:(nullable NSString *)key
                                    ascending:(BOOL)ascending
                                    predicate:(nullable id)predicateOrString, ...
{
    UBI_SET_PREDICATE_WITH_VARIADIC_ARGS
    
    NSArray<__kindof NSManagedObject *> *objects = [self fetchWithRequest:^(NSFetchRequest *request) {
        [request setFetchLimit:1];
        
        if (predicate) {
            [request setPredicate:predicate];
        }
        
        if (key) {
            [request sortByKey:key ascending:ascending];
        }
    } context:context];
    
    return [objects count] ? objects[0] : nil;
}

+ (instancetype)fetchOrInsertSingleInContext:(NSManagedObjectContext *)context predicate:(nullable id)predicateOrString, ...
{
    UBI_SET_PREDICATE_WITH_VARIADIC_ARGS
    
    id object = [self fetchSingleInContext:context predicate:predicate];
    
    if (object) {
        return object;
    }
    
    return [self insertInContext:context];
}

+ (void)fetchAsynchronouslyToContext:(NSManagedObjectContext *)context
                             request:(void (^)(NSFetchRequest *request, NSManagedObjectContext *context))block
                          completion:(void (^)(NSArray<__kindof NSManagedObject *> * _Nullable objects))completion
{
    NSManagedObjectContext *bgContext = [context newPrivateQueueContext];
    
    [bgContext performBlock:^{
        NSFetchRequest *bgRequest = [NSFetchRequest fetchRequestWithEntity:[self class] context:bgContext];
        
        if (block) {
            block(bgRequest, bgContext);
        }
        
        [bgRequest setResultType:NSManagedObjectIDResultType];
        
        NSError *bgError = nil;
        NSArray *objectIDs = [bgContext executeFetchRequest:bgRequest error:&bgError];
        
        [context performBlock:^{
            NSError *error = nil;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", objectIDs];
            NSFetchRequest *request	= [NSFetchRequest fetchRequestWithEntity:[self class] context:context];
            
            if (block) {
                block(request, context);
            }
            
            [request setPredicate:predicate];
            
            NSArray<__kindof NSManagedObject *> *objects = [context executeFetchRequest:request error:&error];
            
            completion(objects);
        }];
    }];
}

- (BOOL)isCommitted
{
    return [[self committedValuesForKeys:nil] count] > 0;
}

- (BOOL)obtainPermanentID
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] obtainPermanentIDsForObjects:@[self] error:&error]) {
        NSAssert(0, @"%s - error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

- (NSString *)objectIDString
{
    return [[[self objectID] URIRepresentation] absoluteString];
}

@end

NS_ASSUME_NONNULL_END
