//
//  CalendarModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/28.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalendarModel : BaseModel

@property (nonatomic, assign) NSInteger dateStatus;//日期状态 0：上月时间，1：本月时间，2：下月时间
@property (nonatomic, copy) NSString *dateNum;//日期内容
@property (nonatomic, assign) BOOL isToday;//是否是当天
@property (nonatomic, assign) BOOL isSigned;//是否签到


@end

NS_ASSUME_NONNULL_END
