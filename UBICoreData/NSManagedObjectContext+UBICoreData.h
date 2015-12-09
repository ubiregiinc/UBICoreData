//
//  NSManagedObjectContext+UBICoreData.h
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectContext (UBICoreData)

- (NSManagedObjectContext *)newMainQueueContext;
- (NSManagedObjectContext *)newPrivateQueueContext;

- (BOOL)save;
- (BOOL)saveToPersistentStore;

@end

NS_ASSUME_NONNULL_END
