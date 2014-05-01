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

-(void)viewDidLoad {
	self.numCards = 12;
	self.totalCardsShown = self.numCards;
}

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

- (IBAction)pressedGetMoreCards:(id)sender {
	if (self.totalCardsShown + 3 > CARDS_IN_DECK) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Out of cards" message: @"Sorry, you're out of cards." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
    
	self.numCards += 3;
	self.totalCardsShown += 3;
	[self.grid setMinimumNumberOfCells:self.numCards];
    
	int count = 0;
	for (int i = 0; i < self.grid.rowCount; i++) {
		for (int j = 0; j < self.grid.columnCount; j++) {
			if (count >= self.numCards)
				break;
            
			SetCardView* view;
			if (count >= self.numCards - 3) {
				view = [[SetCardView alloc]init];
				[view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
				[self.cardBackgroundView addSubview:view];
				[self.cardViews addObject:view];
			}
			else
				view = [self.cardViews objectAtIndex:count];
            
			[view setFrame:[self.grid frameOfCellAtRow:i inColumn:j]];
			count++;
		}
	}
    
	[self updateUI];
}


- (void)updateUI
{
	NSMutableArray * cardsToRemove = [[NSMutableArray alloc]init];
	for (CardView *cardView in self.cardViews) {
		int cardButtonIndex = [self.cardViews indexOfObject:cardView];
		Card *card = (Card *)[self.game cardAtIndex:cardButtonIndex];
		[cardView updateWithCard:card];
		if (card.isMatched) {
			[cardsToRemove addObject:cardView];
		}
        
		self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	}
    
	for (CardView * cardView in cardsToRemove) {
		[cardView removeFromSuperview];
		[self.cardViews removeObject:cardView];
	}
    
	self.numCards -= cardsToRemove.count;
	[self.grid setMinimumNumberOfCells:self.numCards];
    
	int count = 0;
	for (int i = 0; i < self.grid.rowCount; i++) {
		for (int j = 0; j < self.grid.columnCount; j++) {
			if (count >= self.numCards)
				break;
            
			SetCardView* view = [self.cardViews objectAtIndex:count];
			[view setFrame:[self.grid frameOfCellAtRow:i inColumn:j]];
			count++;
		}
	}
    if(self.dynamicDeck != nil)
    {
        self.dynamicDeck = nil;
    }
}

@end
