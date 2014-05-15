//
//  ImageViewController.m
//  Imaginarium
//
//  Created by CS193p Instructor on 4/29/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic) UIImage * image;
@property (weak, nonatomic) IBOutlet UIScrollView * scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * spinner;
@end

@implementation ImageViewController

#pragma mark Properties

- (UIImageView *)imageView
{
	if (!_imageView) _imageView = [[UIImageView alloc] init];
    
	return _imageView;
}

-(void)awakeFromNib {
    self.splitViewController.delegate = self;
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    
}

- (UIImage *)image
{
	return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
	[self.spinner stopAnimating];
	self.imageView.image = image;
	[self.imageView sizeToFit];
    
	self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    
	double widthZoom = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    
	double boundaryHeight = self.navigationController.navigationController.navigationBar.bounds.size.height + self.tabBarController.tabBar.bounds.size.height + UIApplication.sharedApplication.statusBarFrame.size.height;
	double heightZoom = (self.scrollView.bounds.size.height - boundaryHeight) / self.imageView.image.size.height;
    
	if(widthZoom > heightZoom)
		self.scrollView.zoomScale = widthZoom;
	else
		self.scrollView.zoomScale = heightZoom;
}

#pragma mark Public API

- (void)setImageURL:(NSURL *)imageURL
{
	_imageURL = imageURL;
	[self startDownloadingImage];
}

#pragma mark Multithreaded Image Downloading

- (void)startDownloadingImage
{
	self.image = nil;
	if (self.imageURL) {
		[self.spinner startAnimating];
		NSURLRequest * request = [NSURLRequest requestWithURL:self.imageURL];
		NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
		NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
		NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request
                                                         completionHandler:^(NSURL * localfile, NSURLResponse * response, NSError * error) {
                                                             if (!error) {
                                                                 if ([request.URL isEqual:self.imageURL]) {
                                                                     UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         self.image = image;
                                                                     });
                                                                 }
                                                             }
                                                         }];
		[task resume];
	}
}

#pragma mark Outlets

- (void)setScrollView:(UIScrollView *)scrollView
{
	_scrollView = scrollView;
	self.scrollView.delegate = self;
	self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	self.scrollView.minimumZoomScale = 0.05;
	self.scrollView.maximumZoomScale = 5.0;
	self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

#pragma mark View Controller Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.scrollView addSubview:self.imageView];
	[self.navigationItem setTitle:self.photoTitle];
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

@end
