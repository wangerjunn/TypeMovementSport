//
//  ElectronicElementCardCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/25.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ElectronicElementCardCell.h"

@implementation ElectronicElementCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
    
}
- (void)prepareUI
{
    self.backgroundColor = [UIColor colorWithRed:247/256.0 green:247/256.0 blue:247/256.0 alpha:1];
    self.bgView = [[UIImageView alloc] init];
    self.bgView.backgroundColor = kOrangeColor;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bgView];
    
    self.titLab = [LabelTool createLableWithTextColor:k75Color font:Font(15)];
    self.titLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titLab];
    
    
    self.priceLab = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    self.priceLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.priceLab];
    
}
- (void)layoutSubviews {
    self.isSele = NO;
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 0, self.width, self.height);
    self.titLab.frame = CGRectMake(0, (self.height - 18)/2.0, self.width, 18);
    self.priceLab.frame = CGRectMake(0, self.titLab.top + 18 , self.width, 13);
    
}

@end
