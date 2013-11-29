//
//  AddWordViewController.m
//  verbose
//
//  Created by Ben Redfield on 11/19/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import "AddWordViewController.h"
#import "AppDelegate.h"
#import "Word.h"
#import "NSString+heightWithFont.h"


@interface AddWordViewController ()

@property (strong, nonatomic) NSMutableArray *searchArray;

@end

@implementation AddWordViewController

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
    
    //Show keyboard
    [self.wordTextField becomeFirstResponder];

    //Fix ios7 trans-navbar layout
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //configure navbar
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(BRANDPRIMARY)];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                 [UIColor whiteColor]:NSForegroundColorAttributeName,
                                                 [UIFont fontWithName:@"Baskerville" size:15.0]:NSFontAttributeName
                                                 }];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    //Add cancel button
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    [self setTitle:@"Add Word"];
    
    self.searchArray = [[NSMutableArray alloc]init];
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

- (IBAction)searchWord:(id)sender {
    //Resign keyboard
    [self.view endEditing:YES];
    
    [self fetchSearchData:self.wordTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.wordTextField) {
        [self fetchSearchData: textField.text];
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)fetchSearchData:(NSString *)searchWord{
    //Pull search words from API
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* searchData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/words/search.json?word=%@", searchWord]]
                            ];

        NSArray* json = nil;
        if (searchData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:searchData
                    options:NSJSONReadingMutableContainers
                    error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //Rebuild searchArray for table from JSON data
            [self.searchArray removeAllObjects];
            [self.searchArray addObjectsFromArray:json];
            [self.searchTable reloadData];
        });
        
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = [[[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"text"] heightWithFontSize:13.0];
    return height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"searchCell";
    
    UITableViewCell *cell = [self.searchTable dequeueReusableCellWithIdentifier:@"searchCell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [cell.textLabel setText:[[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"text"]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:context];
    NSDictionary *searchWord = [self.searchArray objectAtIndex:indexPath.row];
    
    Word *word = [[Word alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    [word setName:[searchWord objectForKey:@"word"]];
    [word setDefinition:[searchWord objectForKey:@"text"]];
    [word setPartOfSpeech:[searchWord objectForKey:@"partOfSpeech"]];
    [word setDateAdded:[NSDate date]];
    [word setLearned:@NO];
    [context save:nil];
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelBtnPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
