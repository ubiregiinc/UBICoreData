//
//  UBICoreDataStore.m
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import "UBICoreDataStore.h"
#import "UBICoreDataCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface UBICoreDataStore()

@property (nonatomic) NSString *modelName;
@property (nonatomic) NSURL *storeURL;
@property (nonatomic) NSString *persistentStoreType;
@property (nonatomic) NSDictionary *persistentStoreOptions;

@end

@implementation UBICoreDataStore {
    NSManagedObjectContext *_mainContext;
    NSManagedObjectContext *_storeContext;
    NSManagedObjectModel *_model;
    NSPersistentStoreCoordinator *_storeCoordinator;
}

- (instancetype)initWithModelName:(NSString *)modelName
                         storeURL:(NSURL *)storeURL
{
    return [self initWithModelName:modelName
                          storeURL:storeURL
               persistentStoreType:NSSQLiteStoreType
            persistentStoreOptions:[[self class] defaultPersistentStoreOptions]];
}

- (instancetype)initWithModelName:(NSString *)modelName
                         storeURL:(NSURL *)storeURL
              persistentStoreType:(NSString *)storeType
           persistentStoreOptions:(NSDictionary *)storeOptions
{
    self = [super init];
    if (self) {
        self.modelName = modelName;
        self.storeURL = storeURL;
        self.persistentStoreType = storeType;
        self.persistentStoreOptions = storeOptions;
    }
    return self;
}

- (NSManagedObjectContext *)mainContext
{
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setParentContext:self.storeContext];
    }
    
    return _mainContext;
}

- (NSManagedObjectContext *)storeContext
{
    if (!_storeContext) {
        _storeContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_storeContext setPersistentStoreCoordinator:self.storeCoordinator];
    }
    
    return _storeContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_model) {
        NSURL* url = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
        _model	= [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    }
    
    return _model;
}

- (NSPersistentStoreCoordinator *)storeCoordinator
{
    if (!_storeCoordinator) {
        NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        _storeCoordinator = storeCoordinator;
        
        NSError* error = nil;
        if (![_storeCoordinator addPersistentStoreWithType:self.persistentStoreType
                                             configuration:nil
                                                       URL:self.storeURL
                                                   options:self.persistentStoreOptions
                                                    error:&error]) {
#ifdef DEBUG
            [NSException raise:UBICoreDataExceptionName format:@"%s - error: %@", __PRETTY_FUNCTION__, error];
#endif
        }
    }
    
    return _storeCoordinator;
}

- (NSString *)storePath
{
    return [self.storeURL path];
}

- (BOOL)storeExists
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    return [fileManager fileExistsAtPath:self.storePath];
}

#pragma mark -

+ (NSDictionary *)defaultPersistentStoreOptions
{
    return @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
}

@end

NS_ASSUME_NONNULL_END
