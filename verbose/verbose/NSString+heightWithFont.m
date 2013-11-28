//
//  NSString+heightWithFont.m
//  verbose
//
//  Created by Ben Redfield on 11/28/13.
//  Copyright (c) 2013 Ben Redfield. All rights reserved.
//

#import "NSString+heightWithFont.h"

@implementation NSString (utility)

-(float)heightWithFontSize:(float)fontSize{
    //DYNAMIC CELL HEIGHT
    NSAttributedString *attributedText = [[NSAttributedString alloc]
                                          initWithString:self
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
                                          ];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){320, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return ceilf(rect.size.height);

}

@end
