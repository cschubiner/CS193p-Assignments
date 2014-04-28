//
//  SetCardView.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/27/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"
@interface SetCardView ()

@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@end

@implementation SetCardView


- (void)drawRect:(CGRect)rect
{
	// Drawing code
}

-(void)updateWithCard:(Card *)card {
	self.shape = ((SetCard*)card).shape;
	self.shading = ((SetCard*)card).shading;
	self.color = ((SetCard*)card).color;
	self.number = ((SetCard*)card).number;
	[self setNeedsDisplay];
}

@end
