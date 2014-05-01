//
//  CardView.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/27/14.

//

#import "Card.h"
#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) BOOL enabled;

-(void)updateWithCard:(Card*)card;

@end
