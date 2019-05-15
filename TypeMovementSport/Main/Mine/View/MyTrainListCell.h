//
//  MyTrainListCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainModel.h"

@interface MyTrainListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *logoImg;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *lessonTimeLabel;
@property (strong, nonatomic) UILabel *cityLabel;
@property (strong, nonatomic) UILabel *paymentLabel;
//@property (strong, nonatomic) UIButton *paymentBtn;

@property (strong, nonatomic) TrainModel *model;

@end
