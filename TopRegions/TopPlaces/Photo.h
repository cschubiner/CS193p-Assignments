//
//  Photo.h
//  TopRegions
//
//  Created by Clay Schubiner on 5/18/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer, Region;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * dateAccessed;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * placeID;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) Region *region;
@property (nonatomic, retain) Photographer *whoTook;

@end
