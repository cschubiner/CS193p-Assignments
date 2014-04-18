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
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck * deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame * game;
@property (weak, nonatomic) IBOutlet UISlider *historySliderOutlet;
@property (strong, nonatomic) NSMutableArray * statusHistory;
@end

@implementation SetGameViewController

-(CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
}


-(void)setGameMode {
    if ([self.gameModeSegmentedControl selectedSegmentIndex] == 0) {
        //user selected 2 card game
        [self.game setEnableThreeMatchMode:NO];
    }
    else {
        //user selected 3 card game
        [self.game setEnableThreeMatchMode:YES];
        
    }
}

- (IBAction)gameModeSegmentedControlValueChanged:(id)sender {
    [self setGameMode];
}

-(NSMutableArray *)statusHistory {
    if (!_statusHistory) _statusHistory = [[NSMutableArray alloc]init];
    return _statusHistory;
}

-(Deck *) deck {
    if (!_deck) _deck  = [self createDeck];
    return _deck;
}

-(Deck *) createDeck {
    return [[SetDeck alloc]init];
}

/*
 * This method flips a card over. It will also increment the flipCount and check whether both of the cards in the interface are the same suit or rank.
 */
- (IBAction)touchCardButton:(UIButton *)sender {
    [self.gameModeSegmentedControl setEnabled:FALSE];
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self.statusLabel setText:self.game.statusMessage];
    [self.statusHistory addObject:[self.game.statusMessage copy]];
    [self.statusLabel setTextColor:[UIColor blackColor]];
    [self updateUI];
}

- (IBAction)touchRedealButton:(id)sender {
    self.statusLabel.text = @"";
    [self.game resetGame];
    _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self.gameModeSegmentedControl setEnabled:TRUE];
    [self.statusHistory removeAllObjects];
    [self.statusLabel setTextColor:[UIColor blackColor]];
    [self setGameMode];
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return ((SetCard*)card).symbolString;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:@"cardfront"];
//    return [UIImage imageNamed:card.isChosen? @"cardfront" : @"cardback"];
}

@end
