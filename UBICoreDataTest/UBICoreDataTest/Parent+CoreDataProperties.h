//
//  Parent+CoreDataProperties.h
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/01.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Parent.h"

NS_ASSUME_NONNULL_BEGIN

@interface Parent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Child *> *children;

@end

@interface Parent (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Child *)value;
- (void)removeChildrenObject:(Child *)value;
- (void)addChildren:(NSSet<Child *> *)values;
- (void)removeChildren:(NSSet<Child *> *)values;

@end

NS_ASSUME_NONNULL_END
