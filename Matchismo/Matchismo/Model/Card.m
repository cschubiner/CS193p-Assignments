//
//  Card.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/4/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "Card.h"

@implementation Card
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

-(int)matchSingleCard:(Card *)otherCard {
    if ([otherCard.contents isEqualToString:self.contents])
        return 1;
    return 0;
}
@end
