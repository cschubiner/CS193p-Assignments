//
//  GameViewController.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/21/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//
// This is an abstract class implemented by SetGameViewControler and CardGameViewController

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Grid.h"
#import "CardMatchingGame.h"

@interface GameViewController : UIViewController
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger oldScore;
@property (strong, nonatomic) NSMutableArray * cardViews;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) Grid * grid;
@property (weak, nonatomic) IBOutlet UIView *cardBackgroundView;
@property (nonatomic) int numCards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (Deck *)deck;
- (CardMatchingGame *)game;
- (Deck *)createDeck;
- (void)updateUI;
-(void) initializeCardViews:(Class)viewClass;
- (void)handleTap:(UITapGestureRecognizer *)sender;
@end
