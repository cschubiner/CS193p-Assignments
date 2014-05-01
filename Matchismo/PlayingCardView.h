//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor on 4/17/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "CardView.h"
#import <UIKit/UIKit.h>

@interface PlayingCardView : CardView

@property (nonatomic, strong) NSString * suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL isMatched;

@end
