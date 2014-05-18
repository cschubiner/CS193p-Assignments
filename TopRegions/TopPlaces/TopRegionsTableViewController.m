//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "FlickrDatabase.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "Photographer.h"
#import "PhotosTableViewController.h"
#import "Region.h"
#import "TopRegionsTableViewController.h"

@interface TopRegionsTableViewController ()
@end

@implementation TopRegionsTableViewController

static const int NUM_DISPLAY_REGIONS = 50;

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
	}
    
	return self;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	_managedObjectContext = managedObjectContext;
	[self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
	if (self.managedObjectContext) {
		NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
		request.predicate = nil; // this means ALL Regions
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"numPhotographers" ascending:NO],
                                    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
        
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
	}
	else {
		self.fetchedResultsController = nil;
	}
}

- (IBAction)refresh
{
	[self.refreshControl beginRefreshing];
	[[FlickrDatabase sharedDefaultFlickrDatabase] fetchWithCompletionHandler:^(BOOL success) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	FlickrDatabase * flickrdb = [FlickrDatabase sharedDefaultFlickrDatabase];
	if (flickrdb.managedObjectContext) {
		self.managedObjectContext = flickrdb.managedObjectContext;
	}
	else {
		id observer = [[NSNotificationCenter defaultCenter] addObserverForName:FlickrDatabaseAvailable
                                                                        object:flickrdb
                                                                         queue:[NSOperationQueue mainQueue]
                                                                    usingBlock:^(NSNotification * note) {
                                                                        self.managedObjectContext = flickrdb.managedObjectContext;
                                                                        [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                    }];
	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return MIN(NUM_DISPLAY_REGIONS, [super tableView:tableView numberOfRowsInSection:section]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"RegionCell"];
    
	Region * region = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = region.name;
	unsigned long photographersCount = [region.photographers count];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu photographer%@", photographersCount, photographersCount == 1 ? @"" :@"s"];
    
	return cell;
}















#pragma mark - Table view data source





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//	PhotosTableViewController * dest = [segue destinationViewController];
    
}


@end
