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

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)updateUI
{
	//no implementation. will be handled by subclasses
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self touchRedealButton:nil];
}

- (IBAction)getPinch:(UIPinchGestureRecognizer *)pinch
{
    CGPoint pinchPoint = [pinch locationInView:self.cardBackgroundView];
    
    if(!self.dynamicDeck)
    {
        if(pinch.state == UIGestureRecognizerStateBegan)
        {
            self.dynamicDeck = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardBackgroundView];
            UIDynamicItemBehavior *cardsBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.cardViews];
            [self.dynamicDeck addBehavior:cardsBehavior];
            
            for (int i = 0; i < [self.cardViews count]; i++)
            {
                UISnapBehavior *stickyBehavior = [[UISnapBehavior alloc] initWithItem:[self.cardViews objectAtIndex:i] snapToPoint:pinchPoint];
                [self.dynamicDeck addBehavior:stickyBehavior];
            }
        }
    }
}

- (IBAction)getPan:(UIPanGestureRecognizer *)pan
{
    CGPoint panPoint = [pan locationInView:self.cardBackgroundView];
    if (self.dynamicDeck)
    {
        if (pan.state == UIGestureRecognizerStateBegan)
        {
            for (UIDynamicBehavior* behavior in self.dynamicDeck.behaviors)
            {
                if ([behavior isKindOfClass:[UISnapBehavior class]])
                {
                    [self.dynamicDeck removeBehavior:behavior];
                }
            }
            for (int i = 0; i < [self.cardViews count]; i++)
            {
                UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:[self.cardViews objectAtIndex:i] attachedToAnchor:panPoint];
                [self.dynamicDeck addBehavior:attach];
            }
        }
        else if (pan.state == UIGestureRecognizerStateChanged)
        {
            for (UIDynamicBehavior* behavior in self.dynamicDeck.behaviors)
            {
                if ([behavior isKindOfClass:[UIAttachmentBehavior class]])
                {
                    UIAttachmentBehavior* attach = (UIAttachmentBehavior*)behavior;
                    attach.anchorPoint = panPoint;
                }
            }
        }
        else if (pan.state == UIGestureRecognizerStateEnded)
        {
            for (UIDynamicBehavior* behavior in self.dynamicDeck.behaviors)
            {
                if ([behavior isKindOfClass:[UIAttachmentBehavior class]])
                {
                    [self.dynamicDeck removeBehavior:behavior];
                }
            }
            for (int i = 0; i < [self.cardViews count]; i++)
            {
                UISnapBehavior *stickyBehavior = [[UISnapBehavior alloc] initWithItem:[self.cardViews objectAtIndex:i] snapToPoint:panPoint];
                [self.dynamicDeck addBehavior:stickyBehavior];
            }
        }
    }
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
	[self.grid setCellAspectRatio:69.0/90.0];
	[self.grid setMinimumNumberOfCells:self.numCards];
	[self.grid setSize:self.cardBackgroundView.bounds.size];
	int count = 0;
	for (int i = 0; i < self.grid.rowCount; i++) {
		for (int j = 0; j < self.grid.columnCount; j++) {
			if (count >= self.numCards)
				break;
            
			id view = [[viewClass alloc]init];
			[view setFrame:[self.grid frameOfCellAtRow:i inColumn:j]];
			[view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			[self.cardBackgroundView addSubview:view];
			[cards addObject:view];
			count++;
		}
	}
    
	self.cardViews = cards;
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

- (CardMatchingGame *)game
{
	if (!_game) {
		_game = [[CardMatchingGame alloc]init];
	}
    
	return _game;
}


- (Deck *)createDeck
{
	//no implementation. will be handled by subclasses
	return nil;
}

-(Grid *)grid {
	if (!_grid) _grid = [[Grid alloc]init];
    
	return _grid;
}


- (IBAction)touchRedealButton:(id)sender
{
	self.oldScore = 0;
    self.dynamicDeck = nil;
	[self.game resetGame];
    
	[self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
	[self initializeCardViews:[self class]];
	self.game = [[CardMatchingGame alloc]initWithCardCount:CARDS_IN_DECK
                                                 usingDeck:[self createDeck]];
	[self updateUI];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded) {
		int chosenButtonIndex = [self.cardViews indexOfObject:sender.view];
		Card *card = (Card *)[self.game cardAtIndex:chosenButtonIndex];
        
		if (card.isMatched)
			return;
        
		[self.game chooseCardAtIndex:chosenButtonIndex];
		[self updateUI];
	}
}

@end
