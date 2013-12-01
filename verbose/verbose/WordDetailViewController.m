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
#import <QuartzCore/QuartzCore.h>

@interface WordDetailViewController ()

@property(strong, nonatomic) NSDateFormatter *dateFormat;

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
    
    //Set up date to string
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateStyle:NSDateFormatterMediumStyle];
    
    //Details table
    [self.detailsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    //Learned control
    [self.learnedControl setSelectedSegmentIndex:[self.word.learned boolValue]];
    [self.learnedControl setTintColor:UIColorFromRGB(BRANDSECONDARY)];
    
    //Delete word
    [self.deleteWordBtn.layer setCornerRadius:self.deleteWordBtn.bounds.size.width / 2.0];
    [self.deleteWordBtn.layer setBorderColor:[UIColorFromRGB(BRANDSECONDARY)CGColor]];
    [self.deleteWordBtn.layer setBorderWidth:2.0];
    [self.deleteWordBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleteWordBtn setTitleColor:UIColorFromRGB(BRANDSECONDARY) forState:UIControlStateNormal];
    
}

-(void)setDateLearned{
    NSString *dateLearnedString = self.word.dateLearned?[self.dateFormat stringFromDate:self.word.dateLearned]:@"Not yet learned";
    [self.dateLearnedLabel setText:dateLearnedString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)learnedControlChanged:(id)sender {
//    self.word.learned = [NSNumber numberWithBool:[self.learnedControl selectedSegmentIndex]];
    [self.word toggleLearned:[self.learnedControl selectedSegmentIndex]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    [context save:nil];
    
    [self.detailsTable reloadData];
}

- (IBAction)deleteWordBtnPressed:(id)sender {
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Delete word" message:@"Are you sure you want to delete this word?" delegate:self cancelButtonTitle:@"Nevermind" otherButtonTitles: nil];
//    [message show];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Nevermind"
                                  destructiveButtonTitle:@"Delete"
                                  otherButtonTitles: nil];
    [actionSheet showFromRect:[(UIButton*)sender frame] inView:self.view animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSManagedObjectContext *context = self.word.managedObjectContext;
        [context deleteObject:self.word];
        [context save:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else return;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    float height = [[[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"text"] heightWithFontSize:13.0];
//    return height + 20;
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"detailCell";
    
    UITableViewCell *cell = [self.detailsTable dequeueReusableCellWithIdentifier:@"detailCell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(indexPath.row == 0){
        [cell.textLabel setText:[NSString stringWithFormat:@"Part of speech: %@",[self.word.partOfSpeech capitalizedString]]];
    }
    else if(indexPath.row == 1){
        [cell.textLabel setText:[NSString stringWithFormat:@"Synonyms: %@",self.word.synonyms]];
    }
    else if(indexPath.row == 2){
        [cell.textLabel setText:[NSString stringWithFormat:@"Date added: %@",[self.dateFormat stringFromDate:self.word.dateAdded]]];
    }
    else if(indexPath.row == 3){
        NSString *dateLearnedString = self.word.dateLearned?[self.dateFormat stringFromDate:self.word.dateLearned]:@"Not yet learned";
        [cell.textLabel setText:[NSString stringWithFormat:@"Date learned: %@",dateLearnedString]];
    }
    
    return cell;
}
@end
