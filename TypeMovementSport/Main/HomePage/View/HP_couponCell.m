//
//  HP_couponCell.m
//  TypeMovementSport
//
//  Created by XDH on 2019/3/17.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "HP_couponCell.h"

@implementation HP_couponCell

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
        
        self.backgroundColor = [UIColor clearColor];
        UIView *conView = [[UIView alloc] init];
        conView.frame = CGRectMake(20,0,260,80);
        conView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        conView.layer.cornerRadius = 15;
        
        [self.contentView addSubview:conView];
        
        UIImageView *redPointIcon = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"HP_couponRedPoint"]];
        redPointIcon.frame = CGRectMake(9, 18, 12, 12);
        [conView addSubview:redPointIcon];
        
        UIImageView *dashedIcon =  [[UIImageView alloc] initWithImage:
                                    [UIImage imageNamed:@"mine_coupon_line"]];
        dashedIcon.frame = CGRectMake(conView.width - 82, redPointIcon.top, 2,
                                      conView.height - redPointIcon.top*2);
        [conView addSubview:dashedIcon];
        
        self.couponTitleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
        self.couponTitleLabel.frame = CGRectMake(redPointIcon.right+5, 5,
                                                 dashedIcon.left - redPointIcon.right - 5, 30);
        self.couponTitleLabel.numberOfLines = 0;
        [conView addSubview:self.couponTitleLabel];
        
        //优惠券内容
        self.couponConLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(24)];
        self.couponConLabel.frame = CGRectMake(_couponTitleLabel.left, _couponTitleLabel.bottom,
                                                 _couponTitleLabel.width, 40);
        self.couponConLabel.numberOfLines = 0;
        self.couponConLabel.adjustsFontSizeToFitWidth = YES;
        [conView addSubview:self.couponConLabel];
        
        //有效期
        self.couponValidityLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_10)];
        self.couponValidityLabel.frame = CGRectMake(dashedIcon.right+5, 0,
                                               conView.width - dashedIcon.right - 5 - 10, conView.height);
        self.couponValidityLabel.numberOfLines = 0;
        [conView addSubview:self.couponValidityLabel];
    }
    
    return self;
}
@end
