//
//  WordDetailViewController.h
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface WordDetailViewController : UIViewController
@property (strong, nonatomic) Word *word;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *learnedControl;
- (IBAction)learnedControlChanged:(id)sender;
@end
