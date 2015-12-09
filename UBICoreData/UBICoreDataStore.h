//
//  UBICoreDataStore.h
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface UBICoreDataStore : NSObject

@property (nonatomic, readonly) NSString *modelName;
@property (nonatomic, readonly) NSString *persistentStoreType;
@property (nonatomic, readonly) NSDictionary *persistentStoreOptions;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, readonly) NSManagedObjectContext *storeContext;

@property (nonatomic, readonly) NSURL *storeURL;
@property (nonatomic, readonly) NSString *storePath;
@property (nonatomic, readonly) BOOL storeExists;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithModelName:(NSString *)modelName
                         storeURL:(NSURL *)storeURL;

- (instancetype)initWithModelName:(NSString *)modelName
                         storeURL:(NSURL *)storeURL
              persistentStoreType:(NSString *)storeType
           persistentStoreOptions:(NSDictionary *)storeOptions NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithModel:(NSManagedObjectModel *)model
                     storeURL:(NSURL *)storeURL;

- (instancetype)initWithModel:(NSManagedObjectModel *)model
                     storeURL:(NSURL *)storeURL
          persistentStoreType:(NSString *)storeType
       persistentStoreOptions:(NSDictionary *)storeOptions NS_DESIGNATED_INITIALIZER;

+ (NSDictionary *)defaultPersistentStoreOptions;

@end

NS_ASSUME_NONNULL_END
