//
//  ExclusiveCardCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/25.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ExclusiveCardCell.h"

@implementation ExclusiveCardCell {
    UIView *views;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self prepareUI];
    }
    return self;
    
}

- (void)prepareUI
{
    self.titLab = [LabelTool createLableWithTextColor:k75Color font:Font(11)];
    self.titLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titLab];
    
    self.priceLab = [[UITextField alloc] init];
    self.priceLab.font = Font(13);
    self.titLab.textColor = k46Color;
    self.priceLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLab];
    views = [[UIView alloc] init];
    views.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:views];
    self.imgMore = [[UIImageView alloc] init];
    self.imgMore.image = [UIImage imageNamed:@"general_rightArrow"];
    [self.contentView addSubview:self.imgMore];
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.titLab.frame = CGRectMake(20, 0, 70, self.height);
    self.priceLab.frame = CGRectMake(90, 0 , self.width - 100, self.height);
    self.imgMore.frame = CGRectMake(kScreenWidth - 24,(self.height - 12.5)/2.0,7.5, 12.5);
    views.frame = CGRectMake(0, self.height - 1, self.width, 0.5);
    
}



@end
