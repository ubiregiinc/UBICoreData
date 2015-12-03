//
//  UBICoreDataTestUtils.h
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/01.
//
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "UBICoreData.h"
#import "Parent.h"
#import "Child.h"

@interface UBICoreDataTestUtils : NSObject

+ (NSURL *)documentsDirectory;
+ (void)clearDocumentsDirectory;

+ (void)resetTestResources;

+ (NSString *)testModelName;

+ (UBICoreDataStore *)createTestDataStore;

@end
