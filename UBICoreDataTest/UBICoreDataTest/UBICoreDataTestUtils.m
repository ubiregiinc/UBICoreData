//
//  UBICoreDataTestUtils.m
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/01.
//
//

#import "UBICoreDataTestUtils.h"

@implementation UBICoreDataTestUtils

+ (NSURL *)documentsDirectory
{
    return [[[[NSFileManager alloc] init] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (void)clearDocumentsDirectory
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *directory = [self documentsDirectory];
    NSArray<NSURL *> *contents = [fileManager contentsOfDirectoryAtURL:directory includingPropertiesForKeys:nil options:kNilOptions error:nil];
    for (NSURL *url in contents) {
        [fileManager removeItemAtURL:url error:nil];
    }
}

+ (void)resetTestResources
{
    [self clearDocumentsDirectory];
    [NSFetchRequest setIncludesSubentitiesByDefault:NO];
}

+ (NSString *)testModelName
{
    return @"TestModel";
}

+ (UBICoreDataStore *)createTestDataStore
{
    NSURL *documentDirectory = [UBICoreDataTestUtils documentsDirectory];
    NSURL *storeURL = [documentDirectory URLByAppendingPathComponent:@"Test.sqlite"];
    return [[UBICoreDataStore alloc] initWithModelName:[UBICoreDataTestUtils testModelName]
                                              storeURL:storeURL];
}

@end
