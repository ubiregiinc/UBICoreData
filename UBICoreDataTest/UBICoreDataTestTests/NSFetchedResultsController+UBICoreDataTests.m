//
//  NSFetchedResultsController+UBICoreDataTests.m
//  UBICoreDataTest
//
//  Created by Yuki Yasoshima on 2015/12/03.
//
//

#import "UBICoreDataTestUtils.h"

@interface NSFetchedResultsController_UBICoreDataTests : XCTestCase

@end

@implementation NSFetchedResultsController_UBICoreDataTests

- (void)setUp {
    [super setUp];
    
    [UBICoreDataTestUtils resetTestResources];
}

- (void)tearDown {
    [UBICoreDataTestUtils resetTestResources];
    
    [super tearDown];
}

- (void)testCreateFetchedResultsController
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Parent class] context:dataStore.mainContext];
    [request sortByKey:@"name" ascending:YES];
    
    NSFetchedResultsController *controller = [NSFetchedResultsController controllerWithRequest:request context:dataStore.mainContext];
    
    XCTAssertEqualObjects(controller.fetchRequest, request);
    XCTAssertEqualObjects(controller.managedObjectContext, dataStore.mainContext);
    XCTAssertNil(controller.sectionNameKeyPath);
    XCTAssertNil(controller.cacheName);
}

- (void)testCreateFetchedResultsControllerWithFullParameters
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Child class] context:dataStore.mainContext];
    [request sortByKey:@"name" ascending:YES];
    
    NSFetchedResultsController *controller = [NSFetchedResultsController controllerWithRequest:request context:dataStore.mainContext sectionNameKeyPath:@"parent" cacheName:@"test_cache"];
    
    XCTAssertEqualObjects(controller.fetchRequest, request);
    XCTAssertEqualObjects(controller.managedObjectContext, dataStore.mainContext);
    XCTAssertEqualObjects(controller.sectionNameKeyPath, @"parent");
    XCTAssertEqualObjects(controller.cacheName, @"test_cache");
}

- (void)testNumberOfObjectsInSection
{
    UBICoreDataStore *dataStore = [UBICoreDataTestUtils createTestDataStore];
    
    Parent *parent1 = [Parent insertInContext:dataStore.mainContext];
    Parent *parent2 = [Parent insertInContext:dataStore.mainContext];
    Child *child1 = [Child insertInContext:dataStore.mainContext];
    Child *child2 = [Child insertInContext:dataStore.mainContext];
    Child *child3 = [Child insertInContext:dataStore.mainContext];
    Child *child4 = [Child insertInContext:dataStore.mainContext];
    Child *child5 = [Child insertInContext:dataStore.mainContext];
    parent1.name = @"parent1";
    parent2.name = @"parent2";
    child1.name = @"child1";
    child2.name = @"child2";
    child3.name = @"child3";
    child4.name = @"child4";
    child5.name = @"child5";
    
    child1.parent = parent1;
    child2.parent = parent1;
    child3.parent = parent2;
    child4.parent = parent2;
    child5.parent = parent2;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Child class] context:dataStore.mainContext];
    [request sortByKey:@"name" ascending:YES];
    
    NSFetchedResultsController *controller = [NSFetchedResultsController controllerWithRequest:request context:dataStore.mainContext sectionNameKeyPath:@"parent.name" cacheName:nil];
    
    XCTAssertTrue([controller performFetch:nil]);
    
    XCTAssertEqual(controller.sections.count, 2);
    XCTAssertEqual([controller numberOfObjectsInSection:0], 2);
    XCTAssertEqual([controller numberOfObjectsInSection:1], 3);
}

@end
