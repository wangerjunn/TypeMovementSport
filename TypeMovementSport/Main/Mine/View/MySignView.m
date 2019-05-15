//
//  MySignView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/14.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "MySignView.h"
#import "SignInHeaderView.h"
#import "ParamFile.h"
#import "SignCalendarView.h"//显示日历view

#import "WebViewController.h"
#import "BaseNavigationViewController.h"

//model
#import "CalendarModel.h"

@interface MySignView () {
    
    NSInteger _curDateNum;//今天多少号
    NSInteger _curWeekIndex;//当前星期下标
    NSString *_currentYearMonth;//当前年月
    NSMutableArray *_currentMonthDays;
    NSMutableArray *_lastMonthDays;
    NSMutableArray *_nextMonthDays;
    NSMutableArray *_totalDateArr;//总数组
    
    SignCalendarView *_calendarView;
    SignInHeaderView * _headerView;
    
    NSString *_integralCount;//签到积分
    NSString *_signDayCount;//签到天数
}

@end

@implementation MySignView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initMySignViewByFrame:(CGRect)frame integralCount:(NSString *)integralCount {
    if (self = [super initWithFrame:frame]) {
        
        _integralCount = integralCount;
        [self calculateDate];
    }
    
    return self;
}

- (void)calculateDate {
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //获取本月天数
    NSInteger dayOfMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSLog(@"本月%ld天",(long)dayOfMonth);
    
    //获取本月多少周
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday fromDate:date];
    NSLog(@"%ld年\n%ld月\n%ld日\n本月%ld周\n今天星期%ld",
          components.year,
          components.month,
          components.day,
          components.weekOfMonth,
          components.weekday);
    
    //当前星期下标 0-6对应周日到周六
    _curWeekIndex = components.weekday - 1;
    _curDateNum = components.day;
    _currentYearMonth = [NSString stringWithFormat:@"%ld.%02ld",components.year,components.month];
    
    //获取本月第一天和最后一天对应的星期日
    NSDate *firstDate =  [self getDateByYear:components.year month:components.month day:1];
    NSInteger firstDayOfWeekday = [calendar components:NSCalendarUnitWeekday fromDate:firstDate].weekday;
    
    NSDate *lastDate = [self getDateByYear:components.year month:components.month day:dayOfMonth];
    NSInteger lastDayOfWeekday = [calendar components:NSCalendarUnitWeekday fromDate:lastDate].weekday;
    
    NSLog(@"本月第一天是周%ld",(long)firstDayOfWeekday);
    NSLog(@"本月最后一天是周%ld",(long)lastDayOfWeekday);
    
    //计算本月第一天和最后一天距离本周差多少天足一周
    NSInteger firstWeek = 0;
    if (firstDayOfWeekday != 1) {
        firstWeek = firstDayOfWeekday - 1;
    }
    
    NSInteger lastWeek = 0;
    if (lastDayOfWeekday != 1) {
        lastWeek = 7 - lastDayOfWeekday;
    }
    NSLog(@"本月第一周第一天差%ld天满一周",firstWeek);
    NSLog(@"本月周后周最后一天差%ld天满一周",lastWeek);
    
    //计算上个月和下个月有多少天
    NSDate *lastMonthDate = [date initWithTimeInterval:-60*60*24*3 sinceDate:firstDate];
    NSDate *nextMonthDate = [date initWithTimeInterval:60*60*24*3 sinceDate:lastDate];
    
    NSInteger daysOfLastMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonthDate].length;
    NSInteger daysOfNextMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nextMonthDate].length;
    
    NSLog(@"上个月份%ld天",daysOfLastMonth);
    NSLog(@"下个月份%ld天",daysOfNextMonth);
    
    _lastMonthDays = [NSMutableArray arrayWithCapacity:firstWeek];
    
    for (int i = 0; i < firstWeek; i++) {
        @autoreleasepool {
            CalendarModel *model = [[CalendarModel alloc] init];
            model.dateStatus = 0;
            model.dateNum = [NSString stringWithFormat:@"%ld",daysOfLastMonth - firstWeek + i + 1];
            
            [_lastMonthDays addObject:model];
        }
    }
    
    //本月数据
    _currentMonthDays = [NSMutableArray arrayWithCapacity:dayOfMonth];
    for (int i = 0; i < dayOfMonth; i++) {
        @autoreleasepool {
            CalendarModel *model = [[CalendarModel alloc] init];
            model.dateStatus = 1;
            model.dateNum = [NSString stringWithFormat:@"%d", i + 1];
            [_currentMonthDays addObject:model];
            if (components.day == i+1) {
                model.isToday = YES;
            }
            
            
        }
    }
    
    //下月
    _nextMonthDays = [NSMutableArray arrayWithCapacity:lastWeek];
    for (int i = 0; i < lastWeek; i++) {
        @autoreleasepool {
            CalendarModel *model = [[CalendarModel alloc] init];
            model.dateStatus = 2;
            model.dateNum = [NSString stringWithFormat:@"%d", i + 1];
            [_nextMonthDays addObject:model];
        }
    }
    
    _totalDateArr = [NSMutableArray array];
    [_totalDateArr addObjectsFromArray:_lastMonthDays];
    [_totalDateArr addObjectsFromArray:_currentMonthDays];
    [_totalDateArr addObjectsFromArray:_nextMonthDays];
    
    _nextMonthDays = nil;
    _currentMonthDays = nil;
    [self createUI];
    [self getCurrentMonthSignDataByMonth:components.month];
}

- (NSDate * )getDateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:components];
    
    return date;
}

