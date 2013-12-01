//
//  AddWordViewController.h
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextField *wordTextField;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *searchTable;
@property (strong, nonatomic) IBOutlet UIButton *clipBtn;
- (IBAction)searchWord:(id)sender;
- (IBAction)clipBtnPressed:(id)sender;

@end
