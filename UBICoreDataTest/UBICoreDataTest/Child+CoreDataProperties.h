//
//  Child+CoreDataProperties.h
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/01.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Child.h"

NS_ASSUME_NONNULL_BEGIN

@interface Child (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *parent;

@end

NS_ASSUME_NONNULL_END
