//
//  Region+Create.h
//  TopRegions
//
//  Created by Clay Schubiner on 5/17/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Region.h"

@interface Region (Create)

+ (Region *)regionWithPlaceID:(NSString *)placeID
         andRegionInformation:(NSDictionary *)regionInfo
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
