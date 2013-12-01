//
//  WordListCell.m
//  verbose
//
//  Created by Ben Redfield on 11/29/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import "WordListCell.h"

@implementation WordListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
