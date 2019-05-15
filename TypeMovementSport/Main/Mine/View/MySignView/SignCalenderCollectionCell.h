//
//  SignCalenderCollectionCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/28.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignCalenderCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dayLab;//显示日期
@property (nonatomic, strong) UIImageView *triangleIcon;//三角图标

@property (nonatomic, strong) CalendarModel *model;

@end

NS_ASSUME_NONNULL_END
