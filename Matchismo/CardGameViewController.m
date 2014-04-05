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

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *suitAndRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck * deck;
@property (strong, nonatomic) PlayingCard * card1;
@property (strong, nonatomic) PlayingCard * card2;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@end

@implementation CardGameViewController

-(Deck *) deck {
    if (!_deck) _deck  = [self createDeck];
    return _deck;
}

-(Deck *) createDeck {
    return [[PlayingCardDeck alloc]init];
}

/*
 * This method flips a card over. It will also increment the flipCount and check whether both of the cards in the interface are the same suit or rank.
 */
- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
        [self.suitAndRankLabel setText:@""];
        if ([sender isEqual:self.button1])
            self.card1 = nil;
        else
            self.card2 = nil;
    } else {
        Card * randomCard = [self.deck drawRandomCard];
        if (randomCard) {
            [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                              forState:UIControlStateNormal];
            [sender setTitle:randomCard.contents forState:UIControlStateNormal];
            
            if ([sender isEqual:self.button1])
                self.card1 = (PlayingCard*)randomCard;
            else
                self.card2 = (PlayingCard*)randomCard;
            self.flipCount++;
        }
        else
            [self.statusLabel setText:@"Out of cards!"];
        
        if ([self.card1 isSameRank:self.card2])
            [self.suitAndRankLabel setText:@"Ranks match!"];
        else if ([self.card1 isSameSuit:self.card2])
            [self.suitAndRankLabel setText:@"Suits match!"];
        else
            [self.suitAndRankLabel setText:@""];
    }
}

-(void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

@end
