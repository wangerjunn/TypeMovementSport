//
//  HP_videoCollectionViewCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/8.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "HP_videoCollectionViewCell.h"

@implementation HP_videoCollectionViewCell

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
    //写布局
    self.videoImg = [[UIImageView alloc]init];
    self.videoImg.contentMode = UIViewContentModeScaleAspectFill;
     [self addSubview:self.videoImg];
    [self.videoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(0);
        make.width.mas_equalTo(FIT_SCREEN_WIDTH(210));
        make.height.mas_equalTo(FIT_SCREEN_HEIGHT(118));
    }];
    self.videoImg.layer.cornerRadius = 5;
    self.videoImg.layer.masksToBounds = YES;
   
    //阴影
    UIImageView *shadowIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_shadow"]];
    [self addSubview:shadowIcon];
    [shadowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.videoImg);
        make.width.mas_equalTo(FIT_SCREEN_WIDTH(187));
        make.height.mas_equalTo(FIT_SCREEN_HEIGHT(22));
        make.top.mas_equalTo(self.videoImg.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    self.titleLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(15)];
    [self.videoImg addSubview:self.titleLabel];
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.textAlignment=0;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.and.bottom.mas_equalTo(-13);
//        make.height.equalTo(@(33));
    }];
    
    
    
}

@end
