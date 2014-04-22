//
//  GameViewController.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/21/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//
//This is an abstract class implemented by SetGameViewControler and CardGameViewController

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface GameViewController : UIViewController
@property (strong, nonatomic) Deck * deck;
@property (strong, nonatomic) CardMatchingGame * game;
@property (strong, nonatomic) NSMutableArray * chosenCards;
@property (strong, nonatomic) NSMutableArray * statusHistory;
@property (nonatomic) NSUInteger oldScore;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
-(Deck *) deck ;
-(NSMutableArray *)chosenCards ;
-(CardMatchingGame *)game ;
-(NSMutableArray *)statusHistory ;
-(Deck *) createDeck ;
- (void)updateUI ;
-(NSMutableAttributedString*)getStatusMessage:(Card*)card;
-(NSMutableAttributedString* )attributedTitleForCard:(Card *)card withBypass:(BOOL)bypassChosenCheck;
-(NSMutableAttributedString* )attributedTitleForCard:(Card *)card;
- (IBAction)touchCardButton:(UIButton *)sender;
@end
