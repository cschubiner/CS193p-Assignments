//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/14/14.

//

#import "Card.h"
#import "Deck.h"
#import <Foundation/Foundation.h>

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) Boolean isSetMode;
-(NSUInteger)cardCount;
- (void)resetGame;
- (void)removeCard:(Card *)card;

@end
