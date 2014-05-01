//
//  GameViewController.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/21/14.

//
// This is an abstract class implemented by SetGameViewControler and CardGameViewController

#import "CardMatchingGame.h"
#import "Deck.h"
#import "Grid.h"
#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
@property (strong, nonatomic) Deck * deck;
@property (strong, nonatomic) CardMatchingGame * game;
@property (nonatomic) NSUInteger oldScore;
@property (strong, nonatomic) NSMutableArray * cardViews;
@property (weak, nonatomic) IBOutlet UILabel * scoreLabel;
@property (strong, nonatomic) Grid * grid;
@property (weak, nonatomic) IBOutlet UIView * cardBackgroundView;
@property (strong, nonatomic) UIDynamicAnimator * dynamicDeck;
@property (nonatomic) int numCards;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (Deck *)deck;
- (CardMatchingGame *)game;
- (Deck *)createDeck;
- (void)updateUI;
- (void)initializeCardViews:(Class)viewClass;
- (void)handleTap:(UITapGestureRecognizer *)sender;
- (IBAction)touchRedealButton:(id)sender;
@end

static const int CARDS_IN_DECK = 25;
