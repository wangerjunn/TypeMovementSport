//
//  SignCalendarView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/28.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"
#import "CalendarModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SignCalendarView : BaseView {
    UIImageView * SignlnImg ;
}

@property (nonatomic, strong) UIImageView * SignlnImg ;
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
                                  dateArr:(NSArray <CalendarModel *>*)dateArr;

- (void)updateUIByDataArr:(NSArray <CalendarModel*>*)dataArr;

@end

NS_ASSUME_NONNULL_END
