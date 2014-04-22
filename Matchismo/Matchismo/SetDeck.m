//
//  SetDeck.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/18/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck


- (instancetype)init
{
	self = [super init];
	if (self) {
		for (NSNumber *color in [SetCard validColors]) {
			for (NSNumber *shading in [SetCard validShading]) {
				for (NSNumber *number in [SetCard validNumbers]) {
					for (NSNumber *shape in [SetCard validShapes]) {
						SetCard *card = [[SetCard alloc] init];
						card.color = color.integerValue;
						card.shading = shading.integerValue;
						card.shape = shape.integerValue;
						card.number = number.integerValue;
						[self addCard:card];
					}
				}
			}
		}
	}
    
	return self;
}

@end
