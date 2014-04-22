//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Clay Schubiner on 4/20/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
    
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSMutableAttributedString *fullStr = [[NSMutableAttributedString alloc]init];
    
	for (NSAttributedString *str in self.historyArray) {
		[fullStr appendAttributedString:str];
		[fullStr.mutableString appendString:@"\n"];
	}
    
	[self.textView setAttributedText:fullStr];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
