//
//  RecentPlacesTableViewController.m
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "RecentPlacesTableViewController.h"

@interface RecentPlacesTableViewController ()

@end

@implementation RecentPlacesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}
    
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier" #> forIndexPath:indexPath];
    
	// Configure the cell...
    
	return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
