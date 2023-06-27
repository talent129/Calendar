//
//  ViewController.m
//  Calendar
//
//  Created by Curtis on 2023/6/27.
//

#import "ViewController.h"
#import "CHCalendarView.h"
#import <DateTools/DateTools.h>

@interface ViewController ()<CHCalendarViewDelegate>

@property (nonatomic, strong) CHCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

#pragma mark -createUI
- (void)createUI {
    self.calendarView = [[CHCalendarView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200)];
    [self.view addSubview:self.calendarView];
    self.calendarView.calendarDelegate = self;
    
    self.calendarView.clickedDate = [NSDate dateWithYear:[NSDate date].year month:[NSDate date].month day:[NSDate date].day - 1];
    self.calendarView.dataList = @[@"2023-05-30", @"2023-06-25", @"2023-06-29"];
}

#pragma mark -CHCalendarViewDelegate
- (void)leftClickWithDate:(NSDate *)date {
    NSLog(@">>>>left");
}

- (void)rightClickWithDate:(NSDate *)date {
    NSLog(@">>>>right");
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath day:(NSInteger)day {
    NSLog(@">>>>day: %ld", day);
}

@end
