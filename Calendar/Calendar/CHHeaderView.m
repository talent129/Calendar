//
//  CHHeaderView.m
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//  Copyright © 2023 CH. All rights reserved.
//

#import "CHHeaderView.h"
#import <Masonry/Masonry.h>

@implementation CHHeaderView

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_leftBtn setTitle:@"上月" forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"下月" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightBtn;
}

- (UILabel *)currentYML {
    if (!_currentYML) {
        _currentYML = [UILabel new];
        _currentYML.textColor = [UIColor blackColor];
        _currentYML.font = [UIFont systemFontOfSize:15];
        _currentYML.textAlignment = NSTextAlignmentCenter;
    }
    return _currentYML;
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
    UIView *timeV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, 30)];
    timeV.backgroundColor = [UIColor lightGrayColor];
    timeV.layer.cornerRadius = 4;
    timeV.layer.masksToBounds = YES;
    [self addSubview:timeV];
    
    [timeV addSubview:self.leftBtn];
    [timeV addSubview:self.rightBtn];
    [timeV addSubview:self.currentYML];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(@0);
        make.width.mas_equalTo(40);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(@0);
        make.width.mas_equalTo(40);
    }];
    
    [self.currentYML mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(timeV);
    }];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 6)/7.0;
    NSArray *arr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    for (int i = 0; i < arr.count; i++) {
        UILabel *weekL = [[UILabel alloc] init];
        weekL.text = arr[i];
        weekL.textColor = [UIColor blackColor];
        weekL.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
        weekL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:weekL];
        [weekL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(3 + width * i);
            make.top.equalTo(timeV.mas_bottom).offset(7);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(33);
        }];
    }
}

@end
