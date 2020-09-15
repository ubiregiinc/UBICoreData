//
//  NSManagedObject+UBICoreDataTests.m
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/03.
//
//

#import "UBICoreDataTestUtils.h"

@interface NSManagedObject_UBICoreDataTests : XCTestCase

@end

@implementation NSManagedObject_UBICoreDataTests

- (void)setUp {
    [super setUp];
    
    [UBICoreDataTestUtils resetTestResources];
}

- (void)tearDown {
    [UBICoreDataTestUtils resetTestResources];
    
    [super tearDown];
}

- (void)testEntityName
{
    XCTAssertEqualObjects([Parent entityName], @"Parent");
    XCTAssertEqualObjects([Child entityName], @"Child");
}

- (void)testInsert
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 0);
    
    Parent *insertedParent = [Parent insertInContext:dataStore.mainContext];
    
    NSArray *fetchedParents = [Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"];
    
    XCTAssertEqual(fetchedParents.count, 1);
    XCTAssertEqualObjects(fetchedParents.firstObject, insertedParent);
}

- (void)testPredicateOrStringByPredicate
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent = [Parent insertInContext:dataStore.mainContext];
    parent.name = @"test_name";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"test_name"];
    Parent *fetchedParent = [Parent fetchSingleInContext:dataStore.mainContext predicate:predicate];
    
    XCTAssertEqualObjects(parent, fetchedParent);
}

- (void)testPredicateOrStringByString
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent = [Parent insertInContext:dataStore.mainContext];
    parent.name = @"test_name";
    
    Parent *fetchedParent = [Parent fetchSingleInContext:dataStore.mainContext predicate:@"name == %@", @"test_name"];
    
    XCTAssertEqualObjects(parent, fetchedParent);
}

- (void)testPredicateOrStringByNil
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    [Parent insertInContext:dataStore.mainContext];
    [Parent insertInContext:dataStore.mainContext];
    [Parent insertInContext:dataStore.mainContext];
    
    NSArray *fetchedParents = [Parent fetchInContext:dataStore.mainContext predicate:nil];
    
    XCTAssertEqual(fetchedParents.count, 3);
}

- (void)testDelete
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent = [Parent insertInContext:dataStore.mainContext];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 1);
    
    [parent delete];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 0);
}

- (void)testDeleteWithRequest
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 2);
    
    [Parent deleteWithRequest:^(NSFetchRequest * _Nonnull request) {
        [request setPredicateOrString:@"SELF == %@", parent2];
    } context:dataStore.mainContext];
    
    NSArray *fetchedParents = [Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"];
    
    XCTAssertEqual(fetchedParents.count, 1);
    XCTAssertEqualObjects(fetchedParents.firstObject, parent1);
}

- (void)testDeleteWithPredicate
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 2);
    
    [Parent deleteInContext:dataStore.mainContext predicate:@"SELF == %@", parent2];
    
    NSArray *fetchedParents = [Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"];
    
    XCTAssertEqual(fetchedParents.count, 1);
    XCTAssertEqualObjects(fetchedParents.firstObject, parent1);
}

- (void)testGetCountWithPredicate
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent3 = [Parent insertInContext:dataStore.mainContext];
    parent1.name = @"test_name_1";
    parent2.name = @"test_name_2";
    parent3.name = @"test_name_3";
    
    XCTAssertEqual(([Parent countInContext:dataStore.mainContext predicate:@"name CONTAINS %@", @"test_name"]), 3);
    XCTAssertEqual(([Parent countInContext:dataStore.mainContext predicate:@"name == %@", @"test_name_2"]), 1);
    XCTAssertEqual(([Parent countInContext:dataStore.mainContext predicate:@"name == %@", @"hoge"]), 0);
}

- (void)testGetCountWithRequest
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent3 = [Parent insertInContext:dataStore.mainContext];
    parent1.name = @"test_name_1";
    parent2.name = @"test_name_2";
    parent3.name = @"test_name_3";
    
    XCTAssertEqual(([Parent countWithRequest:^(NSFetchRequest * _Nonnull request) {
        [request setPredicateOrString:@"name CONTAINS %@", @"test_name"];
    } context:dataStore.mainContext]), 3);
    XCTAssertEqual(([Parent countWithRequest:^(NSFetchRequest * _Nonnull request) {
        [request setPredicateOrString:@"name == %@", @"test_name_2"];
    } context:dataStore.mainContext]), 1);
    XCTAssertEqual(([Parent countWithRequest:^(NSFetchRequest * _Nonnull request) {
        [request setPredicateOrString:@"name == %@", @"hoge"];
    } context:dataStore.mainContext]), 0);
}

- (void)testFetchWithObjectID
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent = [Parent insertInContext:dataStore.mainContext];
    
    NSManagedObjectID *unsavedObjectID = parent.objectID;
    
    Parent *unsavedFetchedParent = [Parent fetchWithObjectID:unsavedObjectID context:dataStore.mainContext];
    
    XCTAssertEqualObjects(parent, unsavedFetchedParent);
    
    [dataStore.mainContext saveToPersistentStore];
    
    NSManagedObjectID *savedObjectID = parent.objectID;
    
    Parent *savedFetchedParent = [Parent fetchWithObjectID:savedObjectID context:dataStore.mainContext];
    
    XCTAssertEqualObjects(parent, savedFetchedParent);
}

