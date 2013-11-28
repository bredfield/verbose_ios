//
//  Word.h
//  verbose
//
//  Created by Ben Redfield on 11/23/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * partOfSpeech;
@property (nonatomic, retain) NSNumber * learned;
@property (nonatomic, retain) NSNumber * wordID;
@property (nonatomic, retain) NSDate * dateLearned;
@property (nonatomic, retain) NSDate * dateAdded;

@end
