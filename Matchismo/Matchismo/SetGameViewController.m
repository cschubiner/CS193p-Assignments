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

- (void)resetSetGame {
	self.numCards = 12;
	self.totalCardsShown = self.numCards;
	[self.grid setMinimumNumberOfCells:self.numCards];
}

-(void)viewDidLoad {
	[self resetSetGame];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.game setIsSetMode:YES];
}

-(void)touchRedealButton:(id)sender {
	[self resetSetGame];
	[super touchRedealButton:sender];
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
    
	for (int i = 0; i < 3; i++) {
		SetCardView* view = [[SetCardView alloc]init];
		[view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
		[self.cardBackgroundView addSubview:view];
		[self.cardViews addObject:view];
	}
    
	[self updateUI];
}


- (void)updateUI
{
	NSMutableArray * viewsToRemove = [[NSMutableArray alloc]init];
	NSMutableArray * cardsToRemove = [[NSMutableArray alloc]init];
	for (CardView *cardView in self.cardViews) {
		int cardButtonIndex = [self.cardViews indexOfObject:cardView];
		Card *card = (Card *)[self.game cardAtIndex:cardButtonIndex];
		[cardView updateWithCard:card];
		if (card.isMatched) {
			[viewsToRemove addObject:cardView];
			[cardsToRemove addObject:card];
		}
        
	}
    
	for (Card * card in cardsToRemove) {
		[self.game removeCard:card];
	}
    
	for (CardView * cardView in viewsToRemove) {
		[cardView removeFromSuperview];
		[self.cardViews removeObject:cardView];
	}
    
	self.numCards -= viewsToRemove.count;
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
    
	[super updateUI];
}

@end
