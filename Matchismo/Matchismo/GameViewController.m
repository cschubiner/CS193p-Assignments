//
//  GameViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/21/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation GameViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

-(Deck *) deck {
    if (!_deck) _deck  = [self createDeck];
    return _deck;
}

-(NSMutableArray *)chosenCards {
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

-(CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]init];
    return _game;
}

-(NSMutableArray *)statusHistory {
    if (!_statusHistory) _statusHistory = [[NSMutableArray alloc]init];
    return _statusHistory;
}

-(Deck *) createDeck {
    return [[Deck alloc]init];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        cardButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cardButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = (Card*)[self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self attributedTitleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return nil;
}

-(NSMutableAttributedString* )attributedTitleForCard:(Card *)card {
    return nil;
}



@end
