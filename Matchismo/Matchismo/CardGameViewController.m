//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/3/14.

//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface CardGameViewController ()
@end

@implementation CardGameViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	self.numCards = 12;
	[self touchRedealButton:nil];
	[self updateUI];
	[self touchRedealButton:nil];
}

-(void)initializeCardViews:(Class)viewClass {
	[super initializeCardViews:[PlayingCardView class]];
}

- (Deck *)createDeck {
	return [[PlayingCardDeck alloc]init];
}

- (void)updateUI
{
	for (PlayingCardView * cardView in self.cardViews) {
		int cardButtonIndex = [self.cardViews indexOfObject:cardView];
		Card * card = [self.game cardAtIndex:cardButtonIndex];
		[cardView updateWithCard:card];
		cardView.enabled = !card.isMatched;
		[cardView setFaceUp:card.isChosen];
	}
    
	[super updateUI];
}

@end
