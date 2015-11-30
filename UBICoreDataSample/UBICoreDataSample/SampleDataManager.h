//
//  UBICoreDataStoreController.h
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBICoreData.h"

@interface SampleDataManager : NSObject

@property (nonatomic, readonly) UBICoreDataStore *dataStore;

+ (instancetype)sharedManager;

@end
