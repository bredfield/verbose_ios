//
//  Word.h
//  verbose
//
//  Created by Ben Redfield on 11/30/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSDate * dateLearned;
@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSNumber * learned;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * partOfSpeech;
@property (nonatomic, retain) NSNumber * wordID;
@property (nonatomic, retain) NSString * synonyms;
@property (nonatomic, retain) NSString * etymoloy;
@property (nonatomic, retain) NSString * hyphenation;
@property (nonatomic, retain) NSNumber * quizRight;
@property (nonatomic, retain) NSNumber * quizWrong;
-(void)toggleLearned:(BOOL)isLearned;
-(void)pullSynonyms;
@end
