//
//  NSFetchRequest+UBICoreData.h
//
//  Created by Yuki Yasoshima on 2015/11/27.
//  Copyright (c) 2015 Yuki Yasoshima. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFetchRequest (UBICoreData)

+ (instancetype)fetchRequestWithEntity:(Class)entityClass context:(NSManagedObjectContext *)context;

- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending;
- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending comparator:(NSComparator)cmptr;
- (void)setPredicateOrString:(id)predicateOrString, ...;

+ (void)setIncludesSubentitiesByDefault:(BOOL)includesSubentities;
+ (BOOL)includesSubentitiesByDefault;

@end

NS_ASSUME_NONNULL_END
