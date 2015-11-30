//
//  NSFetchedResultsController+UBICoreData.m
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import "NSFetchedResultsController+UBICoreData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSFetchedResultsController (UBICoreData)

+ (instancetype)controllerWithRequest:(NSFetchRequest *)request
                              context:(NSManagedObjectContext *)context
{
    return [[self alloc] initWithFetchRequest:request
                         managedObjectContext:context
                           sectionNameKeyPath:nil
                                    cacheName:nil];
}

+ (instancetype)controllerWithRequest:(NSFetchRequest *)request
                              context:(NSManagedObjectContext *)context
                   sectionNameKeyPath:(NSString *)keyPath
                            cacheName:(NSString *)cacheName
{
    return [[self alloc] initWithFetchRequest:request
                         managedObjectContext:context
                           sectionNameKeyPath:keyPath
                                    cacheName:cacheName];
}

- (NSInteger)numberOfObjectsInSection:(NSInteger)section
{
    return [(id<NSFetchedResultsSectionInfo>)[self sections][section] numberOfObjects];
}

@end

NS_ASSUME_NONNULL_END
