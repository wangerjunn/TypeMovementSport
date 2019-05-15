//
//  SimulatedExerciseCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/11.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface SimulatedExerciseCell : UITableViewCell
/**试题标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**试题级别价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/**试题类别初中高*/
@property (nonatomic, strong) UILabel *levelLabel;
/**试题购买套数*/
@property (nonatomic, strong) UILabel *buyNumberLabel;
/**试题icon*/
@property (nonatomic, strong) UIImageView *icon;

//即将上线
@property (nonatomic, strong) UIView *maskView;//蒙板view
@property (nonatomic, strong) UILabel *expectLabel;//敬请期待

@property (nonatomic, strong) UIView *attachView;//课件view

@property (nonatomic, strong) QuestionModel *model;

@end
