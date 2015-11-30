//
//  NSFetchRequest+UBICoreData.m
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import "NSFetchRequest+UBICoreData.h"
#import "NSManagedObject+UBICoreData.h"
#import "UBICoreDataCommon.h"

NS_ASSUME_NONNULL_BEGIN

static BOOL _ubr_includesSubentities = NO;

@implementation NSFetchRequest (UBICoreData)

+ (instancetype)fetchRequestWithEntity:(Class)entityClass context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:[entityClass entityName] inManagedObjectContext:context]];
    [request setIncludesSubentities:_ubr_includesSubentities];
    
    return request;
}

- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending
{
    NSMutableArray<NSSortDescriptor *> *descriptors = [[NSMutableArray alloc] initWithArray:[self sortDescriptors] ?: [[NSArray alloc] init]];
    [descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
    [self setSortDescriptors:descriptors];
}

- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending comparator:(NSComparator)cmptr
{
    NSMutableArray<NSSortDescriptor *> *descriptors = [[NSMutableArray alloc] initWithArray:[self sortDescriptors] ?: [[NSArray alloc] init]];
    [descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending comparator:cmptr]];
    [self setSortDescriptors:descriptors];
}

- (void)setPredicateOrString:(id)predicateOrString, ...
{
    UBI_SET_PREDICATE_WITH_VARIADIC_ARGS
    
    [self setPredicate:predicate];
}

+ (void)setIncludesSubentitiesByDefault:(BOOL)includesSubentities
{
    _ubr_includesSubentities = includesSubentities;
}

+ (BOOL)includesSubentitiesByDefault
{
    return _ubr_includesSubentities;
}

@end

NS_ASSUME_NONNULL_END
