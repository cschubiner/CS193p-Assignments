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
	return self;
}

+(void)addRecentPhoto:(Photo *)photo {
    
}

- (void)viewDidLoad
{
	self.navigationItem.title = @"Recent Photos";
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.photos = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:PHOTO_DEFAULT_KEY]];
	[self.tableView reloadData];
}

@end
