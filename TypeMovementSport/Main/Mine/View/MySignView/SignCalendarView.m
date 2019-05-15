//
//  SignCalendarView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/28.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "SignCalendarView.h"
#import "SignCalenderCollectionCell.h"
#import "CalendarFlowLayout.h"
//model

@interface SignCalendarView () <
    UICollectionViewDelegate,
    UICollectionViewDataSource> {
    
        UICollectionView *calendarCollection;
        NSArray <CalendarModel *> *_dataArr;
        NSString *_yearMonthStr;
        NSInteger _currentWeekIndex;
        
}

@end

@implementation SignCalendarView

@synthesize SignlnImg;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 初始化日历view
 @param frame 视图坐标
 @param weekdayIndex 当前星期下标
 @param dateStr 显示年月
 @param dateArr 日期数组
 @return self
 */
- (instancetype)initCalendarViewByframe:(CGRect)frame
                           weekdayIndex:(NSInteger)weekdayIndex
                                dateStr:(NSString *)dateStr
                                dateArr:(NSArray<CalendarModel *> *)dateArr {
    if (self = [super initWithFrame:frame]) {
        
        _currentWeekIndex = weekdayIndex;
        _dataArr = dateArr;
        _yearMonthStr = dateStr;
        [self createUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    //背景view
    UIImageView * bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -3, self.width, self.height)];
    bgImg.image = [UIImage imageNamed:@"mine_btmRect"];
    bgImg.userInteractionEnabled = YES;
    [self addSubview:bgImg];
    
    //创建星期内容
    
    CGFloat weekHgt = FIT_SCREEN_HEIGHT(30);
    
    CGFloat grayViewWdt = FIT_SCREEN_WIDTH(5);
    CGFloat grayViewHgt = FIT_SCREEN_HEIGHT(20);
    CGFloat coorX_grayView = FIT_SCREEN_WIDTH(36);
    NSArray *weekArrs = @[@"Sun\n日",@"Mon\n一",@"Tue\n二",@"Wed\n三",@"Thu\n四",@"Fri\n五",@"Sat\n六"];
    
    CGFloat distance_grayView = (bgImg.width - coorX_grayView * 2 - weekArrs.count * grayViewWdt) / 6;
    
    for (int i = 0; i < weekArrs.count; i++) {
        
        //创建灰色背景view
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(coorX_grayView, 0, grayViewWdt, grayViewHgt)];
        coorX_grayView += grayViewWdt + distance_grayView;
        grayView.backgroundColor = k210Color;
        [grayView setCornerRadius:2.5];
        [self addSubview:grayView];
        
        //创建星期内容
        UILabel *label = [LabelTool createLableWithTextColor:k75Color font:BoldFont(K_TEXT_FONT_12)];
        label.frame = CGRectMake(grayView.left-15, grayView.bottom + FIT_SCREEN_HEIGHT(22), grayView.width+30, weekHgt);
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = weekArrs[i];
        [bgImg addSubview:label];
        if (_currentWeekIndex == i) {
            label.textColor = kOrangeColor;
        }
        
    }
    
    //显示年月
    UILabel *yearMonthLabel = [LabelTool createLableWithTextColor:kOrangeColor font:BoldFont(15)];
    yearMonthLabel.frame = CGRectMake(0, grayViewHgt + FIT_SCREEN_HEIGHT(22) + weekHgt + FIT_SCREEN_HEIGHT(35), self.width, 16);
    yearMonthLabel.textAlignment = NSTextAlignmentCenter;
    yearMonthLabel.text = _yearMonthStr;
    [bgImg addSubview:yearMonthLabel];
    
    //签到按钮
    CGFloat wdtSign = FIT_SCREEN_WIDTH(90);
    CGFloat hgtSign = FIT_SCREEN_WIDTH(50);
     SignlnImg = [[UIImageView alloc] initWithFrame:CGRectMake(bgImg.width/2.0-wdtSign/2.0, bgImg.height - hgtSign - 20, wdtSign, hgtSign)];
    SignlnImg.image = [UIImage imageNamed:@"mine_sign_normal"];
    [bgImg addSubview:SignlnImg];
    
    
    //日期view
    
    CGFloat itemWdt = grayViewWdt + 30;
    CGFloat coorX_collect = FIT_SCREEN_WIDTH(36) - 15;
    CGFloat collectionViewWdt = bgImg.width-coorX_collect*2;
    CalendarFlowLayout *layout = [[CalendarFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWdt, grayViewWdt+35);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = (collectionViewWdt - itemWdt * 7)/6 ;
    
    calendarCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(coorX_collect, yearMonthLabel.bottom + 20, collectionViewWdt, SignlnImg.top-20*2-yearMonthLabel.bottom) collectionViewLayout:layout];
    calendarCollection.delegate = self;
    calendarCollection.dataSource = self;
    calendarCollection.backgroundColor = [UIColor clearColor];
    
    [calendarCollection registerClass:SignCalenderCollectionCell.class forCellWithReuseIdentifier:@"cell"];
    [bgImg addSubview:calendarCollection];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SignCalenderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CalendarModel *model = _dataArr[indexPath.item];
    
    cell.model = model;
    
    return cell;
    
}

- (void)toSign {
    NSLog(@"sign");
}

- (void)updateUIByDataArr:(NSArray<CalendarModel *> *)dataArr {
    _dataArr = dataArr;
    
    [calendarCollection reloadData];
}

@end
