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

-(void)initializeCardViews:(Class)viewClass {
	NSMutableArray* cards = [[NSMutableArray alloc]init];
	[self.grid setCellAspectRatio:63.0/90.0];
	[self.grid setMinimumNumberOfCells:[self initialNumberOfCards]];
	[self.grid setSize:self.cardBackgroundView.bounds.size];
	int count = 0;
	for (int i = 0; i < self.grid.rowCount; i++) {
		for (int j = 0; j < self.grid.columnCount; j++) {
			id v = [[viewClass alloc]init];
			[v setFrame:[self.grid frameOfCellAtRow:i inColumn:j]];
			[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			[self.cardBackgroundView addSubview:v];
			[cards addObject:v];
			count++;
		}
	}
    
	self.cardViews = cards;
}

-(void)handleTap:(UITapGestureRecognizer *)sender {
}

-(NSMutableArray *)cardViews {
	if (_cardViews) return _cardViews;
    
	_cardViews = [[NSMutableArray alloc]init];
	for (int i = 0; i < self.game.cardCount; i++)
		[_cardViews addObject:[self.game cardAtIndex:i]];
    
	return _cardViews;
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
		[cardView updateWithCard:card];
		cardView.enabled = !card.isMatched;
		[cardView setFaceUp:card.isChosen];
		self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	}
}

-(Grid *)grid {
	if (!_grid) _grid = [[Grid alloc]init];
	return _grid;
}

-(int)initialNumberOfCards {return 0;}

- (IBAction)touchRedealButton:(id)sender
{
	self.oldScore = 0;
	[self.chosenCards removeAllObjects];
	[self.game resetGame];
	[self initializeCardViews:[self class]];
	self.game = [[CardMatchingGame alloc]initWithCardCount:[self.cardViews count] usingDeck:[self createDeck]];
	[self updateUI];
}

@end
