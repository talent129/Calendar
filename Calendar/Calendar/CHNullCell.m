//
//  CHNullCell.m
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//  Copyright © 2023 CH. All rights reserved.
//

#import "CHNullCell.h"

@implementation CHNullCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
