//
//  Region.h
//  TopRegions
//
//  Created by Clay Schubiner on 5/17/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class Photo, Photographer;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numPhotographers;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet * photographers;
@property (nonatomic, retain) NSSet * photos;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addPhotographersObject:(Photographer *)value;
- (void)removePhotographersObject:(Photographer *)value;
- (void)addPhotographers:(NSSet *)values;
- (void)removePhotographers:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
