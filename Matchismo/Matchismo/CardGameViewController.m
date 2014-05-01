//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/3/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController ()
@end

@implementation CardGameViewController

-(void)viewDidLoad {
	self.numCards = 12;
}

-(void)initializeCardViews:(Class)viewClass {
	[super initializeCardViews:[PlayingCardView class]];
}

- (Deck *)createDeck {
	return [[PlayingCardDeck alloc]init];
}

- (void)updateUI
{
	for (PlayingCardView *cardView in self.cardViews) {
		int cardButtonIndex = [self.cardViews indexOfObject:cardView];
		Card *card = (Card *)[self.game cardAtIndex:cardButtonIndex];
		[cardView updateWithCard:card];
		cardView.enabled = !card.isMatched;
		[(PlayingCardView*)cardView setFaceUp : card.isChosen];
	}
    
	if (self.dynamicDeck != nil) {
		self.dynamicDeck = nil;
	}
    
	[super updateUI];
}

@end
