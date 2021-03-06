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

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	_managedObjectContext = managedObjectContext;
	[self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
	if (self.managedObjectContext) {
		NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
		request.predicate = [NSPredicate predicateWithFormat:@"region.name = %@", self.region.name];
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedStandardCompare:)],
		                            [NSSortDescriptor sortDescriptorWithKey:@"subtitle" ascending:YES selector:@selector(localizedStandardCompare:)]];
        
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
	}
	else {
		self.fetchedResultsController = nil;
	}
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
	Photo * photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
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
    
	cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
	dispatch_queue_t fetchQueue = dispatch_queue_create("FlickrDatabase thumbnail fetch", NULL);
	dispatch_async(fetchQueue, ^{
        if (!photo.thumbnail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            });
            NSData * thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURL]];
            [self.managedObjectContext performBlock:^{
                photo.thumbnail = thumbnailData;
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }
    });
    
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Photo * photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
	[self.managedObjectContext performBlock:^{
        photo.dateAccessed = [NSDate date];
        [self.managedObjectContext save:nil];
    }];
    
	ImageViewController * detailController = self.splitViewController.viewControllers[1];
	if ([detailController isKindOfClass:[UINavigationController class]]) {
		detailController = ((UINavigationController*)detailController).viewControllers[0];
	}
    
	if (detailController) {
		[detailController setTitle:[self getPhotoTitle:photo]];
		[detailController setImageURL:[NSURL URLWithString:photo.imageURL]];
	}
	else
		[self performSegueWithIdentifier:@"photosToImage" sender:photo];
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

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	static int contentChangeCount = 0;
	contentChangeCount++;
	if (contentChangeCount % 3 == 0) { //updates the coredatatable "occasionally"
		contentChangeCount = 0;
		[self performFetch];
	}
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
