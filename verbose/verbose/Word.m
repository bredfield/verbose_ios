//
//  Word.m
//  verbose
//
//  Created by Ben Redfield on 11/30/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import "Word.h"


@implementation Word

@dynamic dateAdded;
@dynamic dateLearned;
@dynamic definition;
@dynamic learned;
@dynamic name;
@dynamic partOfSpeech;
@dynamic wordID;
@dynamic synonyms;
@dynamic etymoloy;
@dynamic hyphenation;
@dynamic quizRight;
@dynamic quizWrong;

-(void) awakeFromInsert {
    [super awakeFromInsert];
    self.dateAdded = [NSDate date];
    self.learned = @NO;
}

-(void)toggleLearned:(BOOL)isLearned{
    if(isLearned){
        self.learned = @YES;
        self.dateLearned = [NSDate date];
    }
    else{
        self.learned = @NO;
        self.dateLearned = nil;
    }
}

-(void)pullSynonyms{
    //Pull search words from API
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@", [self name]);
        NSString *apiKey = @"c3b45323cb219cf66c5420b4aaa035b8bb6773d9ca99edf7f";
        NSString *searchString = [NSString stringWithFormat:@"http://api.wordnik.com/v4/word.json/%@/relatedWords?`caseSensitive=false&relationshipTypes=synonym&useCanonical=true&limitPerRelationshipType=4&api_key=%@", self.name, apiKey];
        NSURL *searchURL = [NSURL URLWithString:[searchString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        NSData* searchData = [NSData dataWithContentsOfURL:searchURL];
        
        NSArray* json = nil;
        if (searchData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:searchData
                    options:NSJSONReadingMutableContainers
                    error:nil];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *synonyms = [[json objectAtIndex:0] objectForKey:@"words"];
            [self setSynonyms:[synonyms componentsJoinedByString:@", "]];
            [self.managedObjectContext save:nil];
        });
        
    });
}

@end
