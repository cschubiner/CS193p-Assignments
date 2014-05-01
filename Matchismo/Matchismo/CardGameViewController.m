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
	self.numCards = 9;
}

-(void)initializeCardViews:(Class)viewClass {
	[super initializeCardViews:[PlayingCardView class]];
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded) {
		int chosenButtonIndex = [self.cardViews indexOfObject:sender.view];
		Card *card = (Card *)[self.game cardAtIndex:chosenButtonIndex];
        
		if (card.isMatched)
			return;
        
		[self.game chooseCardAtIndex:chosenButtonIndex];
		[self updateUI];
	}
}


- (Deck *)createDeck {
	return [[PlayingCardDeck alloc]init];
}

@end
