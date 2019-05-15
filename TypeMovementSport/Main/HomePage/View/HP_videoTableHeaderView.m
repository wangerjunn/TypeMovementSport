//
//  HP_videoTableHeaderView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/9.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "HP_videoTableHeaderView.h"
#import "UIColor+Hex.h"

@implementation HP_videoTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    //渐变条
    _gradientView = [[UIView alloc]init];
    [self.contentView addSubview:_gradientView];
    [_gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(FIT_SCREEN_HEIGHT(14));
        make.width.equalTo(@3);
        make.centerY.equalTo(self.contentView);
    }];
    self.titleLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(K_TEXT_FONT_14)];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gradientView.mas_right).offset(8);
        make.bottom.top.equalTo(@0);
        
    }];
    
    self.fireIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HP_fire"]];
    self.fireIcon.hidden = YES;
    [self.contentView addSubview:self.fireIcon];
    [self.fireIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.height.equalTo(self.gradientView);
        make.width.equalTo(self.gradientView.mas_height);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    
    self.moreLabel = [LabelTool createLableWithTextColor:k75Color font:Font(11)];
    [self.contentView addSubview:self.moreLabel];
    self.moreLabel.text = @"更多 >";
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(FIT_SCREEN_WIDTH(45));
    }];
    
    
}


@end
