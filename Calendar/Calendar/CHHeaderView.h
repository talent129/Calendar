//
//  CHHeaderView.h
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//  Copyright © 2023 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHHeaderView : UIView

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *currentYML;

@end

NS_ASSUME_NONNULL_END
