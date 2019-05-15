//
//  DiscountCouponCell.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/2.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "DiscountCouponCell.h"

@interface DiscountCouponCell () {
    UIImageView *line;
}
@end

@implementation DiscountCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    CGFloat coorX = 20;
    self.conView = [[UIView alloc] initWithFrame:CGRectMake(coorX, 0, kScreenWidth-coorX*2, 90)];
    self.conView.layer.cornerRadius = 15;
    self.conView.layer.masksToBounds = YES;
    self.conView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.conView];
    
    //优惠券状态
    CGFloat conCoorX = 10;
    self.discountCouponStatusView = [[UIView alloc] initWithFrame:CGRectMake(conCoorX, conCoorX, conCoorX, conCoorX)];
    [self.discountCouponStatusView setCornerRadius:conCoorX/2.0];
    self.discountCouponStatusView.backgroundColor = kOrangeColor;
    [self.conView addSubview:self.discountCouponStatusView];
    
    //文字状态
    self.statusTextLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_10)];
    self.statusTextLabel.numberOfLines = 0;
    self.statusTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.statusTextLabel.frame = CGRectMake(self.discountCouponStatusView.left, self.discountCouponStatusView.bottom+5, self.discountCouponStatusView.width, self.conView.height - coorX - self.discountCouponStatusView.bottom - 5);
    [self.conView addSubview:self.statusTextLabel];
    self.statusTextLabel.text = @"可用";
    self.statusTextLabel.contentMode = UIViewContentModeTop | UIViewContentModeCenter;
    
    
    //有效期
    self.validityTitleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_10)];
    self.validityTitleLabel.numberOfLines = 0;
    self.validityTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.validityTitleLabel.text = @"有效期\n2018.12.31\n-\n2019.12.31";
    self.validityTitleLabel.frame = CGRectMake(self.conView.width - 80, self.statusTextLabel.top, 80, 50);
    [self.conView addSubview:self.validityTitleLabel];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(self.validityTitleLabel.left -20 ,
                                                         17, 1,
                                                         self.conView.height - 17*2)];
    
    line.image = [UIImage imageNamed:@"mine_coupon_line"];
    [self.conView addSubview:line];
    
    //折扣标识
    self.couponIdenLabel = [LabelTool createLableWithTextColor:k46Color font:[UIFont fontWithName:@"DINCondensed-Bold" size: 15]];
    self.couponIdenLabel.text = @"COUPON";
    self.couponIdenLabel.frame = CGRectMake(self.statusTextLabel.right+22, self.statusTextLabel.top, line.left- self.statusTextLabel.right - 22, 15);
    [self.conView addSubview:self.couponIdenLabel];
    
    //满减
    self.discountContentLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(30)];
    self.discountContentLabel.frame = CGRectMake(_couponIdenLabel.left, _couponIdenLabel.bottom, _couponIdenLabel.width, 30);
    self.discountContentLabel.adjustsFontSizeToFitWidth = YES;
    [self.conView addSubview:self.discountContentLabel];
    
    //使用条件
    self.userConditionLabel = [LabelTool createLableWithTextColor:k75Color
                                                             font:Font(K_TEXT_FONT_12)];
    self.userConditionLabel.numberOfLines = 0;
    self.userConditionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.userConditionLabel.frame = CGRectZero;
    self.userConditionLabel.hidden = YES;
    [self.conView addSubview:self.userConditionLabel];
    
}

- (void)setModel:(CouponModel *)model {
    _model = model;
    
    self.discountContentLabel.text = model.name;

    if (model.status == 0) {
        //可用
        self.statusTextLabel.text = @"可用";
        self.discountContentLabel.textColor = kOrangeColor;
        self.validityTitleLabel.textColor = k46Color;
        self.couponIdenLabel.textColor = k46Color;
        self.discountCouponStatusView.backgroundColor = kOrangeColor;
        self.statusTextLabel.textColor = kOrangeColor;
        self.userConditionLabel.textColor = k75Color;
    }else {
        
        self.userConditionLabel.textColor = UIColorFromRGB(0xEFEFF4);
        self.validityTitleLabel.textColor = UIColorFromRGB(0xEFEFF4);
        self.couponIdenLabel.textColor = UIColorFromRGB(0xEFEFF4);
        self.discountCouponStatusView.backgroundColor = UIColorFromRGB(0xEFEFF4);
        self.discountContentLabel.textColor = UIColorFromRGB(0xEFEFF4);
        self.statusTextLabel.textColor = UIColorFromRGB(0xEFEFF4);
        
        self.statusTextLabel.text = @"已过期";
        if (model.status == 2) {
            self.statusTextLabel.text = @"已使用";
        }
        
    }
    
    self.validityTitleLabel.text = [NSString stringWithFormat:@"有效期\n%@\n-\n%@",model.startTimeStr,model.endTimeStr];
    [self.statusTextLabel sizeToFit];
    
    self.userConditionLabel.text = [_model.remark toString];
    
    if (_model.conditionsHeight > 0) {
        self.userConditionLabel.hidden = NO;
        self.userConditionLabel.frame = CGRectMake(_discountContentLabel.left,
                                                   _discountContentLabel.bottom,
                                                   _discountContentLabel.width,
                                                   _model.conditionsHeight);
        self.conView.height = 90 + _model.conditionsHeight;
        
    }else {
        self.userConditionLabel.hidden = YES;
        self.userConditionLabel.frame = CGRectZero;
        self.conView.height = 90;
    }
    
    line.height = self.conView.height - 17*2;
}

@end
