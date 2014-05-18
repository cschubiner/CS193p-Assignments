//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "Photo.h"
#import "PhotosTableViewController.h"
#import "RecentPhotosTableViewController.h"

@interface PhotosTableViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * spinner;

@end

@implementation PhotosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
	}
    
	return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
	Photo * photo;
	//display photos in reverse order if we're viewing recent photos
	if ([self isKindOfClass:[RecentPhotosTableViewController class]])
		photo = [self.photos objectAtIndex:self.photos.count - indexPath.row - 1];
	else
		photo = [self.photos objectAtIndex:indexPath.row];
    
	bool hasTitle = photo.title && photo.title.length > 0;
	bool hasDescription = photo.subtitle && photo.subtitle.length > 0;
	cell.detailTextLabel.text = @"";
	if (hasTitle) {
		cell.textLabel.text = photo.title;
		cell.detailTextLabel.text = photo.subtitle;
	}
	else if (hasDescription)
		cell.textLabel.text = photo.subtitle;
	else
		cell.textLabel.text = @"Unknown";
    
    
	return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Photo * photo;
	if ([self isKindOfClass:[RecentPhotosTableViewController class]])
		photo = [self.photos objectAtIndex:self.photos.count - indexPath.row - 1];
	else
		photo = [self.photos objectAtIndex:indexPath.row];
    
	[RecentPhotosTableViewController addRecentPhoto:photo];
    
	ImageViewController * detailController = self.splitViewController.viewControllers[1];
	if ([detailController isKindOfClass:[UINavigationController class]]) {
		detailController = ((UINavigationController*)detailController).viewControllers[0];
	}
    
	if (detailController) {
		[detailController setTitle:[self getPhotoTitle:photo]];
		[detailController setImageURL:[NSURL URLWithString:photo.imageURL]];
		if ([self isKindOfClass:[RecentPhotosTableViewController class]]) {
			[self.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
			[self.photos removeObject:photo];
			[self.photos addObject:photo];
		}
	}
	else
		[self performSegueWithIdentifier:@"photosToImage" sender:photo];
}


-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (NSString *)getPhotoTitle:(Photo *)photo
{
	NSString * photoTitle = photo.title;
	bool hasTitle = photo.title && photo.title.length > 0;
	if (hasTitle == false) {
		if (photo.subtitle && photo.subtitle.length > 0)
			photoTitle = photo.subtitle;
		else photoTitle = @"Unknown";
	}
    
	return photoTitle;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	ImageViewController * dest = [segue destinationViewController];
	Photo * photo = sender;
	[dest setImageURL:[NSURL URLWithString:photo.imageURL]];
	[dest setPhotoTitle:[self getPhotoTitle:photo]];
}

@end
