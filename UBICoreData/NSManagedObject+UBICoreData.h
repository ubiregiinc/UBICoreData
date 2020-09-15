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

+ (nullable instancetype)fetchWithObjectID:(NSManagedObjectID *)objectID context:(NSManagedObjectContext *)context;

+ (NSArray<__kindof NSManagedObject *> *)fetchWithRequest:(void (^)(NSFetchRequest *request))block
                                                  context:(NSManagedObjectContext *)context;
+ (NSArray<__kindof NSManagedObject *> *)fetchInContext:(NSManagedObjectContext *)context
                                              predicate:(nullable id)predicateOrString, ...;

+ (nullable instancetype)fetchSingleInContext:(NSManagedObjectContext *)context
                                    predicate:(nullable id)predicateOrString, ...;
+ (nullable instancetype)fetchSingleInContext:(NSManagedObjectContext *)context
                                    sortByKey:(nullable NSString *)key
                                    ascending:(BOOL)ascending
                                    predicate:(nullable id)predicateOrString, ...;
+ (instancetype)fetchOrInsertSingleInContext:(NSManagedObjectContext *)context
                                   predicate:(nullable id)predicateOrString, ...;

+ (void)fetchAsynchronouslyToContext:(NSManagedObjectContext *)context
                             request:(void (^)(NSFetchRequest *request, NSManagedObjectContext *context))block
                          completion:(void (^)(NSArray<__kindof NSManagedObject *> * _Nullable objects))completion;

- (BOOL)isCommitted;
- (BOOL)obtainPermanentID;
- (NSString *)objectIDString;

@end

NS_ASSUME_NONNULL_END
