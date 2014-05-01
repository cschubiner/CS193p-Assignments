//
//  GameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/21/14.

//

#import "CardView.h"
#import "GameViewController.h"

@interface GameViewController ()
@end

@implementation GameViewController

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self updateUI];
}

-(void)updateViewConstraints {
	[super updateViewConstraints];
	[self updateUI];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self updateUI];
}

-(void)updateUI {
	[self.grid setSize:self.cardBackgroundView.frame.size];
	[self.grid setMinimumNumberOfCells:self.numCards];
	int count = 0;
	for (int i = 0; i < self.grid.rowCount; i++) {
		for (int j = 0; j < self.grid.columnCount; j++) {
			if (count >= self.numCards)
				break;
            
			CardView* view = [self.cardViews objectAtIndex:count];
			[UIView animateWithDuration:.45
                                  delay:.002
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 view.frame = [self.grid frameOfCellAtRow:i inColumn:j];
                             }
                             completion:NULL];
			count++;
		}
	}
    
	if (self.dynamicDeck != nil) {
		self.dynamicDeck = nil;
	}
    
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (IBAction)getPinch:(UIPinchGestureRecognizer *)pinch
{
	CGPoint pinchPoint = [pinch locationInView:self.cardBackgroundView];
    
	if(!self.dynamicDeck) {
		if(pinch.state == UIGestureRecognizerStateBegan) {
			self.dynamicDeck = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardBackgroundView];
			UIDynamicItemBehavior * cardsBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.cardViews];
			[self.dynamicDeck addBehavior:cardsBehavior];
            
			for (int i = 0; i < [self.cardViews count]; i++) {
				UISnapBehavior * stickyBehavior = [[UISnapBehavior alloc] initWithItem:[self.cardViews objectAtIndex:i] snapToPoint:pinchPoint];
				[self.dynamicDeck addBehavior:stickyBehavior];
			}
		}
	}
}

- (IBAction)getPan:(UIPanGestureRecognizer *)pan
{
	CGPoint panPoint = [pan locationInView:self.cardBackgroundView];
	if (self.dynamicDeck) {
		if (pan.state == UIGestureRecognizerStateBegan) {
			for (UIDynamicBehavior* behavior in self.dynamicDeck.behaviors) {
				if ([behavior isKindOfClass:[UISnapBehavior class]]) {
					[self.dynamicDeck removeBehavior:behavior];
				}
			}
            
			for (int i = 0; i < [self.cardViews count]; i++) {
				UIAttachmentBehavior * attach = [[UIAttachmentBehavior alloc] initWithItem:[self.cardViews objectAtIndex:i] attachedToAnchor:panPoint];
				[self.dynamicDeck addBehavior:attach];
			}
		}
		else if (pan.state == UIGestureRecognizerStateChanged) {
			for (UIDynamicBehavior* behavior in self.dynamicDeck.behaviors) {
				if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
					UIAttachmentBehavior* attach = (UIAttachmentBehavior*)behavior;
					attach.anchorPoint = panPoint;
				}
			}
		}
		else if (pan.state == UIGestureRecognizerStateEnded) {
			for (UIDynamicBehavior* behavior in self.dynamicDeck.behaviors) {
				if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
					[self.dynamicDeck removeBehavior:behavior];
				}
			}
            
			for (int i = 0; i < [self.cardViews count]; i++) {
				UISnapBehavior * stickyBehavior = [[UISnapBehavior alloc] initWithItem:[self.cardViews objectAtIndex:i] snapToPoint:panPoint];
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
	[self.grid setCellAspectRatio:69.0 / 90.0];
	[self.grid setMinimumNumberOfCells:self.numCards];
	[self.grid setSize:self.cardBackgroundView.bounds.size];
	int count = 0;
	for (int i = 0; i < self.grid.rowCount; i++) {
		for (int j = 0; j < self.grid.columnCount; j++) {
			if (count >= self.numCards)
				break;
            
			id view = [[viewClass alloc]init];
			[view setFrame:CGRectMake(-100, -200, self.grid.cellSize.width, self.grid.cellSize.height)];
			[view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			[self.cardBackgroundView addSubview:view];
			[cards addObject:view];
			count++;
		}
	}
    
	self.cardViews = cards;
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


- (void)handleRedeal
{
	self.oldScore = 0;
	self.dynamicDeck = nil;
	[self.game resetGame];
	[self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
	[self.cardViews removeAllObjects];
	[self initializeCardViews:[self class]];
	self.game = [[CardMatchingGame alloc]initWithCardCount:CARDS_IN_DECK
                                                 usingDeck:[self createDeck]];
	[self updateUI];
}

- (IBAction)touchRedealButton:(id)sender
{
	int cardIndex = 0;
	bool setMode = self.game.isSetMode;
	for (UIView * card in self.cardViews) {
		[UIView animateWithDuration:.75
                              delay:.002
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             card.frame = CGRectMake(-100, -200, self.grid.cellSize.width, self.grid.cellSize.height);
                         }
                         completion:^(BOOL finished) {
                             if (cardIndex == self.cardViews.count - 1) {
                                 [self handleRedeal];
                                 [self.game setIsSetMode:setMode];
                                 return;
                             }
                         }
         ];
		cardIndex++;
	}
    
	if (self.cardViews.count == 0)
		[self handleRedeal];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded) {
		int chosenButtonIndex = [self.cardViews indexOfObject:sender.view];
		Card * card = (Card*)[self.game cardAtIndex:chosenButtonIndex];
        
		if (card.isMatched)
			return;
        
		[self.game chooseCardAtIndex:chosenButtonIndex];
		[self updateUI];
	}
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self updateUI];
}

@end
