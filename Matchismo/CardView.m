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
