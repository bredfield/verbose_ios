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
    
    //Fix ios7 trans-navbar layout
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.searchArray = [[NSMutableArray alloc]init];
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
    NSManagedObject *word = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Word"
                             inManagedObjectContext:context];
    NSDictionary *searchWord = [self.searchArray objectAtIndex:indexPath.row];
    
    [word setValue:[searchWord objectForKey:@"word"] forKey:@"name"];
    [word setValue:[searchWord objectForKey:@"text"] forKey:@"definition"];
    [word setValue:[searchWord objectForKey:@"partOfSpeech"] forKey:@"partOfSpeech"];
    [word setValue:[NSDate date] forKey:@"dateAdded"];
    
    [context save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
