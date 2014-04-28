//
//  CardView.h
//  Matchismo
//
//  Created by Clay Schubiner on 4/27/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL faceUp;

-(void)updateWithCard:(Card*)card;

@end
