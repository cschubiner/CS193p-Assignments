//
//  RecentPlacesTableViewController.m
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "FlickrDatabase.h"
#import "RecentPhotosTableViewController.h"

@interface RecentPhotosTableViewController ()

@property (strong, nonatomic) NSMutableArray * photos;

@end

@implementation RecentPhotosTableViewController

static NSString * PHOTO_DEFAULT_KEY = @"photos";
const static int MAX_PHOTOS = 20;

- (void)setupFetchedResultsController
{
	if (self.managedObjectContext) {
		NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
		request.predicate = nil;
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateAccessed" ascending:NO],
		                            [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedStandardCompare:)],
		                            [NSSortDescriptor sortDescriptorWithKey:@"subtitle" ascending:YES selector:@selector(localizedStandardCompare:)]];
        
		[request setFetchLimit:MAX_PHOTOS];
        
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
	}
	else {
		self.fetchedResultsController = nil;
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.title = @"Recent Photos";
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

@end
