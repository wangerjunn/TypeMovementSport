//
//  Course_SecondLevelCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course_SecondLevelCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *itemCountLabel;//多少项内容
@property (nonatomic, strong) UILabel *priceLabel;//价格标签
@property (nonatomic, strong) UIImageView *lockIcon;//解锁图标
@property (nonatomic, strong) UIImageView *videoTypeIcon;//视频类型
@property (nonatomic, strong) QuestionModel *model;

@end

NS_ASSUME_NONNULL_END
