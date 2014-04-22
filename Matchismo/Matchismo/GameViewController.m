//
//  GameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/21/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@end

@implementation GameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
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

- (NSMutableArray *)statusHistory
{
	if (!_statusHistory) {
		_statusHistory = [[NSMutableArray alloc]init];
	}
    
	return _statusHistory;
}

- (Deck *)createDeck
{
	return nil;
}

- (void)updateUI
{
	for (UIButton *cardButton in self.cardButtons) {
		cardButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
		cardButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
		int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
		Card *card = (Card *)[self.game cardAtIndex:cardButtonIndex];
		[cardButton setAttributedTitle:[self attributedTitleForCard:card] forState:UIControlStateNormal];
		[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
		cardButton.enabled = !card.isMatched;
		self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	}
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
	return nil;
}

- (NSMutableAttributedString * )attributedTitleForCard:(Card *)card
{
	return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
	int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
	Card *card = (Card *)[self.game cardAtIndex:chosenButtonIndex];
    
	if (card.isMatched) {
		return;
	}
    
	if (card.isChosen) {
		[self.chosenCards removeAllObjects];
		[self.statusLabel setText:@""];
	}
    
	[self.game chooseCardAtIndex:chosenButtonIndex];
	[self updateUI];
    
	NSMutableAttributedString *statusMessage = [self getStatusMessage:card];
	[self.statusLabel setAttributedText:statusMessage];
}

- (NSMutableAttributedString *)getStatusMessage:(Card *)card
{
	NSMutableAttributedString *status = [[NSMutableAttributedString alloc]init];
	int scoreChange = self.game.score - self.oldScore;
    
	self.oldScore = self.game.score;
	[self.chosenCards addObject:card];
    
	if (!card.isChosen && self.chosenCards.count < 2) {
		[self.chosenCards removeAllObjects];
		return status;
	}
    
	if (card.isMatched) {
		[status appendAttributedString:[[NSAttributedString alloc]initWithString:@"Matched "]];
	}
    
	for (Card *card in self.chosenCards) {
		[status appendAttributedString:[self attributedTitleForCard:card withBypass:true]];
		[status.mutableString appendString:@" "];
	}
    
	if (!card.isChosen && !card.isMatched) {
		[status appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"don't match! %d point penalty!", -scoreChange]]];
	}
    
    
	if (card.isMatched) {
		[status appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"for %d point%@!", scoreChange, scoreChange == 1 ? @"":@"s"]]];
	}
    
	if (!card.isChosen || card.isMatched) {
		[self.chosenCards removeAllObjects];
	}
    
	[self.statusHistory addObject:status];
	return status;
}

- (NSMutableAttributedString *)attributedTitleForCard:(Card *)card withBypass:(BOOL)bypassChosenCheck
{
	return nil;
}

@end
