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
@property (strong, nonatomic) NSMutableArray * chosenCards;
@property (nonatomic) NSUInteger oldScore;
@end

@implementation SetGameViewController

-(CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateUI];
    [self.game setEnableThreeMatchMode:YES];
}

-(Deck *) deck {
    if (!_deck) _deck  = [self createDeck];
    return _deck;
}

-(Deck *) createDeck {
    return [[SetDeck alloc]init];
}

-(NSMutableArray *)chosenCards {
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

-(NSMutableAttributedString*)getStatusMessage:(SetCard*)card {
    NSMutableAttributedString * status = [[NSMutableAttributedString alloc]init];
    int scoreChange = self.game.score - self.oldScore;
    self.oldScore = self.game.score;
    [self.chosenCards addObject:card];
    
    if (!card.isChosen && self.chosenCards.count < 3) {
        [self.chosenCards removeAllObjects];
        return status;
    }
        
    if (card.isMatched) {
        [status appendAttributedString:[[NSAttributedString alloc]initWithString:@"Matched "]];
    }
    
    for (SetCard * card in self.chosenCards) {
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
    
    return status;
}

/*
 * This method flips a card over. It will also increment the flipCount and check whether both of the cards in the interface are the same suit or rank.
 */
- (IBAction)touchCardButton:(UIButton *)sender {
    [self.game setEnableThreeMatchMode:YES];
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    SetCard *card = (SetCard*)[self.game cardAtIndex:chosenButtonIndex];
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

    [self.game resetGame];
    _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self updateUI];
}

-(NSMutableAttributedString* )attributedTitleForCard:(SetCard *)card {
    NSMutableAttributedString* symbolString = [[NSMutableAttributedString alloc]init];
    
    int numShapes = 1;
    if (card.number == 4) numShapes = 2;
    else if (card.number == 16) numShapes = 3;
    for (int i = 0; i < numShapes; i++) {
        [symbolString.mutableString appendString:[self shapeStringForCard:card]];
        [symbolString.mutableString appendString:@" "];
    }
    
    UIColor * symbolColor = [self colorForCard:card];
    UIColor * insideColor = symbolColor;
    NSNumber* strokeWidth = @5;
    if (card.shading == 16)
        strokeWidth = @-5;
    if (card.shading == 4) {
        strokeWidth = @-5;
        insideColor = [symbolColor colorWithAlphaComponent:.155];
    }
    if (card.shading == 1)
        insideColor = symbolColor;
    
    [symbolString addAttributes:@{
                                  NSForegroundColorAttributeName: insideColor,
                                  NSStrokeColorAttributeName: symbolColor,
                                  NSStrokeWidthAttributeName: strokeWidth,
                                  } range:NSMakeRange(0, symbolString.length)];
    
    return symbolString;
}

-(NSString*)shapeStringForCard:(SetCard*)card {
    if (card.shape == 1) return @"▲";
    if (card.shape == 4) return @"●";
    return @"■";
}

-(UIColor*)colorForCard:(SetCard*)card {
    if (card.color == 1) return [UIColor redColor];
    if (card.color == 4) return [UIColor purpleColor];
    return [UIColor greenColor];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        cardButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cardButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        SetCard *card = (SetCard*)[self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self attributedTitleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen? @"cardglowing" : @"cardfront"];
}

@end
