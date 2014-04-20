//
//  SetCard.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/18/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

+(NSArray*)validShapes;
+(NSArray*)validColors;
+(NSArray*)validNumbers;
+(NSArray*)validShading;

@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;

@end
