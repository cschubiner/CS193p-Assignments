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
#import "HistoryViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck * deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame * game;
@property (strong, nonatomic) NSMutableArray * chosenCards;
@property (strong, nonatomic) NSMutableArray * statusHistory;
@property (nonatomic) NSUInteger oldScore;
@end

@implementation CardGameViewController

-(NSMutableArray *)chosenCards {
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

-(CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
}

-(NSMutableArray *)statusHistory {
    if (!_statusHistory) _statusHistory = [[NSMutableArray alloc]init];
    return _statusHistory;
}

-(void)viewDidLoad {
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"History"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(transitionToHistory)];
    self.navigationItem.rightBarButtonItem = btnSave;
}

-(void)transitionToHistory {
    [self performSegueWithIdentifier:@"2CardHistorySegue" sender:self];
}

-(Deck *) deck {
    if (!_deck) _deck  = [self createDeck];
    return _deck;
}

-(Deck *) createDeck {
    return [[PlayingCardDeck alloc]init];
}

-(NSMutableAttributedString*)getStatusMessage:(PlayingCard*)card {
    NSMutableAttributedString * status = [[NSMutableAttributedString alloc]init];
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
    
    for (PlayingCard * card in self.chosenCards) {
        [status appendAttributedString:[self attributedTitleForCard:card]];
        [status.mutableString appendString:@" "];
    }
    
    if (!card.isChosen && !card.isMatched) {
        [status appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"don't match! %d point penalty!", -scoreChange]]];
    }
    
    
    if (card.isMatched) {
        [status appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"for %d point%@!", scoreChange, scoreChange == 1 ? @"" : @"s"]]];
    }
    
    if (!card.isChosen || card.isMatched)
        [self.chosenCards removeAllObjects];
    
    [self.statusHistory addObject:status];
    return status;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HistoryViewController *hController = (HistoryViewController *)segue.destinationViewController;
    [hController setHistoryArray:self.statusHistory];
}

-(NSMutableAttributedString* )attributedTitleForCard:(PlayingCard *)card {
    NSMutableAttributedString* symbolString = [[NSMutableAttributedString alloc]init];
    [symbolString.mutableString appendString:card.contents];
    return symbolString;
}

/*
 * This method flips a card over. It will also increment the flipCount and check whether both of the cards in the interface are the same suit or rank.
 */
- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    PlayingCard *card = (PlayingCard*)[self.game cardAtIndex:chosenButtonIndex];
    if (card.isMatched) return;
    if (card.isChosen) {
        [self.chosenCards removeAllObjects];
        [self.statusLabel setText:@""];
    }
    
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
    NSMutableAttributedString * statusMessage = [self getStatusMessage:card];
    [self.statusLabel setAttributedText:statusMessage];
}

- (IBAction)touchRedealButton:(id)sender {
    self.oldScore = 0;
    [self.statusLabel setText:@""];
    [self.chosenCards removeAllObjects];
    [self.statusHistory removeAllObjects];
    [self.game resetGame];
    _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
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
    return card.isChosen? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen? @"cardfront" : @"cardback"];
}

@end
