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
@property (strong, nonatomic) NSMutableArray * chosenCards;
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

- (IBAction)historySlider:(UISlider *)sender {
    if (self.statusHistory.count == 0) return;
    int requestedIndex = ((int)sender.value/sender.maximumValue)*self.statusHistory.count;
    
    [self.statusLabel setTextColor:[UIColor grayColor]];
    if (requestedIndex >= self.statusHistory.count) {
        requestedIndex = self.statusHistory.count - 1;
        [self.statusLabel setTextColor:[UIColor blackColor]];
    }
    
    [self.statusLabel setText:[self.statusHistory objectAtIndex:requestedIndex]];
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
    return [[PlayingCardDeck alloc]init];
}

-(NSMutableAttributedString*)getStatusMessage:(PlayingCard*)card {
    NSMutableAttributedString * status = [[NSMutableAttributedString alloc]init];
    int scoreChange = self.game.score - self.oldScore;
    self.oldScore = self.game.score;
    [self.chosenCards addObject:card];
    
    if (card.isMatched) {
        [status.mutableString appendString:@"Matched "];
    }

    for (PlayingCard * card in self.chosenCards) {
        [status appendAttributedString:[self attributedTitleForCard:card]];
        [status.mutableString appendString:@" "];
    }
    
    if (!card.isChosen && !card.isMatched) {
        
        [status.mutableString appendString:[NSString stringWithFormat:@"don't match! %d point penalty!", -scoreChange]];
        [self.chosenCards removeAllObjects];
        return status;
    }
    
    if (card.isMatched) {
        [status.mutableString appendString:[NSString stringWithFormat:@"for %d point%@", scoreChange, scoreChange == 1 ? @"" : @"s"]];
        [self.chosenCards removeAllObjects];
        return status;
    }
    
    return status;
}

-(NSMutableAttributedString* )attributedTitleForCard:(PlayingCard *)card {
    NSMutableAttributedString* symbolString = [[NSMutableAttributedString alloc]init];
    if (symbolString.length > 0)
        [symbolString deleteCharactersInRange:NSMakeRange(0, symbolString.length)];
    
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
    
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
    NSMutableAttributedString * statusMessage = [self getStatusMessage:card];
    [self.statusLabel setAttributedText:statusMessage];
}

- (IBAction)touchRedealButton:(id)sender {
    self.oldScore = 0;
    self.statusLabel.text = @"";
    [self.game resetGame];
    _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self.statusHistory removeAllObjects];
    [self.statusLabel setTextColor:[UIColor blackColor]];
    [self setGameMode];
    [self.historySliderOutlet setValue:self.historySliderOutlet.maximumValue];
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
