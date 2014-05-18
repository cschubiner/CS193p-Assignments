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



- (void)viewDidLoad
{
	self.navigationItem.title = @"Recent Photos";
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
@end
