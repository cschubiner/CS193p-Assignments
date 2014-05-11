//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "FlickrFetcher.h"
#import "TopPlacesTableViewController.h"

@interface TopPlacesTableViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * spinner;
@property (nonatomic, strong) NSArray * countryArray; //contains an array of countries (keys into placesDict)
@property (nonatomic, strong) NSDictionary * placesDict; //maps from key (country) to sorted array of places in the country
@end

@implementation TopPlacesTableViewController

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
	NSURL * url = [FlickrFetcher URLforTopPlaces];
	[self.spinner startAnimating];
    
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
	NSURLSessionDownloadTask * task = [session downloadTaskWithRequest:request
                                                     completionHandler:^(NSURL * localfile, NSURLResponse * response, NSError * error) {
                                                         if (!error) {
                                                             if ([request.URL isEqual:url]) {
                                                                 //                                                                 UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                 NSDictionary * results = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:localfile] options:0 error:nil];
                                                                 [self createPlacesDictionary:[results valueForKeyPath:FLICKR_RESULTS_PLACES]];
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self.tableView reloadData];
                                                                     [self.spinner stopAnimating];
                                                                 });
                                                             }
                                                         }
                                                     }];
	[task resume];
}

-(void)createPlacesDictionary:(NSArray*)places {
	NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
	for (NSDictionary * place in places) {
		NSArray * splitArr = [place[FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
		NSString * key = splitArr.lastObject;
		if (dict[key] == nil)
			dict[key] = [[NSMutableArray alloc]init];
        
		[dict[key] addObject:place];
	}
    
	NSMutableArray * arr = [[NSMutableArray alloc]init];
	for (NSString* key in dict)
		[arr addObject:key];
    
	self.countryArray = [arr sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@""
                                                                                         ascending:YES
                                                                                          selector:@selector(localizedStandardCompare:)]]];
	//sort the arrays in placesDict
	NSMutableDictionary * sortedDict = [[NSMutableDictionary alloc]init];
	for (NSString* key in dict) {
		sortedDict[key] = [dict[key] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"_content"
                                                                                                      ascending:YES
                                                                                                       selector:@selector(localizedStandardCompare:)]]];
	}
    self.placesDict = sortedDict;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.countryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ((NSArray*)self.placesDict[[self.countryArray objectAtIndex:section]]).count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.countryArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell" forIndexPath:indexPath];
    
	NSDictionary * place = [((NSArray*)self.placesDict[[self.countryArray objectAtIndex:indexPath.section]])objectAtIndex : indexPath.row];
	cell.textLabel.text = [place valueForKeyPath:FLICKR_PLACE_NAME];
//    cell.detailTextLabel.text = [pl]
    
	return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
}


@end
