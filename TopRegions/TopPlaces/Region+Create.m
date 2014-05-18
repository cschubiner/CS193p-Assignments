//
//  Region+Create.m
//  TopRegions
//
//  Created by Clay Schubiner on 5/17/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "FlickrFetcher.h"
#import "Region+Create.h"

@implementation Region (Create)

+(Region *)regionWithPlaceID:(NSString *)placeID andRegionInformation:(NSDictionary *)regionInfo inManagedObjectContext:(NSManagedObjectContext *)context {
	Region * region = nil;
    
	if ([placeID length]) {
		NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
		request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", placeID];
        
		NSError * error;
		NSArray * matches = [context executeFetchRequest:request error:&error];
        
		if (error || !matches || ([matches count] > 1)) {
			// handle error
		}
		else if (![matches count]) {
			region = [NSEntityDescription insertNewObjectForEntityForName:@"Region"
                                                   inManagedObjectContext:context];
			region.unique = placeID;
			region.name = [FlickrFetcher extractRegionNameFromPlaceInformation:regionInfo];
		}
		else {
			region = [matches lastObject];
		}
	}
    
	return region;
}
@end
