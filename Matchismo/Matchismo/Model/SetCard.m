//
//  SetCard.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/18/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+(NSArray *)validColors {
    return @[@1, @4, @16];
}

+(NSArray *)validNumbers {
    return @[@1, @4, @16];
}

+(NSArray *)validShapes {
    return @[@1, @4, @16];
}

+(NSArray *)validShading {
    return @[@1, @4, @16];
}

-(NSString*)shapeString {
    if (self.shape == 1) return @"▲";
    if (self.shape == 4) return @"●";
    return @"■";
}

-(UIColor*)colorUIColor {
    if (self.color == 1) return [UIColor redColor];
    if (self.color == 4) return [UIColor purpleColor];
    return [UIColor greenColor];
}

-(NSMutableAttributedString *)symbolString {
    if (!_symbolString) _symbolString = [[NSMutableAttributedString alloc]init];
    if (_symbolString.length > 0)
        [_symbolString deleteCharactersInRange:NSMakeRange(0, _symbolString.length)];
    [_symbolString.mutableString appendString:[self shapeString]];
    
    UIColor * symbolColor = [self colorUIColor];
    UIColor * insideColor = symbolColor;
    NSNumber* strokeWidth = @5;
    if (self.shading == 16)
        strokeWidth = @-5;
    if (self.shading == 4) {
        strokeWidth = @-5;
        insideColor = [symbolColor colorWithAlphaComponent:.115];
    }
    if (self.shading == 1)
        insideColor = symbolColor;
    [_symbolString addAttributes:@{
                                   NSForegroundColorAttributeName: insideColor,
                                   NSStrokeColorAttributeName: symbolColor,
                                   NSStrokeWidthAttributeName: strokeWidth,
                                   } range:NSMakeRange(0, _symbolString.length)];
    
    return _symbolString;
}


-(int)match:(NSArray *)otherCards {
    if (otherCards.count != 2) return false;
    bool validNum, validShading, validColor, validShape;
    
    int numSum = self.number, shadeSum = self.shading, colorSum = self.color, shapeSum = self.shape;
    for (SetCard* card in otherCards) {
        numSum += card.number;
        shadeSum += card.shading;
        shapeSum += card.shape;
        colorSum += card.color;
    }
    validNum = numSum == 3 || numSum == 12 || numSum == 48 || numSum == 21;
    validShading = shadeSum == 3 || shadeSum == 12 || shadeSum == 48 || shadeSum == 21;
    validColor = colorSum == 3 || colorSum == 12 || colorSum == 48 || colorSum == 21;
    validShape = shapeSum == 3 || shapeSum == 12 || shapeSum == 48 || shapeSum == 21;
    return validColor && validColor && validShape && validShading;
}

@end
