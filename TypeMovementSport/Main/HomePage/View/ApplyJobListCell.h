//
//  ApplyJobListCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionModel.h"

@interface ApplyJobListCell : UITableViewCell

/**展示图片*/
@property (nonatomic, strong) UIImageView *headImg;
/**试题标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**公司*/
@property (nonatomic, strong) UILabel *companyLabel;
/**工资*/
@property (nonatomic, strong) UILabel *salaryLabel;
/**地址*/
@property (nonatomic, strong) UILabel *addressLabel;
/**经验*/
@property (nonatomic, strong) UILabel *experienceLabel;
/**学历*/
@property (nonatomic, strong) UILabel *educationLevelLabel;
/**后缀*/
@property (nonatomic, strong) UILabel *suffixLabel;

@property (nonatomic, strong) PositionModel *model;

@end
