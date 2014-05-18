//
//  TopPlacesTableViewController.h
//  TopPlaces
//
//  Created by Clay Schubiner on 5/10/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>

@interface TopRegionsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;

@end
