//
//  PlayingCard.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/4/14.
//

#import "Card.h"

@interface PlayingCard : Card
@property (strong, nonatomic) NSString * suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
+ (NSArray *)rankStrings;

- (bool)isSameSuit:(PlayingCard *)otherCard;
- (bool)isSameRank:(PlayingCard *)otherCard;
@end
