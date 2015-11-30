//
//  UBICoreDataStoreController.m
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import "SampleDataManager.h"

@interface SampleDataManager ()

@property (nonatomic) UBICoreDataStore *dataStore;

@end

@implementation SampleDataManager

+ (instancetype)sharedManager
{
    static SampleDataManager *_controller = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _controller = [[SampleDataManager alloc] init];
    });
    
    return _controller;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *storeURL = [[SampleDataManager _applicationDocumentsDirectory] URLByAppendingPathComponent:@"Sample.sqlite"];
        self.dataStore = [[UBICoreDataStore alloc] initWithModelName:@"Sample" storeURL:storeURL];
    }
    return self;
}

#pragma mark -

+ (NSURL *)_applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
