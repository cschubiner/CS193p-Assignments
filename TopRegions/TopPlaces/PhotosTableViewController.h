//
//  PhotosTableViewController.h
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Region.h"
#import <UIKit/UIKit.h>

@interface PhotosTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) Region * region;

@end
