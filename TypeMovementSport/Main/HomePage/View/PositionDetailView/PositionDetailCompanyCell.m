//
//  PositionDetailCompanyCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PositionDetailCompanyCell.h"

@implementation PositionDetailCompanyCell

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
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    CGFloat coorX = FIT_SCREEN_WIDTH(26);
    CGFloat hgt = FIT_SCREEN_HEIGHT(40);
    self.logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(coorX, FIT_SCREEN_HEIGHT(15), hgt, hgt)];
    self.logoImg.layer.cornerRadius = hgt/2.0;
    self.logoImg.layer.masksToBounds = YES;
    [self.contentView addSubview:self.logoImg];
    
    self.companyNameLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(15)];
    self.companyNameLabel.frame = CGRectMake(self.logoImg.right+15,
                                             self.logoImg.top-FIT_SCREEN_HEIGHT(6),
                                             kScreenWidth-self.logoImg.right-self.logoImg.left-15,
                                             19+FIT_SCREEN_HEIGHT(6)*2);
    self.companyNameLabel.numberOfLines = 0;
    self.companyNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.companyNameLabel.adjustsFontSizeToFitWidth = YES;
        
    [self.contentView addSubview:self.companyNameLabel];
    
    self.scaleLabel = [LabelTool createLableWithTextColor:k46Color
                                                     font:Font(K_TEXT_FONT_12)];
    self.scaleLabel.frame = CGRectMake(self.companyNameLabel.left,
                                       self.companyNameLabel.bottom,
                                       self.companyNameLabel.width, 12);
    [self.contentView addSubview:self.scaleLabel];
}
@end