- (void)createUI {
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(200))];
    
    [BgView.layer addSublayer:[UIColor setPayGradualChangingColor:BgView fromColor:@"FF6B00" toColor:@"F98617"]];
    [self addSubview:BgView];
    
    // 状态栏(statusbar)
    
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    UILabel* titLab = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(12)];
    titLab.frame = CGRectMake((kScreenWidth - 100)/2.0, (kNavigationBarHeight - StatusRect.size.height - 12) / 2.0 + StatusRect.size.height, 100, 12);
    
    titLab.text = @"我的签到";
    titLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titLab];
    
    UIImageView* LeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, (kNavigationBarHeight - StatusRect.size.height - 20) / 2.0 + StatusRect.size.height, 20, 20)];
    LeftImg.image = [UIImage imageNamed:@"mine_sign_back"];
    
    [self addSubview:LeftImg];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(5, LeftImg.top, 50, 50)];
    
    [self addSubview:leftView];
    leftView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popToPreview)];
    [leftView addGestureRecognizer:tap];
    
    CGFloat wdtView = FIT_SCREEN_WIDTH(337);
    _headerView = [[SignInHeaderView alloc] initWithFrame:CGRectMake((kScreenWidth - wdtView)/2.0 , kNavigationBarHeight, wdtView, FIT_SCREEN_HEIGHT(100))];
    
    [self addSubview:_headerView];
    
    
    CGRect rect = CGRectMake(_headerView.left, _headerView.bottom-15, _headerView.width, FIT_SCREEN_HEIGHT(470));
    _calendarView = [[SignCalendarView alloc] initCalendarViewByframe:rect weekdayIndex:_curWeekIndex dateStr:_currentYearMonth dateArr:_totalDateArr];
    
    [self addSubview:_calendarView];
    
    _calendarView.SignlnImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_sign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSign)];
    [_calendarView.SignlnImg addGestureRecognizer:tap_sign];
    
    UILabel * label  = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    label.frame = CGRectMake(0, _calendarView.bottom + FIT_SCREEN_HEIGHT(10), kScreenWidth, 12);
    label.text = @"了解积分规则 >";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(understandTheRules)];
    [label addGestureRecognizer:tap2];
    
}

# pragma mark -- 积分规则
- (void)understandTheRules {
    WebViewController *web = [[WebViewController alloc]init];
    web.httpTitle = @"积分规则";
    web.httpUrl = @"http://www.xingdongsport.com/SportsServicePlatform/credit/grade.jsp";
    [self.viewController.navigationController pushViewController:web animated:YES];
}

- (void)popToPreview {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 签到
-(void) toSign {
    [MobClick event:@"我的签到，签到按钮"];
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kApiSignInSignIn parms:nil viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            //签到成功
            if (weakSelf.signCallbackBlock) {
                weakSelf.signCallbackBlock();
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf->_calendarView.SignlnImg.image = [UIImage imageNamed:@"mine_sign_sele"];
                strongSelf->_calendarView.SignlnImg.userInteractionEnabled = NO;
                strongSelf->_calendarView.SignlnImg.height = FIT_SCREEN_WIDTH(30);
                CalendarModel *model = strongSelf->_totalDateArr[strongSelf->_curDateNum-1+strongSelf->_lastMonthDays.count];
                model.isSigned = YES;
                
                [strongSelf->_calendarView updateUIByDataArr:strongSelf->_totalDateArr];
                
                
                if (!strongSelf->_signDayCount) {
                    strongSelf->_signDayCount = @"0";
                }
                
                strongSelf->_signDayCount = [NSString stringWithFormat:@"%ld",[strongSelf->_signDayCount integerValue] + 1];
                strongSelf->_integralCount = [NSString stringWithFormat:@"%@",dict[@"integralCount"]?dict[@"integralCount"]:@"0"];
                
                [strongSelf->_headerView userInfoWithNumber:strongSelf->_integralCount DayNum:strongSelf->_signDayCount];
            });
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取当月签到数据
- (void)getCurrentMonthSignDataByMonth:(NSInteger)month {
    TO_WEAK(self, weakSelf);
    
    
    NSDictionary *para = @{
                           @"month":@(month?month:0)
                           };
    [WebRequest PostWithUrlString:kApiSignInFindAllByMonth parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            /*
             (
                 {
                     day = 28;
                     id = 4;
                     month = 12;
                     year = 2018;
                 }
             );
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                
                strongSelf->_integralCount = [NSString stringWithFormat:@"%@",dict[@"integral"]?dict[@"integral"]:@"0"];
                strongSelf->_signDayCount = [NSString stringWithFormat:@"%lu",(unsigned long)list.count];
                [strongSelf->_headerView userInfoWithNumber:strongSelf->_integralCount DayNum:strongSelf->_signDayCount];
                @autoreleasepool {
                    for (int i = 0; i < list.count; i++) {
                        NSDictionary *item = list[i];
                        NSInteger day = [item[@"day"] integerValue];
                        
                        if (strongSelf->_lastMonthDays.count + day <= strongSelf->_totalDateArr.count) {
                            CalendarModel *model = strongSelf->_totalDateArr[strongSelf->_lastMonthDays.count + day -1];
                            model.isSigned = YES;
                        }
                        
                        if (strongSelf->_curDateNum == day) {//判断当天是否已签到
                            strongSelf->_calendarView.SignlnImg.image = [UIImage imageNamed:@"mine_sign_sele"];
                            strongSelf->_calendarView.SignlnImg.userInteractionEnabled = NO;
                            strongSelf->_calendarView.SignlnImg.height = FIT_SCREEN_WIDTH(30);
                        }
                    }
                    
                }
                
                [strongSelf->_calendarView updateUIByDataArr:strongSelf->_totalDateArr];
            });
            
            
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

@end
