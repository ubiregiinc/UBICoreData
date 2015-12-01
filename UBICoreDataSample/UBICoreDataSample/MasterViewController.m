//
//  MasterViewController.m
//  UBICoreDataSample
//
//  Created by Yuki Yasoshima on 2015/11/30.
//  Copyright © 2015年 Yuki Yasoshima. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SampleDataManager.h"
#import "Book.h"

@interface MasterViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) SampleDataManager *dataManager;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.dataManager = [SampleDataManager sharedManager];
    NSManagedObjectContext *context = self.dataManager.dataStore.mainContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[Book class] context:context];
    [request sortByKey:@"title" ascending:YES];
    self.fetchedResultsController = [NSFetchedResultsController controllerWithRequest:request context:context];
    self.fetchedResultsController.delegate = self;
    
    [self.fetchedResultsController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender {
    Book *book = [Book insertInContext:self.dataManager.dataStore.mainContext];
    [self.dataManager.dataStore.mainContext saveToPersistentStore];
    book.title = [[NSDate date] description];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *title = [self bookForIndexPath:indexPath].title;
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:title];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController numberOfObjectsInSection:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self bookForIndexPath:indexPath].title;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self bookForIndexPath:indexPath] delete];
        [self.dataManager.dataStore.mainContext saveToPersistentStore];
    }
}

- (Book *)bookForIndexPath:(NSIndexPath *)indexPath
{
    return self.fetchedResultsController.sections[0].objects[indexPath.row];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
