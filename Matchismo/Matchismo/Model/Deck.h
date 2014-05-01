//
//  Deck.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/4/14.
//

#import "Card.h"
#import <Foundation/Foundation.h>

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
@end