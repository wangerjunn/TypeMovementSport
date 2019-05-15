//
//  PositionDetailTableHeader.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PositionDetailTableHeader.h"
#import "UIColor+Hex.h"

@implementation PositionDetailTableHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    self.conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    [self.contentView addSubview:self.conView];
    
    UIView *orangeView = [[UIView alloc]initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(26), 15, 2, 15)];
    [self.conView addSubview:orangeView];
    
    [orangeView.layer addSublayer:[UIColor setPayGradualChangingColor:orangeView fromColor:@"FF6B00" toColor:@"F98617"]];
    self.titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(15)];
    self.titleLabel.frame = CGRectMake(orangeView.right+12, orangeView.top, kScreenWidth-orangeView.right-FIT_SCREEN_WIDTH(83), orangeView.height);
    [self.conView addSubview:self.titleLabel];
    
    self.rightLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(15)];
    self.rightLabel.frame = CGRectMake(self.titleLabel.right, self.titleLabel.top, kScreenWidth-self.titleLabel.right, self.titleLabel.height);
    [self.conView addSubview:self.rightLabel];
    
    self.moreIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"general_rightArrow"]];
    self.moreIcon.frame = CGRectMake(kScreenWidth-orangeView.left-11, orangeView.top+(orangeView.height/2.0-17/2.0), 11, 17);
    [self.conView addSubview:self.moreIcon];
}
@end
