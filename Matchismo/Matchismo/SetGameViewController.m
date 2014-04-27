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

@interface SetGameViewController ()
@end

@implementation SetGameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
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


- (IBAction)touchCardButton:(UIButton *)sender
{
	[self.game setEnableThreeMatchMode:YES];
	[super touchCardButton:sender];
}

@end
