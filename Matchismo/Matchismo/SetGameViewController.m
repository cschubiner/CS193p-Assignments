//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/3/14.

//

#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetCardView.h"
#import "SetDeck.h"
#import "SetGameViewController.h"

@interface SetGameViewController ()
@end

@implementation SetGameViewController

static const int CARDS_GOTTEN_WHEN_REQUESTING_MORE = 3;

- (void)resetSetGame {
	self.numCards = 12;
	self.totalCardsShown = self.numCards;
	[self.grid setMinimumNumberOfCells:self.numCards];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	[self touchRedealButton:nil];
	[self resetSetGame];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
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
	if (self.totalCardsShown + CARDS_GOTTEN_WHEN_REQUESTING_MORE > CARDS_IN_DECK) {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Out of cards!" message:@"Hit the \"deal\" button to start over!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
    
	self.numCards += CARDS_GOTTEN_WHEN_REQUESTING_MORE;
	self.totalCardsShown += CARDS_GOTTEN_WHEN_REQUESTING_MORE;
	[self.grid setMinimumNumberOfCells:self.numCards];
    
	for (int i = 0; i < CARDS_GOTTEN_WHEN_REQUESTING_MORE; i++) {
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
	for (CardView * cardView in self.cardViews) {
		int cardButtonIndex = [self.cardViews indexOfObject:cardView];
		Card * card = (Card*)[self.game cardAtIndex:cardButtonIndex];
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
    
	[super updateUI];
}

@end
