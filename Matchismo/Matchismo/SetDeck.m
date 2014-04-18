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
        for (NSString *color in [SetCard validColors]) {
            for (NSString *shading in [SetCard validShading]) {
                for (NSString *number in [SetCard validNumbers]) {
                    for (NSString *shape in [SetCard validShapes]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.color = color;
                        card.shading = shading;
                        card.shape = shape;
                        card.number = number;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
