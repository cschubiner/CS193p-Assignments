//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/14/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *matchedCards;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 1;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

-(void)resetGame {
    self.score = 0;
    [self.matchedCards removeAllObjects];
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card * card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
        [self setStatusMessage:@""];
        self.matchedCards = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count])? self.cards[index] : nil;
}


-(void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    int maxMatchedCards = self.enableThreeMatchMode ? 3 : 2;
    
    if (card.isMatched == false) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            [self.matchedCards addObject:card];
            card.chosen = YES;
            self.score-= COST_TO_CHOOSE;
            if ([self.matchedCards count] != maxMatchedCards) {
                return;
            }
            
            int scoreChange = 0;
            NSMutableString * status = [[NSMutableString alloc]init];
            int matchingCards = 0;
            for (int i = 0; i < self.matchedCards.count; i++) {
                for (int j = i; j < self.matchedCards.count; j++) {
                    if (i == j) continue;
                    Card * card1 = [self.matchedCards objectAtIndex:i];
                    Card * card2 = [self.matchedCards objectAtIndex:j];
                    
                    int matchValue = [card1 matchSingleCard:card2];
                    if (matchValue) {
                        matchingCards++;
                        scoreChange += matchValue * MATCH_BONUS;
                    } else {
                        scoreChange -= MISMATCH_PENALTY;
                    }
                }
            }
            if (matchingCards)
                [status appendString:@"Matched "];
            
            for (Card * otherCard in self.matchedCards) {
                [status appendString:otherCard.contents];
                [status appendString:@" "];
                if (matchingCards) 
                    [otherCard setMatched:true];
                else {
                    [otherCard setChosen:false];
                    [otherCard setMatched:false];
                }
            }
            
            self.score += scoreChange;
            if (matchingCards)
                [status appendString:[NSString stringWithFormat:@"for %d point%@", scoreChange, scoreChange == 1 ? @"" : @"s"]];
            else
                [status appendString:[NSString stringWithFormat:@"don't match! %d point penalty!", -scoreChange]];
            [self setStatusMessage:status];
            
            [self.matchedCards removeAllObjects];
        }
    }
}

@end
