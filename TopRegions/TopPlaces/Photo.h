//
//  Photo.h
//  TopRegions
//
//  Created by Clay Schubiner on 5/17/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSDate * dateAccessed;
@property (nonatomic, retain) Photographer *whoTook;

@end
