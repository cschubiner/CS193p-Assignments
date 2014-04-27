//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/3/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@end

@implementation CardGameViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
}


- (Deck *)createDeck
{
	return [[PlayingCardDeck alloc]init];
}


@end
