//
//  ImageViewController.h
//  Imaginarium
//
//  Created by CS193p Instructor on 4/29/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSURL * imageURL;
@property (nonatomic, strong) NSString * photoTitle;

@end
