//
//  IncreaseTrainListCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainModel.h"

@interface IncreaseTrainListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *logoImg;//机构logo
@property (strong, nonatomic) UILabel *titLabel;//标题
@property (strong, nonatomic) UILabel *timeLabel;//地点-时间
@property (strong, nonatomic) UILabel *priceLabel;//价格
@property (strong, nonatomic) UILabel *orgNameLabel;//机构名称
@property (strong, nonatomic) UILabel *numberLabel;//多少人已浏览

@property (strong, nonatomic) TrainModel *model;

@end
