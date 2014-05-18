//
//  Photo+Flickr.m
//  Photomania
//
//  Created by CS193p Instructor on 5/13/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "Photographer+Create.h"
#import "Region+Create.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
                 andRegionInfo:(NSDictionary *)regionInfo
        inManagedObjectContext:(NSManagedObjectContext *)context
{
	Photo * photo = nil;
    
	NSString * unique = [photoDictionary valueForKeyPath:FLICKR_PHOTO_ID];
    
	NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
	request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
	NSError * error;
	NSArray * matches = [context executeFetchRequest:request error:&error];
    
	if (error || !matches || ([matches count] > 1)) {
		// handle error
        NSLog(@"Error: %@", error);
	}
	else if (![matches count]) {
		photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
		photo.unique = unique;
		photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
		photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
		photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary
                                              format:FlickrPhotoFormatLarge] absoluteString];
		photo.placeID = [photoDictionary valueForKeyPath:FLICKR_PLACE_ID];
        
		NSString * photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
		photo.whoTook = [Photographer photographerWithName:photographerName
                                    inManagedObjectContext:context];
		photo.region =  [Region regionWithPlaceID:photo.placeID andRegionInformation:regionInfo inManagedObjectContext:context];
        [photo.region addPhotographersObject:photo.whoTook];
        [photo.region setNumPhotographers:[NSNumber numberWithInteger:photo.region.photographers.count]];
	}
	else {
		photo = [matches firstObject];
	}
    
	return photo;
}

@end
