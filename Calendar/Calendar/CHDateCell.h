//
//  CHDateCell.h
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//  Copyright © 2023 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHDateCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *dayL;
@property (nonatomic, strong) UIView *dotV;

@end

NS_ASSUME_NONNULL_END
