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
    return @[@"red", @"green", @"purple"];
}

+(NSArray *)validNumbers {
    return @[@"one", @"two", @"three"];
}

+(NSArray *)validShapes {
    return @[@"diamond", @"squiggle", @"oval"];
}

+(NSArray *)validShading {
    return @[@"open", @"striped", @"solid"];
}
@end
