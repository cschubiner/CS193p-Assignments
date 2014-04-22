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
@end

@implementation CardGameViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *historyButton = [[UIBarButtonItem alloc]
                                initWithTitle:@"History"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(transitionToHistory)];
    self.navigationItem.rightBarButtonItem = historyButton;
    [self touchRedealButton:nil];
}

-(void)transitionToHistory {
    [self performSegueWithIdentifier:@"2CardHistorySegue" sender:self];
}

-(NSMutableAttributedString* )attributedTitleForCard:(PlayingCard *)card withBypass:(BOOL)bypassChosenCheck{
    NSMutableAttributedString* symbolString = [[NSMutableAttributedString alloc]init];
    if (card.isChosen == false && bypassChosenCheck == false)
        return symbolString;
    UIColor * color = [UIColor blackColor];
    if ([card.suit isEqualToString:[NSString stringWithUTF8String:"︎♥"]]||[card.suit isEqualToString:[NSString stringWithUTF8String:"︎♦"]]) {
        color = [UIColor redColor];
    }
    
    [symbolString.mutableString appendString:[NSString stringWithFormat:@"%d",card.rank]];
    [symbolString addAttributes:@{
                                  NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  } range:NSMakeRange(0, 1)];
    
    [symbolString.mutableString appendString:card.suit];
    [symbolString addAttributes:@{
                                  NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                                  NSForegroundColorAttributeName: color,
                                  } range:NSMakeRange(1, 1)];
    
    return symbolString;
}

-(NSMutableAttributedString* )attributedTitleForCard:(PlayingCard *)card {
    return [self attributedTitleForCard:card withBypass:false];
}

-(Deck *) createDeck {
    return [[PlayingCardDeck alloc]init];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HistoryViewController *hController = (HistoryViewController *)segue.destinationViewController;
    [hController setHistoryArray:self.statusHistory];
}

- (IBAction)touchRedealButton:(id)sender {
    self.oldScore = 0;
    [self.statusLabel setText:@""];
    [self.chosenCards removeAllObjects];
    [self.statusHistory removeAllObjects];
    [self.game resetGame];
    self.game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [self updateUI];
}


- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen? @"cardfront" : @"cardback"];
}

@end
