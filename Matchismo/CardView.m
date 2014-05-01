//
//  CardView.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/27/14.

//

#import "CardView.h"

@implementation CardView

-(void)updateWithCard:(Card *)card {
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


#pragma mark Initialization

- (void)setup
{
	self.backgroundColor = nil;
	self.opaque = NO;
	self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
	[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
    
	return self;
}
@end
