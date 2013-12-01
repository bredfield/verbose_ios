//
//  WordsViewController.m
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import "WordsViewController.h"
#import "AppDelegate.h"
#import "AddWordViewController.h"
#import "WordDetailViewController.h"
#import "Word.h"
#import "WordListCell.h"
#import <QuartzCore/QuartzCore.h>

@interface WordsViewController ()

//Private vars
@property (strong, nonatomic) NSArray *learnedArray, *notlearnedArray;

@end

@implementation WordsViewController
#define cellIdentifier @"WordListCellIdentifier"

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
    
    //Fix ios7 trans-navbar layout
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setTitle:@"Verbose"];
    
    [self.learnedControl setTintColor:UIColorFromRGB(BRANDPRIMARY)];
    
    [self.addWordBtn.layer setCornerRadius:self.addWordBtn.bounds.size.width / 2.0];
    [self.addWordBtn.layer setBorderColor:[UIColorFromRGB(BRANDSECONDARY)CGColor]];
    [self.addWordBtn.layer setBorderWidth:2.0];
    [self.addWordBtn setBackgroundColor:[UIColor whiteColor]];
    [self.addWordBtn setTitleColor:UIColorFromRGB(BRANDSECONDARY) forState:UIControlStateNormal];
    [self.addWordBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    self.learnedArray = [NSArray new];
    self.notlearnedArray = [NSArray new];
    [self fetchWords];
    
    [self.wordsTableView registerNib:[UINib nibWithNibName:@"WordListCell" bundle:nil]
                  forCellReuseIdentifier:cellIdentifier];
}

-(void)viewDidAppear:(BOOL)animated{
    [self fetchWords];
    [self.wordsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)fetchWords{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    //Set up core data fetch
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Word" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"dateAdded" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    //Filter not learned
    NSPredicate *notlearnedPredicate = [NSPredicate predicateWithFormat:@"learned == 0"];
    [fetchRequest setPredicate:notlearnedPredicate];
    
    self.notlearnedArray = [context executeFetchRequest:fetchRequest error:nil];
    
    //Filter learned
    NSPredicate *learnedPredicate = [NSPredicate predicateWithFormat:@"learned == 1"];
    [fetchRequest setPredicate:learnedPredicate];
    
    self.learnedArray = [context executeFetchRequest:fetchRequest error:nil];
    
}

-(void)addWord{
    AddWordViewController *addWordViewController = [AddWordViewController new]; 
    [self.navigationController pushViewController:addWordViewController animated:YES];

}

-(NSArray*)currentArray{
    return ([self.learnedControl selectedSegmentIndex]) == 0 ? self.notlearnedArray : self.learnedArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WordListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Word *word = [self.currentArray objectAtIndex:indexPath.row];
    [cell.nameLabel setText:[word.name capitalizedString]];
    
    NSString *pos = [NSString stringWithFormat:@"[%@]",[word.partOfSpeech capitalizedString]];
    [cell.posLabel setText:pos];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WordDetailViewController *wordDetailViewController = [WordDetailViewController new];
    wordDetailViewController.word = [self.currentArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:wordDetailViewController animated:YES];
}

- (IBAction)addWordBtnPressed:(id)sender {
    AddWordViewController *addWordViewController = [AddWordViewController new];
    
    //Wrap viewcontroller in a navigation controller for easy ios7 navbar
    UINavigationController *navWrap = [[UINavigationController alloc] initWithRootViewController:addWordViewController];
    [self presentViewController:navWrap animated:YES completion:nil];
}

- (IBAction)learnedControlChanged:(id)sender {
    [self.wordsTableView reloadData];
}
@end
