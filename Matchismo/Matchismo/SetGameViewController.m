//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/3/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "SetCardView.h"

@interface SetGameViewController ()
@end

@implementation SetGameViewController

- (void)viewDidAppear:(BOOL)animated
{
	[self.game setIsSetMode:YES];
}

- (Deck *)createDeck
{
	return [[SetDeck alloc]init];
}

-(void)initializeCardViews:(Class)viewClass {
    [super initializeCardViews:[SetCardView class]];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded) {
		int chosenButtonIndex = [self.cardViews indexOfObject:sender.view];
		Card *card = (Card *)[self.game cardAtIndex:chosenButtonIndex];
        
		if (card.isMatched) {
			return;
		}
        
		if (card.isChosen) {
			[self.chosenCards removeAllObjects];
		}
        
		[self.game chooseCardAtIndex:chosenButtonIndex];
		[self updateUI];
	}
}

@end
