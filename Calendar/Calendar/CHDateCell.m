//
//  CHDateCell.m
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//  Copyright © 2023 CH. All rights reserved.
//

#import "CHDateCell.h"
#import <Masonry/Masonry.h>

@implementation CHDateCell

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 4;
    }
    return _bgView;
}

- (UILabel *)dayL {
    if (!_dayL) {
        _dayL = [UILabel new];
        _dayL.textColor = [UIColor grayColor];
        _dayL.font = [UIFont systemFontOfSize:14];
        _dayL.textAlignment = NSTextAlignmentCenter;
    }
    return _dayL;
}

- (UIView *)dotV {
    if (!_dotV) {
        _dotV = [UIView new];
        _dotV.backgroundColor = [UIColor redColor];
        _dotV.layer.masksToBounds = YES;
        _dotV.layer.cornerRadius = 2;
    }
    return _dotV;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.dayL];
    [self addSubview:self.dotV];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(7);
        make.height.width.mas_equalTo(35);
    }];
    
    [self.dayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(16);
    }];
    
    [self.dotV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(32);
        make.width.height.mas_equalTo(4);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
