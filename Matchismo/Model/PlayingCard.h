//
//  PlayingCard.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/4/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

-(bool)isSameSuit:(PlayingCard*)otherCard;
-(bool)isSameRank:(PlayingCard*)otherCard;
@end
