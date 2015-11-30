//
//  NSManagedObject+UBICoreData.h
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObject (UBICoreData)

+ (NSString *)entityName;

+ (instancetype)insertInContext:(NSManagedObjectContext *)context;

- (void)delete;

+ (void)deleteWithRequest:(void (^)(NSFetchRequest *request))block
                  context:(NSManagedObjectContext *)context;
+ (void)deleteInContext:(NSManagedObjectContext *)context
              predicate:(id)predicateOrString, ...;

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context
                   predicate:(id)predicateOrString, ...;
+ (NSUInteger)countWithRequest:(void (^)(NSFetchRequest *request))block
                       context:(NSManagedObjectContext *)context;

+ (instancetype)fetchWithObjectID:(NSManagedObjectID *)objectID context:(NSManagedObjectContext *)context;

+ (NSArray<__kindof NSManagedObject *> *)fetchWithRequest:(void (^)(NSFetchRequest *request))block
                                                  context:(NSManagedObjectContext *)context;
+ (NSArray<__kindof NSManagedObject *> *)fetchInContext:(NSManagedObjectContext *)context
                                              predicate:(id)predicateOrString, ...;

+ (instancetype)fetchSingleInContext:(NSManagedObjectContext *)context
                           predicate:(id)predicateOrString, ...;
+ (instancetype)fetchSingleInContext:(NSManagedObjectContext *)context
                           sortByKey:(nullable NSString *)key
                           ascending:(BOOL)ascending
                           predicate:(id)predicateOrString, ...;
+ (instancetype)fetchOrInsertSingleInContext:(NSManagedObjectContext *)context
                                   predicate:(id)predicateOrString, ...;

+ (void)fetchAsynchronouslyToContext:(NSManagedObjectContext *)context
                             request:(void (^)(NSFetchRequest *request, NSManagedObjectContext *context))block
                          completion:(void (^)(NSArray<__kindof NSManagedObject *> *objects))completion;

- (BOOL)isPersisted;
- (BOOL)obtainPermanentID;
- (NSString *)objectIDString;

@end

NS_ASSUME_NONNULL_END
