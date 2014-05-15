//
//  RecentPlacesTableViewController.m
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "RecentPhotosTableViewController.h"

@interface RecentPhotosTableViewController ()

@property (strong, nonatomic) NSMutableArray * photos;

@end

@implementation RecentPhotosTableViewController

static NSString * PHOTO_DEFAULT_KEY = @"photos";
const static int MAX_PHOTOS = 20;

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}
    
	return self;
}

+(void)addRecentPhoto:(NSDictionary *)photo {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray * photos = [defaults objectForKey:PHOTO_DEFAULT_KEY];
    photos = [[NSMutableArray alloc]initWithArray:photos];
	[photos removeObject:photo];
	[photos addObject:photo];
    if (photos.count > MAX_PHOTOS)
        [photos removeObjectAtIndex:0];
	[defaults setObject:photos forKey:PHOTO_DEFAULT_KEY];
    [defaults synchronize];
}

- (void)viewDidLoad
{
	self.navigationItem.title = @"Recent Photos";
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * photos =[[NSMutableArray alloc]init];
	self.photos = [defaults objectForKey:PHOTO_DEFAULT_KEY];
    for (NSDictionary * photo in self.photos.reverseObjectEnumerator) {
        [photos addObject:photo];
    }
    self.photos = photos;
    [self.tableView reloadData];
}

@end
