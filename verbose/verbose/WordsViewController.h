//
//  WordsViewController.h
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *learnedControl;
@property (strong, nonatomic) IBOutlet UITableView *wordsTableView;
@property (strong, nonatomic) IBOutlet UIButton *addWordBtn;

- (IBAction)addWordBtnPressed:(id)sender;

@end