- (void)testFetchWithRequest
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent3 = [Parent insertInContext:dataStore.mainContext];
    parent1.name = @"test_name_1";
    parent2.name = @"test_name_2";
    parent3.name = @"test_name_3";
    
    NSArray *fetchedParents = [Parent fetchWithRequest:^(NSFetchRequest * _Nonnull request) {
        [request setPredicateOrString:@"name CONTAINS %@", @"test_name"];
    } context:dataStore.mainContext];
    
    XCTAssertEqual(fetchedParents.count, 3);
    
    fetchedParents = [Parent fetchWithRequest:^(NSFetchRequest * _Nonnull request) {
        [request setPredicateOrString:@"name == %@", @"test_name_2"];
    } context:dataStore.mainContext];
    
    XCTAssertEqual(fetchedParents.count, 1);
    XCTAssertEqualObjects(fetchedParents.firstObject, parent2);
    
    fetchedParents = [Parent fetchWithRequest:^(NSFetchRequest * _Nonnull request) {
        [request setPredicateOrString:@"name == %@", @"hoge"];
    } context:dataStore.mainContext];
    
    XCTAssertEqual(fetchedParents.count, 0);
}

- (void)testFetchWithPredicate
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent3 = [Parent insertInContext:dataStore.mainContext];
    parent1.name = @"test_name_1";
    parent2.name = @"test_name_2";
    parent3.name = @"test_name_3";
    
    NSArray *fetchedParents = [Parent fetchInContext:dataStore.mainContext predicate:@"name CONTAINS %@", @"test_name"];
    
    XCTAssertEqual(fetchedParents.count, 3);
    
    fetchedParents = [Parent fetchInContext:dataStore.mainContext predicate:@"name == %@", @"test_name_2"];
    
    XCTAssertEqual(fetchedParents.count, 1);
    XCTAssertEqualObjects(fetchedParents.firstObject, parent2);
    
    fetchedParents = [Parent fetchInContext:dataStore.mainContext predicate:@"name == %@", @"hoge"];
    
    XCTAssertEqual(fetchedParents.count, 0);
}

- (void)testFetchSingleWithFullParameters
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent3 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent4 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent5 = [Parent insertInContext:dataStore.mainContext];
    parent1.name = @"test_name_1";
    parent2.name = @"test_name_2";
    parent3.name = @"test_name_3";
    parent4.name = @"z";
    parent5.name = @"";
    
    XCTAssertEqualObjects(([Parent fetchSingleInContext:dataStore.mainContext sortByKey:@"name" ascending:YES predicate:@"name CONTAINS 'test_name'"]), parent1);
    XCTAssertEqualObjects(([Parent fetchSingleInContext:dataStore.mainContext sortByKey:@"name" ascending:NO predicate:@"name CONTAINS 'test_name'"]), parent3);
}

- (void)testFetchOrInsertSingle
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 0);
    
    Parent *parent1 = [Parent fetchOrInsertSingleInContext:dataStore.mainContext predicate:@"name == 'test_name_1'"];
    Parent *parent2 = [Parent fetchOrInsertSingleInContext:dataStore.mainContext predicate:@"name == 'test_name_1'"];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 2);
    
    parent1.name = @"test_name_1";
    parent2.name = @"test_name_2";
    
    Parent *parent3 = [Parent fetchOrInsertSingleInContext:dataStore.mainContext predicate:@"name == 'test_name_1'"];
    
    XCTAssertEqual([Parent fetchInContext:dataStore.mainContext predicate:@"TRUEPREDICATE"].count, 2);
    XCTAssertEqualObjects(parent1, parent3);
}

- (void)testFetchAsynchronously
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    parent1.name = @"test_name_1";
    parent2.name = @"test_name_2";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"fetch completion"];
    
    [Parent fetchAsynchronouslyToContext:dataStore.mainContext request:^(NSFetchRequest * _Nonnull request, NSManagedObjectContext * _Nonnull context) {
        [request setPredicateOrString:@"name == 'test_name_1'"];
    } completion:^(NSArray<__kindof NSManagedObject *> * _Nonnull objects) {
        XCTAssertTrue([NSThread isMainThread]);
        XCTAssertEqual(objects.count, 1);
        XCTAssertEqualObjects(objects.firstObject, parent1);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:NULL];
}

- (void)testFetchAsynchronouslyWithFetchLimitAndSort
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent5 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent3 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent4 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    
    parent1.name = @"1";
    parent5.name = @"5";
    parent3.name = @"3";
    parent4.name = @"4";
    parent2.name = @"2";
    
    [dataStore.mainContext saveToPersistentStore];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"fetch completion"];
    
    [Parent fetchAsynchronouslyToContext:dataStore.mainContext request:^(NSFetchRequest * _Nonnull request, NSManagedObjectContext * _Nonnull context) {
        request.fetchLimit = 2;
        [request sortByKey:@"name" ascending:NO];
    } completion:^(NSArray<__kindof NSManagedObject *> * _Nonnull objects) {
        XCTAssertEqual(objects.count, 2);
        
        XCTAssertEqualObjects([objects[0] name], @"5");
        XCTAssertEqualObjects([objects[1] name], @"4");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:NULL];
}

- (void)testIsCommitted
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent = [Parent insertInContext:dataStore.mainContext];
    
    XCTAssertFalse(parent.isCommitted);
    
    [dataStore.mainContext save];
    
    XCTAssertTrue(parent.isCommitted);
}

- (void)testObtainPermanentID
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent = [Parent insertInContext:dataStore.mainContext];
    
    NSManagedObjectID *prevObjectID = parent.objectID;
    
    XCTAssertTrue(parent.obtainPermanentID);
    
    NSManagedObjectID *postObjectID = parent.objectID;
    
    XCTAssertNotEqualObjects(prevObjectID, postObjectID);
}

- (void)testObjectIDString
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    Parent *parent = [Parent insertInContext:dataStore.mainContext];
    
    XCTAssertEqualObjects(parent.objectIDString, [[parent.objectID URIRepresentation] absoluteString]);
}

@end
