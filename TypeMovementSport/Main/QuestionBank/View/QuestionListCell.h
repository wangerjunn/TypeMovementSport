//
//  QuestionListCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface QuestionListCell : UITableViewCell

/**免费图片*/
@property (nonatomic, strong) UIImageView *freeImg;
/**NWE的图片*/
@property (nonatomic, strong) UIImageView *NewImg;
/**试题标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**第几套*/
@property (nonatomic, strong) UILabel *numLabel;
/**练习次数*/
@property (nonatomic, strong) UILabel *finishCount;
/**得分*/
@property (nonatomic, strong) UILabel *KTCount;
/**试题浏览*/
@property (nonatomic, strong) UIView *LOOKView;
/**我要考试*/
@property (nonatomic, strong) UIView *StarView;
/**线*/
@property (nonatomic, strong) UIView *lane;
/**试题浏览是否显示*/
@property (nonatomic, strong) NSString *StarExerBtnstr;

@property (nonatomic, strong) QuestionModel *model;

@end
