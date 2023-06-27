//
//  CHCalendarView.m
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//  Copyright © 2023 CH. All rights reserved.
//

#import "CHCalendarView.h"
#import "CHNullCell.h"
#import "CHDateCell.h"
#import "CHHeaderView.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>

#define CHNullCellID @"CHNullCell"
#define CHDateCellID @"CHDateCell"

@interface CHCalendarView()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *todayDate;

@end

@implementation CHCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.date = [NSDate date];
        self.todayDate = [NSDate date];
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    CHHeaderView *header = [[CHHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    [self addSubview:header];
    header.currentYML.text = [NSString stringWithFormat:@"%ld年%02zd月", [self.date year], [self.date month]];
    [header.leftBtn addTarget:self action:@selector(setupLastMonth) forControlEvents:UIControlEventTouchUpInside];
    [header.rightBtn addTarget:self action:@selector(setupNextMonth) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[CHNullCell class] forCellWithReuseIdentifier:CHNullCellID];
    [self.collectionView registerClass:[CHDateCell class] forCellWithReuseIdentifier:CHDateCellID];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.bottom.mas_equalTo(-10);
    }];
    [self.collectionView reloadData];
}

- (void)setupLastMonth {
    [_collectionView removeFromSuperview];
    _collectionView = nil;

    self.date = [self lastMonth:self.date];
    
    [self setupViews];
    
    if ([self.calendarDelegate respondsToSelector:@selector(leftClickWithDate:)]) {
        [self.calendarDelegate leftClickWithDate:self.date];
    }
}

- (void)setupNextMonth {
    
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    
    self.date = [self nextMonth:self.date];
    [self setupViews];
    
    if ([self.calendarDelegate respondsToSelector:@selector(rightClickWithDate:)]) {
        [self.calendarDelegate rightClickWithDate:self.date];
    }
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger totalDays = [self totaldaysInMonth:self.date];
    NSInteger firstDay = [self firstWeekdayInThisMonth:self.date];
    NSInteger itemSum = totalDays + firstDay;
    NSInteger res = itemSum / 7;
    NSInteger resu = itemSum % 7;
    if (resu == 0) {
        return res * 7;
    } else {
        return (res + 1) * 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CHDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHDateCellID forIndexPath:indexPath];
    if (indexPath.row < [self firstWeekdayInThisMonth:self.date]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHNullCellID forIndexPath:indexPath];
    } else if (indexPath.row >= ([self totaldaysInMonth:self.date] + [self firstWeekdayInThisMonth:self.date])) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHNullCellID forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHDateCellID forIndexPath:indexPath];
        cell.dayL.text = [[NSString alloc] initWithFormat:@"%ld", indexPath.row - [self firstWeekdayInThisMonth:self.date] + 1];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSInteger year = [self year:self.date];
        NSInteger month = [self month:self.date];
        NSString *dayString = [NSString stringWithFormat:@"%ld-%02zd-%02zd", (long)year, month, indexPath.row - [self firstWeekdayInThisMonth:self.date] + 1];
        NSDate *dayDate = [formatter dateFromString:dayString];
        long long dayLong = [dayDate timeIntervalSince1970];//每月每天时间戳
        
        NSString *todayStr = [formatter stringFromDate:self.todayDate];
        NSDate *todayDate = [formatter dateFromString:todayStr];
        long long todayLong = [todayDate timeIntervalSince1970];//今天时间戳
        
        if (dayLong < todayLong) {
            cell.bgView.backgroundColor = [UIColor whiteColor];
            cell.dayL.textColor = [UIColor blackColor];
            
            if (dayLong == [self.clickedDate timeIntervalSince1970]) {
                cell.dayL.textColor = [UIColor greenColor];
            }
        } else if (dayLong == todayLong) {
            cell.bgView.backgroundColor = [UIColor purpleColor];
            cell.dayL.textColor = [UIColor whiteColor];
        } else {
            cell.bgView.backgroundColor = [UIColor whiteColor];
            cell.dayL.textColor = [UIColor lightGrayColor];
            
            if (dayLong == [self.clickedDate timeIntervalSince1970]) {
                cell.dayL.textColor = [UIColor greenColor];
            }
        }
        
        if ([self.dataList containsObject:dayString]) {
            cell.dotV.hidden = NO;
            if (dayLong < todayLong) {
                cell.dotV.backgroundColor = [UIColor blueColor];
            } else if (dayLong == todayLong) {
                cell.dotV.backgroundColor = [UIColor redColor];
            } else {
                cell.dotV.backgroundColor = [UIColor purpleColor];
            }
        } else {
            cell.dotV.hidden = YES;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.calendarDelegate respondsToSelector:@selector(didSelectItemAtIndexPath:day:)]) {
        [self.calendarDelegate didSelectItemAtIndexPath:indexPath day:(indexPath.row - [self firstWeekdayInThisMonth:self.date] + 1)];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 6)/7.0;
    return CGSizeMake(itemWidth, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark -private
//当月第一天为周几
//0:周日   1:周一  2:周二   3:周三   4:周四  5:周五   6:周六
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//每月的总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-
//上月
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

//下月
- (NSDate*)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


#pragma mark - date get: day-month-year
//日期--天
- (NSInteger)day:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//月份
- (NSInteger)month:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

//年份
- (NSInteger)year:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

@end
