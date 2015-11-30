//
//  Book+CoreDataProperties.h
//  UBICoreDataSample
//
//  Created by Yuki Yasoshima on 2015/11/30.
//  Copyright © 2015年 Yuki Yasoshima. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
