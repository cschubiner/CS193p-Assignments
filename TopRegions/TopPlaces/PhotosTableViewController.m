//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "PhotosTableViewController.h"
#import "RecentPhotosTableViewController.h"

@interface PhotosTableViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * spinner;
@property (strong, nonatomic) NSMutableArray * photos;

@end

@implementation PhotosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
	}
    
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSURL * url = [FlickrFetcher URLforPhotosInPlace:self.place[FLICKR_PLACE_ID] maxResults:50];
	[self.spinner startAnimating];
	[self.refreshControl beginRefreshing];
    
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
	NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request
                                                     completionHandler:^(NSURL * localfile, NSURLResponse * response, NSError * error) {
                                                         if (!error) {
                                                             if ([request.URL isEqual:url]) {
                                                                 NSDictionary * results = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:localfile] options:0 error:nil];
                                                                 self.photos = [[NSMutableArray alloc]initWithArray:[results valueForKeyPath:FLICKR_RESULTS_PHOTOS]];
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self.tableView reloadData];
                                                                     [self.spinner stopAnimating];
                                                                     [self.refreshControl endRefreshing];
                                                                     [self.navigationItem setTitle:self.place[FLICKR_PLACE_NAME]];
                                                                 });
                                                             }
                                                         }
                                                     }];
	[task resume];
    
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
    
	NSDictionary * photo;
	//display photos in reverse order if we're viewing recent photos
	if ([self isKindOfClass:[RecentPhotosTableViewController class]])
		photo = [self.photos objectAtIndex:self.photos.count - indexPath.row - 1];
	else
		photo = [self.photos objectAtIndex:indexPath.row];
    
	bool hasTitle = photo[FLICKR_PHOTO_TITLE] && ((NSString*)photo[FLICKR_PHOTO_TITLE]).length > 0;
	bool hasDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] && ((NSString*)[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]).length > 0;
	cell.detailTextLabel.text = @"";
	if (hasTitle) {
		cell.textLabel.text = photo[FLICKR_PHOTO_TITLE];
		cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
	}
	else if (hasDescription)
		cell.textLabel.text = photo[FLICKR_PHOTO_DESCRIPTION];
	else
		cell.textLabel.text = @"Unknown";
    
    
	return cell;
}

- (NSURL *)getPhotoURL:(NSDictionary *)photo {
	NSURL * url = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatOriginal];
	if (url == nil)
		url = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    
	return url;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary * photo;
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
		[detailController setImageURL:[self getPhotoURL:photo]];
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


- (NSString *)getPhotoTitle:(NSDictionary *)photo
{
	NSString * photoTitle = photo[FLICKR_PHOTO_TITLE];
	bool hasTitle = photo[FLICKR_PHOTO_TITLE] && ((NSString*)photo[FLICKR_PHOTO_TITLE]).length > 0;
	bool hasDescription = photo[FLICKR_PHOTO_DESCRIPTION] && ((NSString*)photo[FLICKR_PHOTO_DESCRIPTION]).length > 0;
	if (hasTitle == false) {
		if (hasDescription)
			photoTitle = photo[FLICKR_PHOTO_DESCRIPTION];
		else photoTitle = @"Unknown";
	}
    
	return photoTitle;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	ImageViewController * dest = [segue destinationViewController];
	NSDictionary * photo = sender;
	[dest setImageURL:[self getPhotoURL:photo]];
	[dest setPhotoTitle:[self getPhotoTitle:photo]];
}

@end
