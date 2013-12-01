//
//  WordDetailViewController.h
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface WordDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) Word *word;
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *learnedControl;
@property (strong, nonatomic) IBOutlet UILabel *dateAddedLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLearnedLabel;
@property (strong, nonatomic) IBOutlet UITableView *detailsTable;
@property (strong, nonatomic) IBOutlet UIButton *deleteWordBtn;
- (IBAction)learnedControlChanged:(id)sender;
- (IBAction)deleteWordBtnPressed:(id)sender;

@end
