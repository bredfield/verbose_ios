//
//  MainViewController.m
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        [self.navigationBar setBarTintColor:UIColorFromRGB(BRANDPRIMARY)];
        [self.navigationBar setTranslucent:NO];
        [self.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    [self.navigationBar setTitleTextAttributes:@{
                                                 [UIColor whiteColor]:NSForegroundColorAttributeName,
                                                 [UIFont fontWithName:@"Baskerville" size:15.0]:NSFontAttributeName
                                                 }];
    [self.navigationBar setBarStyle:UIBarStyleBlack];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
