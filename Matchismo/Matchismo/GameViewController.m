//
//  GameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/21/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameViewController.h"
#import "CardView.h"

@interface GameViewController ()
@end

@implementation GameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self touchRedealButton:nil];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (Deck *)deck
{
	if (!_deck) {
		_deck  = [self createDeck];
	}
    
	return _deck;
}

- (NSMutableArray *)chosenCards
{
	if (!_chosenCards) {
		_chosenCards = [[NSMutableArray alloc] init];
	}
    
	return _chosenCards;
}

- (CardMatchingGame *)game
{
	if (!_game) {
		_game = [[CardMatchingGame alloc]init];
	}
    
	return _game;
}


- (Deck *)createDeck
{
	return nil;
}

- (void)updateUI
{
	for (CardView *cardView in self.cardViews) {
		int cardButtonIndex = [self.cardViews indexOfObject:cardView];
		Card *card = (Card *)[self.game cardAtIndex:cardButtonIndex];
		cardView.enabled = !card.isMatched;
		self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	}
}


- (IBAction)touchCardButton:(UIButton *)sender
{
	int chosenButtonIndex = [self.cardViews indexOfObject:sender];
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


- (IBAction)touchRedealButton:(id)sender
{
	self.oldScore = 0;
	[self.chosenCards removeAllObjects];
    
	[self.game resetGame];
	self.game = [[CardMatchingGame alloc]initWithCardCount:[self.cardViews count] usingDeck:[self createDeck]];
	[self updateUI];
}

@end
