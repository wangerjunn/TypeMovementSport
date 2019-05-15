//
//  ResumeInfoCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/28.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ResumeInfoCell.h"

@implementation ResumeInfoCell

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
    
    CGFloat coorX = FIT_SCREEN_WIDTH(30);
    self.titleNameLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
    self.titleNameLabel.frame = CGRectMake(coorX, FIT_SCREEN_HEIGHT(10), kScreenWidth - coorX*2 - 100, 14);
    [self.contentView addSubview:self.titleNameLabel];
    
    self.subTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    self.subTitleLabel.frame = CGRectMake(self.titleNameLabel.right, self.titleNameLabel.top, kScreenWidth-coorX-self.titleNameLabel.right, self.titleNameLabel.height);
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.subTitleLabel];
    
    self.conLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_10)];
    self.conLabel.numberOfLines = 0;
    self.conLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.conLabel.frame = CGRectMake(self.titleNameLabel.left, self.titleNameLabel.bottom+5, kScreenWidth-coorX*2, 20);
    
    [self.contentView addSubview:self.conLabel];
    
}

@end
