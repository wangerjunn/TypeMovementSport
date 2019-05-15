//
//  CourseHeaderCommonView.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/17.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "CourseHeaderCommonView.h"

@interface CourseHeaderCommonView () {
    
    NSString *_EnglishTitle;
    NSString *_conTitle;
}

@end


@implementation CourseHeaderCommonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initHeaderCommonViewByFrame:(CGRect)frame EnglishTitle:(NSString *)EnglishTitle conTitle:(NSString *)conTitle block:(void (^)(void))cancelBlock {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kViewBgColor;
        self.CancelBlock = cancelBlock;
        _EnglishTitle = EnglishTitle;
        _conTitle = conTitle;
        
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    CGFloat wdtBtn = 15+10;
    UIButton *cancelBtn = [ButtonTool createButtonWithImageName:@"general_cancel" addTarget:self action:@selector(cancel)];
    cancelBtn.frame = CGRectMake(self.width - 20 - wdtBtn, 0, wdtBtn, wdtBtn);
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self addSubview:cancelBtn];
    
    UILabel *titleLabel = [LabelTool createLableWithTextColor:k46Color font:[UIFont fontWithName:@"DINCondensed-Bold" size: 30]];
    titleLabel.numberOfLines = 0;
    titleLabel.frame = CGRectMake(20, 0, cancelBtn.left - 25, 35);
    [self addSubview:titleLabel];
    
    titleLabel.text = _EnglishTitle;
    
    
    UILabel *conLabel = [LabelTool createLableWithTextColor:k46Color font:Font(17)];
    conLabel.text = _conTitle;
    conLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom, kScreenWidth-40, 20);
    [self addSubview:conLabel];
}

- (void)cancel {
    if (self.CancelBlock) {
        self.CancelBlock();
    }
}

@end
