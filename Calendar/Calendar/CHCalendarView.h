//
//  CHCalendarView.h
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//  Copyright © 2023 CH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CHCalendarViewDelegate <NSObject>

- (void)leftClickWithDate:(NSDate *)date;
- (void)rightClickWithDate:(NSDate *)date;
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath day:(NSInteger)day;

@end

@interface CHCalendarView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSDate *clickedDate;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<CHCalendarViewDelegate> calendarDelegate;

@end

NS_ASSUME_NONNULL_END
