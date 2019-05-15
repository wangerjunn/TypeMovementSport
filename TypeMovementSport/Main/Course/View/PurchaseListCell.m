//
//  PurchaseListCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PurchaseListCell.h"

@implementation PurchaseListCell {
    UIView *lane;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createViews];
        
    }
    return self;
    
}
- (void)createViews {
    
    self.titLab = [LabelTool createLableWithTextColor:k75Color font:Font(13)];
    [self.contentView addSubview:self.titLab];
    
    self.priceLab = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_12)];
    [self.contentView addSubview:self.priceLab];
    
    self.isChooseImg = [[UIImageView alloc] init];
    self.isChooseImg.image = [UIImage imageNamed:@"course_pay_normal"];
    [self.contentView addSubview:self.isChooseImg];
    
    self.chooseImg = [[UIImageView alloc] init];
    self.chooseImg.image = [UIImage imageNamed:@"course_pay_sele"];
    [self.contentView addSubview:self.chooseImg];
    
    lane = [[UIView alloc] init];
    lane.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:lane];
    self.clickBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.clickBtn];
}
- (void)layoutSubviews {
    self.titLab.frame = CGRectMake(0, FIT_SCREEN_HEIGHT(10), self.width - FIT_SCREEN_WIDTH(10), 13);
    self.priceLab.frame = CGRectMake(0, self.titLab.bottom + FIT_SCREEN_HEIGHT(9), self.titLab.width, 12);
    
    CGFloat iconSize = 9;
    self.isChooseImg.frame = CGRectMake(self.width - iconSize, self.titLab.top + (self.titLab.height - iconSize)/2.0, iconSize, iconSize);
    
    CGFloat choosedIconSize = 6;
    self.chooseImg.frame = CGRectMake(self.isChooseImg.left + (iconSize-choosedIconSize)/2.0, self.isChooseImg.top + (iconSize-choosedIconSize)/2.0, choosedIconSize, choosedIconSize);
    
    lane.frame = CGRectMake(0, self.height - 1, self.width, 1);
    self.clickBtn.frame = CGRectMake(10, 10, 10, 10);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
