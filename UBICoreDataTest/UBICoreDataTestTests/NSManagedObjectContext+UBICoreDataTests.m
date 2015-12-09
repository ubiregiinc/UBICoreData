//
//  NSManagedObjectContext+UBICoreDataTests.m
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/02.
//
//

#import "UBICoreDataTestUtils.h"

@interface NSManagedObjectContext_UBICoreDataTests : XCTestCase

@end

@implementation NSManagedObjectContext_UBICoreDataTests

- (void)setUp {
    [super setUp];
    
    [UBICoreDataTestUtils resetTestResources];
}

- (void)tearDown {
    [UBICoreDataTestUtils resetTestResources];
    
    [super tearDown];
}

- (void)testSaveToPersistentStore {
    UBICoreDataStore *writeDataStore = [UBICoreDataTestUtils createTestDataStore];
    
    Parent *writeParent = [Parent insertInContext:writeDataStore.mainContext];
    writeParent.name = @"test_name";
    
    [writeDataStore.mainContext saveToPersistentStore];
    
    writeDataStore = nil;
    
    UBICoreDataStore *readDataStore = [UBICoreDataTestUtils createTestDataStore];
    
    Parent *readParent = [Parent fetchSingleInContext:readDataStore.mainContext predicate:@"TRUEPREDICATE"];
    
    XCTAssertNotNil(readParent);
    XCTAssertEqualObjects(readParent.name, @"test_name");
}

- (void)testNewMainQueueContext
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSManagedObjectContext *context = [dataStore.mainContext newMainQueueContext];
    
    XCTAssertEqual(context.concurrencyType, NSMainQueueConcurrencyType);
    XCTAssertEqualObjects(context.parentContext, dataStore.mainContext);
}

- (void)testNewPrivateQueueContext
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSManagedObjectContext *context = [dataStore.mainContext newPrivateQueueContext];
    
    XCTAssertEqual(context.concurrencyType, NSPrivateQueueConcurrencyType);
    XCTAssertEqualObjects(context.parentContext, dataStore.mainContext);
}

@end
