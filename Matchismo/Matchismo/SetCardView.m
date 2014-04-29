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

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define CORNER_LINE_SPACING_REDUCTION 0.25

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:CORNER_RADIUS];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if (self.enabled)
    {
        [[UIColor blackColor] setStroke];
    }
    else
    {
        [[UIColor whiteColor] setStroke];
    }
    [roundedRect stroke];
    
    [self drawTheShapes];
}

- (void)drawTheShapes
{
    CGFloat centerx = self.bounds.size.width / 2.0;
    CGFloat centery = self.bounds.size.height / 2.0;
    
    CGFloat firstThirdx = self.bounds.size.width / 3.0;
    CGFloat secondThirdx = firstThirdx * 2.0;
    
    CGFloat firstFourthx = self.bounds.size.width / 4.0;
    CGFloat thirdFourthx = firstFourthx * 3.0;
    
    if (self.number == 1)
    {
        [self drawShapeAt:CGPointMake(centerx, centery)];
        return;
    }
    if (self.number == 4)
    {
        [self drawShapeAt:CGPointMake(firstThirdx, centery)];
        [self drawShapeAt:CGPointMake(secondThirdx, centery)];
        return;
    }
    if (self.number == 16)
    {
        [self drawShapeAt:CGPointMake(firstFourthx, centery)];
        [self drawShapeAt:CGPointMake(centerx, centery)];
        [self drawShapeAt:CGPointMake(thirdFourthx, centery)];
        return;
    }
}

- (void)drawShapeAt:(CGPoint)point
{
    if(self.shape == 1) [self drawOvalAt:point];
    if(self.shape == 4) [self drawSquiggleAt:point];
    if(self.shape == 16) [self drawDiamondAt:point];
}

- (void)drawOvalAt:(CGPoint)point
{
    CGFloat width = self.bounds.size.width * .15;
    CGFloat height = self.bounds.size.height * .5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - (width / 2.0), point.y - (height / 2.0), width, height)
                                                    cornerRadius:(width / 2.0)];
    path.lineWidth = self.bounds.size.width * .05;
    [self giveCorrectFillTo:path];
    [path stroke];
}

- (void)drawSquiggleAt:(CGPoint)point
{
    CGFloat width = self.bounds.size.width * .15;
    CGFloat height = self.bounds.size.height * .5;

    CGFloat curvex = (width/2) * .5;
    CGFloat curvey = (height/2) * .6;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(point.x - (width/2.0), point.y - (height/2.0))];
    [path addQuadCurveToPoint:CGPointMake(point.x - (width/2.0), point.y - (height/2.0))
                 controlPoint:CGPointMake(point.x - curvex, point.y - curvey)];
    [path addCurveToPoint:CGPointMake(point.x + (width/2.0), point.y + (height/2.0))
            controlPoint1:CGPointMake(point.x + (width/2.0) + curvex, point.y - (height/2.0) + curvey)
            controlPoint2:CGPointMake(point.x + (width/2.0) - curvex, point.y + (height/2.0) - curvey)];
    [path addQuadCurveToPoint:CGPointMake(point.x - (width/2.0), point.y + (height/2.0))
                 controlPoint:CGPointMake(point.x + curvex, point.y + (height/2.0) + curvey)];
    [path addCurveToPoint:CGPointMake(point.x - (width/2.0), point.y - (height/2.0))
            controlPoint1:CGPointMake(point.x - (width/2.0) - curvex, point.y + (height/2.0) - curvey)
            controlPoint2:CGPointMake(point.x - (width/2.0) + curvex, point.y - (height/2.0) + curvey)];
    path.lineWidth = self.bounds.size.width * .05;
    [self giveCorrectFillTo:path];
    [path stroke];
}

- (void)drawDiamondAt:(CGPoint)point
{
    CGFloat width = self.bounds.size.width * .2;
    CGFloat height = self.bounds.size.height * .5;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - (height/2.0))];
    [path addLineToPoint:CGPointMake(point.x + (width/2.0), point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + (height/2.0))];
    [path addLineToPoint:CGPointMake(point.x - (width/2.0), point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * .05;
    [self giveCorrectFillTo:path];
    [path stroke];
}

- (void)giveCorrectFillTo:(UIBezierPath*)path
{
    UIColor *fillColor = [[UIColor alloc] init];
    if(self.color == 1) fillColor = [UIColor greenColor];
    if(self.color == 4) fillColor = [UIColor blueColor];
    if(self.color == 16) fillColor = [UIColor magentaColor];
    
    if(self.shading == 1) [self giveStripesTo:path withColor:fillColor];
    if(self.shading == 4) [self giveOutlineTo:path withColor:fillColor];
    if(self.shading == 16) [self giveSolidTo:path withColor:fillColor];
}

-(void)giveStripesTo:(UIBezierPath*)path withColor:(UIColor*)fillColor
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [path addClip];
    
    UIBezierPath *stripes = [[UIBezierPath alloc] init];
    
    CGPoint start = self.bounds.origin;
    CGPoint end = start;
    end.x += self.bounds.size.width;
    start.y += self.bounds.size.height * .05 * 4;
    for (int i = 0; i < 1 / .05; i++)
    {
        [stripes moveToPoint:start];
        [stripes addLineToPoint:end];
        start.y += self.bounds.size.height * .05;
        end.y += self.bounds.size.height * .05;
    }
    stripes.lineWidth = self.bounds.size.width / 2 * .05;
    [fillColor setStroke];
    [stripes stroke];
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

-(void)giveOutlineTo:(UIBezierPath*)path withColor:(UIColor*)fillColor
{
    [[UIColor clearColor] setFill];
    [fillColor setStroke];
}

-(void)giveSolidTo:(UIBezierPath*)path withColor:(UIColor*)fillColor
{
    [fillColor setFill];
    [fillColor setStroke];
    [path fill];
}

-(void)updateWithCard:(Card *)card {
	self.shape = ((SetCard*)card).shape;
	self.shading = ((SetCard*)card).shading;
	self.color = ((SetCard*)card).color;
	self.number = ((SetCard*)card).number;
	[self setNeedsDisplay];
}

- (void)setShape:(NSUInteger)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

@end
