//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/14/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *matchedCards;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 1;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray *)cards
{
	if (!_cards) {
		_cards = [[NSMutableArray alloc]init];
	}
    
	return _cards;
}

- (void)resetGame
{
	self.score = 0;
	[self.matchedCards removeAllObjects];
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
	self = [super init];
	if (self) {
		for (int i = 0; i < count; i++) {
			Card *card = [deck drawRandomCard];
			if (card) {
				[self.cards addObject:card];
			}
			else
			{
				self = nil;
				break;
			}
		}
	}
    
	return self;
}

-(NSMutableArray *)matchedCards {
	if (!_matchedCards) _matchedCards = [[NSMutableArray alloc]init];
    
	return _matchedCards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)removeCard:(Card *)card {
    [self.cards removeObject:card];
}

-(NSUInteger)cardCount {
	return self.cards.count;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
	Card *card = [self cardAtIndex:index];
	int maxMatchedCards = self.isSetMode ? 3 : 2;
    
	if (card.isMatched == false) {
		if (card.isChosen) {
			card.chosen = NO;
			for (Card *otherCard in self.matchedCards) {
				[otherCard setChosen:false];
			}
            
			[self.matchedCards removeAllObjects];
		}
		else
		{
			card.chosen = YES;
			self.score -= COST_TO_CHOOSE;
			if ([self.matchedCards count] != maxMatchedCards - 1) {
				[self.matchedCards addObject:card];
				return;
			}
            
			int scoreChange = MATCH_BONUS * [card match:self.matchedCards];
			if (maxMatchedCards == 3) {
				scoreChange *= maxMatchedCards;
			}
            
			if (scoreChange == 0) {
				scoreChange = -MISMATCH_PENALTY;
			}
            
			[self.matchedCards addObject:card];
			for (Card *otherCard in self.matchedCards) {
				if (scoreChange > 0) {
					[otherCard setMatched:true];
				}
				else
				{
					[otherCard setChosen:false];
					[otherCard setMatched:false];
				}
			}
            
			self.score += scoreChange;
			[self.matchedCards removeAllObjects];
		}
	}
    
	if (self.isSetMode == false && card.isMatched == false) {
		[card setChosen:true];
		[self.matchedCards addObject:card];
	}
}

@end
