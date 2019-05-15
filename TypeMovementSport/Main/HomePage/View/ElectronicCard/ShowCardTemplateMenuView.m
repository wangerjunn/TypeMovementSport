//
//  ShowCardTemplateMenuView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/26.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ShowCardTemplateMenuView.h"

@implementation ShowCardTemplateMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initMenuViewByFrame:(CGRect)frame block:(void (^)(NSInteger))block {
    if (self = [super initWithFrame:frame]) {
        self.buttonClickBlock = block;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:bgView];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.tag = 101;
    imgV.image = [UIImage imageNamed:@"HP_card_share"];
    [bgView addSubview:imgV];
    
    UIImageView *imgV1 = [[UIImageView alloc] init];
    imgV1.tag = 102;
    imgV1.image = [UIImage imageNamed:@"HP_card_displaySet"];
    [bgView addSubview:imgV1];
    
    UIImageView *imgV2 = [[UIImageView alloc] init];
    imgV2.tag = 103;
    imgV2.image = [UIImage imageNamed:@"HP_card_updateInfo"];
    [bgView addSubview:imgV2];
    
    UIImageView *imgV3 = [[UIImageView alloc] init];
    imgV3.tag = 100;
    imgV3.image = [UIImage imageNamed:@"HP_card_close"];
    [bgView addSubview:imgV3];
    
    imgV.frame = CGRectMake((kScreenWidth  / 3 - 63)/2.0 , 166, 63, 63);
    imgV1.frame = CGRectMake((kScreenWidth  / 3 - 63)/2.0 +kScreenWidth  / 3 , 166, 63, 63);
    imgV2.frame = CGRectMake((kScreenWidth  / 3 - 63)/2.0 +kScreenWidth  / 3*2 , 166, 63, 63);
    
    imgV3.frame =CGRectMake((kScreenWidth - 36)/2.0, 166+63+36, 36, 36);
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [  imgV3 addGestureRecognizer:tap4];
    imgV3.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [  imgV2 addGestureRecognizer:tap3];
    imgV2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [  imgV1 addGestureRecognizer:tap2];
    imgV1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [  imgV addGestureRecognizer:tap1];
    imgV.userInteractionEnabled = YES;
}

- (void)clickAction:(UITapGestureRecognizer *)tap {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(tap.view.tag-100);
    }
    
    [self removeFromSuperview];
}

@end
