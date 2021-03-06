//
//  PlayingCard.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/4/14.
//

#import "PlayingCard.h"

@implementation PlayingCard
- (int)match:(NSArray *)otherCards
{
	int score = 0;
    
	for (PlayingCard * otherCard in otherCards) {
		if (otherCard.rank == self.rank) {
			score += 2;
		}
		else if ([otherCard.suit isEqualToString:self.suit]) {
			score += 1;
		}
	}
    
	return score;
}

- (int)matchSingleCard:(Card *)otherCard
{
	PlayingCard * card = (PlayingCard*)otherCard;
	int score = 0;
    
	if (card.rank == self.rank) {
		score = 4;
	}
	else if ([card.suit isEqualToString:self.suit]) {
		score = 1;
	}
    
	return score;
}

- (NSString *)contents
{
	NSArray * rankStrings = [PlayingCard rankStrings];
    
	return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
	return @[@"♥", @"♦", @"♠", @"♣"];
}

- (void)setSuit:(NSString *)suit
{
	if ([[PlayingCard validSuits] containsObject:suit]) {
		_suit = suit;
	}
}

- (NSString *)suit
{
	return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
	return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
	return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
	if (rank <= [PlayingCard maxRank]) {
		_rank = rank;
	}
}

- (bool)isSameSuit:(PlayingCard *)otherCard
{
	return [self.suit isEqualToString:otherCard.suit];
}

- (bool)isSameRank:(PlayingCard *)otherCard
{
	return self.rank == otherCard.rank;
}

@end
