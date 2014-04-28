//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor on 4/17/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

// Built-in Gesture Handler
- (void)resizeFaceWithPinch:(UIPinchGestureRecognizer *)gesture;

@end
