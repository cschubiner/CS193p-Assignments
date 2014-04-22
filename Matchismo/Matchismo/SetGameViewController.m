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
#import "HistoryViewController.h"

@interface SetGameViewController ()
@end

@implementation SetGameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	UIBarButtonItem *historyButton = [[UIBarButtonItem alloc]
	                                  initWithTitle:@"History"
	                                  style:UIBarButtonItemStyleBordered
	                                  target:self
	                                  action:@selector(transitionToHistory)];
	self.navigationItem.rightBarButtonItem = historyButton;
	[self touchRedealButton:nil];
}

- (void)transitionToHistory
{
	[self performSegueWithIdentifier:@"setHistorySegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	HistoryViewController *hController = (HistoryViewController *)segue.destinationViewController;
	[hController setHistoryArray:self.statusHistory];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self updateUI];
	[self.game setEnableThreeMatchMode:YES];
}

- (Deck *)createDeck
{
	return [[SetDeck alloc]init];
}

- (IBAction)touchRedealButton:(id)sender
{
	self.oldScore = 0;
	[self.statusLabel setText:@""];
	[self.chosenCards removeAllObjects];
	[self.statusHistory removeAllObjects];
    
	[self.game resetGame];
	self.game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
	[self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
	[self.game setEnableThreeMatchMode:YES];
	[super touchCardButton:sender];
}

- (NSMutableAttributedString * )attributedTitleForCard:(SetCard *)card withBypass:(BOOL)bypassChosenCheck
{
	NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc]init];
	int numShapes = 1;
    
	if (card.number == 4) {
		numShapes = 2;
	}
	else if (card.number == 16) {
		numShapes = 3;
	}
    
	for (int i = 0; i < numShapes; i++) {
		[symbolString.mutableString appendString:[self shapeStringForCard:card]];
		[symbolString.mutableString appendString:@" "];
	}
    
	UIColor *symbolColor = [self colorForCard:card];
	UIColor *insideColor = symbolColor;
	NSNumber *strokeWidth = @5;
	if (card.shading == 16) {
		strokeWidth = @ - 5;
	}
    
	if (card.shading == 4) {
		strokeWidth = @ - 5;
		insideColor = [symbolColor colorWithAlphaComponent:.155];
	}
    
	if (card.shading == 1) {
		insideColor = symbolColor;
	}
    
	[symbolString addAttributes:@{
                                  NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                                  NSForegroundColorAttributeName: insideColor,
                                  NSStrokeColorAttributeName: symbolColor,
                                  NSStrokeWidthAttributeName: strokeWidth,
                                  }
                          range:NSMakeRange(0, symbolString.length)];
    
	return symbolString;
}

- (NSMutableAttributedString * )attributedTitleForCard:(SetCard *)card
{
	return [self attributedTitleForCard:card withBypass:true];
}

- (NSString *)shapeStringForCard:(SetCard *)card
{
	if (card.shape == 1) {
		return @"▲";
	}
    
	if (card.shape == 4) {
		return @"●";
	}
    
	return @"■";
}

- (UIColor *)colorForCard:(SetCard *)card
{
	if (card.color == 1) {
		return [UIColor redColor];
	}
    
	if (card.color == 4) {
		return [UIColor purpleColor];
	}
    
	return [UIColor greenColor];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
	return [UIImage imageNamed:card.isChosen ? @"cardglowing":@"cardfront"];
}

@end
