//
//  NSFetchRequest+UBICoreDataTests.m
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/03.
//
//

#import "UBICoreDataTestUtils.h"

@interface NSFetchRequest_UBICoreDataTests : XCTestCase

@end

@implementation NSFetchRequest_UBICoreDataTests

- (void)setUp {
    [super setUp];
    
    [UBICoreDataTestUtils resetTestResources];
}

- (void)tearDown {
    [UBICoreDataTestUtils resetTestResources];
    
    [super tearDown];
}

- (void)testFetchRequestWithEntity
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Parent class] context:dataStore.mainContext];
    
    XCTAssertEqualObjects(request.entityName, [Parent entityName]);
}

- (void)testSortByKey
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Parent class] context:dataStore.mainContext];
    
    XCTAssertEqual(request.sortDescriptors.count, 0);
    
    [request sortByKey:@"name" ascending:YES];
    
    XCTAssertEqual(request.sortDescriptors.count, 1);
    
    NSSortDescriptor *nameSortDesc = request.sortDescriptors.firstObject;
    XCTAssertEqualObjects(nameSortDesc.key, @"name");
    XCTAssertTrue(nameSortDesc.ascending);
    
    [request sortByKey:@"age" ascending:NO];
    
    XCTAssertEqual(request.sortDescriptors.count, 2);
    
    NSSortDescriptor *ageSortDesc = request.sortDescriptors.lastObject;
    XCTAssertEqualObjects(ageSortDesc.key, @"age");
    XCTAssertFalse(ageSortDesc.ascending);
}

- (void)testSortByKeyWithComparator
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Parent class] context:dataStore.mainContext];
    
    XCTAssertEqual(request.sortDescriptors.count, 0);
    
    [request sortByKey:@"name" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSSortDescriptor *sortDesc = request.sortDescriptors.firstObject;
    XCTAssertEqualObjects(sortDesc.key, @"name");
    XCTAssertTrue(sortDesc.ascending);
    
    NSComparator comparator = sortDesc.comparator;
    XCTAssertNotNil(comparator);
    XCTAssertTrue(comparator(@"a", @"b") == NSOrderedAscending);
    XCTAssertTrue(comparator(@"b", @"a") == NSOrderedDescending);
    XCTAssertTrue(comparator(@"a", @"a") == NSOrderedSame);
}

- (void)testSetPredicateOrStringByPredicate
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Parent class] context:dataStore.mainContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    [request setPredicateOrString:predicate];
    
    XCTAssertEqualObjects(request.predicate, predicate);
}

- (void)testSetPredicateOrStringByString
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Parent class] context:dataStore.mainContext];
    
    [request setPredicateOrString:@"FALSEPREDICATE"];
    
    XCTAssertEqualObjects(request.predicate.predicateFormat, @"FALSEPREDICATE");
}

- (void)testIncludesSubentitiesByDefault
{
    XCTAssertFalse([NSFetchRequest includesSubentitiesByDefault]);
    
    [NSFetchRequest setIncludesSubentitiesByDefault:YES];
    
    XCTAssertTrue([NSFetchRequest includesSubentitiesByDefault]);
    
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Parent class] context:dataStore.mainContext];
    
    XCTAssertTrue(request.includesSubentities);
}

@end
