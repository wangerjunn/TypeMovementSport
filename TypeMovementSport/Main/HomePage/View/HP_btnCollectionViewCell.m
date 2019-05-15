//
//  HP_btnCollectionViewCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/8.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "HP_btnCollectionViewCell.h"

@implementation HP_btnCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
    
}

- (void)prepareUI {
    self.btnView = [[UIView alloc]init];
    self.btnView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.btnView];
    
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.size);
        make.center.mas_equalTo(self);
        
    }];
    
    
    self.icon = [[UIImageView alloc]init];    
    [self.btnView addSubview:self.icon];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(FIT_SCREEN_HEIGHT(7));
        make.width.mas_equalTo(FIT_SCREEN_WIDTH(66));
        make.height.mas_equalTo(FIT_SCREEN_WIDTH(73));
        make.centerX.mas_equalTo(self.btnView);
    }];
    
    self.titleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.btnView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom);
        make.width.mas_equalTo(self.btnView);
        make.height.mas_equalTo(12);
        
    }];
}

@end
