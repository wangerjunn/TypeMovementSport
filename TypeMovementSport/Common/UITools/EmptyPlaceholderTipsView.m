//
//  EmptyPlaceholderTipsView.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/1.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "EmptyPlaceholderTipsView.h"

@implementation EmptyPlaceholderTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame title:(NSString *)title info:(NSString *)info block:(void (^)(void))block {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBgColor;
        self.ClickPlaceholderViewBlock = block;
      
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 21, self.frame.size.width - 32, 91)];
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF5"];
        self.bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(clickPlaceholderView)];
        [self.bgView addGestureRecognizer:tap];
        [self addSubview:_bgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 100, 16)];
        self.titleLabel.font = Font(K_TEXT_FONT_16);
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#ff4d24"];
        if (title) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@:", title];
        }else {
            self.titleLabel.text = @"温馨提示";
        }
       
        [self.bgView addSubview:_titleLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 41, self.bgView.frame.size.width - 32, 30)];
        self.infoLabel.font = Font(K_TEXT_FONT_12);
        self.infoLabel.textColor = k46Color;
        self.infoLabel.numberOfLines = 2;
        self.infoLabel.text = info;
        [self.bgView addSubview:_infoLabel];
        
    }
    return self;
    
}

#pragma mark -- 点击占位view
- (void)clickPlaceholderView {
    if (self.ClickPlaceholderViewBlock) {
        self.ClickPlaceholderViewBlock();
    }
}

@end
