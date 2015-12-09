//
//  UBICoreDataStoreTests.m
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/01.
//
//

#import "UBICoreDataTestUtils.h"

@interface UBICoreDataStoreTests : XCTestCase

@end

@implementation UBICoreDataStoreTests

- (void)setUp {
    [super setUp];
    
    [UBICoreDataTestUtils resetTestResources];
}

- (void)tearDown {
    [UBICoreDataTestUtils resetTestResources];
    
    [super tearDown];
}

- (void)testCreateDataStoreFullParameters {
    NSURL *documentDirectory = [UBICoreDataTestUtils documentsDirectory];
    NSURL *storeURL = [documentDirectory URLByAppendingPathComponent:@"Test.sqlite"];
    UBICoreDataStore *dataStore = [[UBICoreDataStore alloc] initWithModelName:[UBICoreDataTestUtils testModelName]
                                                                     storeURL:storeURL
                                                          persistentStoreType:NSSQLiteStoreType
                                                       persistentStoreOptions:[UBICoreDataStore defaultPersistentStoreOptions]];
    
    XCTAssertFalse(dataStore.storeExists);
    
    XCTAssertEqualObjects(dataStore.modelName, [UBICoreDataTestUtils testModelName]);
    XCTAssertEqualObjects(dataStore.persistentStoreType, NSSQLiteStoreType);
    XCTAssertEqualObjects(dataStore.persistentStoreOptions, [UBICoreDataStore defaultPersistentStoreOptions]);
    XCTAssertEqualObjects(dataStore.storeURL, storeURL);
    XCTAssertEqualObjects(dataStore.storePath, storeURL.path);
    
    XCTAssertNotNil(dataStore.mainContext);
    XCTAssertEqual(dataStore.mainContext.concurrencyType, NSMainQueueConcurrencyType);
    XCTAssertEqualObjects(dataStore.mainContext.parentContext, dataStore.storeContext);
    XCTAssertNotNil(dataStore.storeContext);
    XCTAssertEqual(dataStore.storeContext.concurrencyType, NSPrivateQueueConcurrencyType);
    XCTAssertNil(dataStore.storeContext.parentContext);
    XCTAssertNotNil(dataStore.storeCoordinator);
    XCTAssertNotNil(dataStore.managedObjectModel);
    
    XCTAssertTrue(dataStore.storeExists);
}

- (void)testCreateDataStore {
    NSURL *documentDirectory = [UBICoreDataTestUtils documentsDirectory];
    NSURL *storeURL = [documentDirectory URLByAppendingPathComponent:@"Test.sqlite"];
    UBICoreDataStore *dataStore = [[UBICoreDataStore alloc] initWithModelName:[UBICoreDataTestUtils testModelName]
                                                                     storeURL:storeURL];
    
    XCTAssertFalse(dataStore.storeExists);
    
    XCTAssertEqualObjects(dataStore.modelName, [UBICoreDataTestUtils testModelName]);
    XCTAssertEqualObjects(dataStore.persistentStoreType, NSSQLiteStoreType);
    XCTAssertEqualObjects(dataStore.persistentStoreOptions, [UBICoreDataStore defaultPersistentStoreOptions]);
    XCTAssertEqualObjects(dataStore.storeURL, storeURL);
    XCTAssertEqualObjects(dataStore.storePath, storeURL.path);
    
    XCTAssertNotNil(dataStore.mainContext);
    XCTAssertEqual(dataStore.mainContext.concurrencyType, NSMainQueueConcurrencyType);
    XCTAssertEqualObjects(dataStore.mainContext.parentContext, dataStore.storeContext);
    XCTAssertNotNil(dataStore.storeContext);
    XCTAssertEqual(dataStore.storeContext.concurrencyType, NSPrivateQueueConcurrencyType);
    XCTAssertNil(dataStore.storeContext.parentContext);
    XCTAssertNotNil(dataStore.storeCoordinator);
    XCTAssertNotNil(dataStore.managedObjectModel);
    
    XCTAssertTrue(dataStore.storeExists);
}

- (void)testCreateDataStoreWithModel {
    NSURL* url = [[NSBundle mainBundle] URLForResource:[UBICoreDataTestUtils testModelName] withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    NSURL *documentDirectory = [UBICoreDataTestUtils documentsDirectory];
    NSURL *storeURL = [documentDirectory URLByAppendingPathComponent:@"Test.sqlite"];
    UBICoreDataStore *dataStore = [[UBICoreDataStore alloc] initWithModel:model
                                                                 storeURL:storeURL
                                                      persistentStoreType:NSSQLiteStoreType
                                                   persistentStoreOptions:[UBICoreDataStore defaultPersistentStoreOptions]];
    
    XCTAssertEqualObjects(dataStore.managedObjectModel, model);
    XCTAssertNil(dataStore.modelName);
}

@end
