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
#import <QuartzCore/QuartzCore.h>

@interface WordsViewController ()

//Private vars
@property (strong, nonatomic) NSArray *wordsArray;

@end

@implementation WordsViewController

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
    self.wordsArray = [[NSArray alloc] init];
    [self fetchWords];
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Word" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    self.wordsArray = [context executeFetchRequest:fetchRequest error:nil];
}

-(void)addWord{
    AddWordViewController *addWordViewController = [AddWordViewController new];
    [self.navigationController pushViewController:addWordViewController animated:YES];

}

-(NSArray*)filterLearnedWords{
    int learned = ([self.learnedControl selectedSegmentIndex]) == 0 ? 0 :1;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"learned == %@", [NSNumber numberWithBool:learned]];
    NSArray *filteredWords = [self.wordsArray filteredArrayUsingPredicate:predicate];

    return filteredWords;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self filterLearnedWords] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"wordCell";
    
    UITableViewCell *cell = [self.wordsTableView dequeueReusableCellWithIdentifier:@"wordCell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    Word *word = [[self filterLearnedWords] objectAtIndex:indexPath.row];
    [cell.textLabel setText:[word.name capitalizedString]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WordDetailViewController *wordDetailViewController = [WordDetailViewController new];
    wordDetailViewController.word = [[self filterLearnedWords] objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:wordDetailViewController animated:YES];
}

- (IBAction)addWordBtnPressed:(id)sender {
    AddWordViewController *addWordViewController = [AddWordViewController new];
//    [self.navigationController pushViewController:addWordViewController animated:YES];
    
    //Wrap viewcontroller in a navigation controller for easy ios7 navbar
    UINavigationController *navWrap = [[UINavigationController alloc] initWithRootViewController:addWordViewController];
    [self presentViewController:navWrap animated:YES completion:nil];
}

- (IBAction)learnedControlChanged:(id)sender {
    [self.wordsTableView reloadData];
}
@end
