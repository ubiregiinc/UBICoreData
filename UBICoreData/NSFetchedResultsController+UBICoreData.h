//
//  NSFetchedResultsController+UBICoreData.h
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFetchedResultsController (UBICoreData)

+ (instancetype)controllerWithRequest:(NSFetchRequest *)request
                              context:(NSManagedObjectContext *)context;
+ (instancetype)controllerWithRequest:(NSFetchRequest *)request
                              context:(NSManagedObjectContext *)context
                   sectionNameKeyPath:(NSString *)keyPath
                            cacheName:(NSString *)cacheName;

- (NSInteger)numberOfObjectsInSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
