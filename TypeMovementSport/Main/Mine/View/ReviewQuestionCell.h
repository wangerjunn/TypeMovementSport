//
//  ReviewQuestionCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/16.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface ReviewQuestionCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *wrongLabel;
@property (strong, nonatomic) UILabel *rightRateLabel;

@property (nonatomic, strong) QuestionModel *model;

@end
