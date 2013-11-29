//
//  WordDetailViewController.m
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import "WordDetailViewController.h"
#import "NSString+heightWithFont.h"
#import "AppDelegate.h"

@interface WordDetailViewController ()

@end

@implementation WordDetailViewController

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
    
    //Word
    [self.wordLabel setText:[self.word.name capitalizedString]];
    
    //Definition
    [self.definitionLabel setText:self.word.definition];
    self.definitionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.definitionLabel.numberOfLines = 0;
    float definitionLabelHeight = [self.word.definition heightWithFontSize:14.0];
    [self.definitionLabel setFrame:CGRectMake(10,0,300,definitionLabelHeight)];
    
    //Learned control
    [self.learnedControl setSelectedSegmentIndex:[self.word.learned boolValue]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)learnedControlChanged:(id)sender {
    self.word.learned = [NSNumber numberWithBool:[self.learnedControl selectedSegmentIndex]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    [context save:nil];
}
@end
