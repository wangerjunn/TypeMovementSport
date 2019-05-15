//
//  AnswerTableViewHeader.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "AnswerTableViewHeader.h"
#import "ParamFile.h"

@implementation AnswerTableViewHeader

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
    
    //橙色背景竖条
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(28, FIT_SCREEN_HEIGHT(16.5), 2.5, 14)];
    [bgView.layer addSublayer:[UIColor setPayGradualChangingColor:bgView fromColor:@"FF6B00" toColor:@"F98617"]];
    [self.contentView addSubview:bgView];

    
    //考题类型
    self.typeLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(15)];
    [self.contentView addSubview:self.typeLabel];
    self.typeLabel.frame = CGRectMake(bgView.right+4, bgView.top, 100, 15);
    
    //标为重点类型
    self.markKeyPointImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 59, FIT_SCREEN_HEIGHT(16) , 30, 15)];//
    self.markKeyPointImg.image = [UIImage imageNamed:@"QB_keyPoint"];
    self.markKeyPointImg.hidden = YES;
    [self.contentView addSubview:self.markKeyPointImg];

    
    //考题名称
    self.themeLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(13)];
    self.themeLabel.numberOfLines = 0;
    self.themeLabel.frame = CGRectMake(bgView.left, self.typeLabel.bottom+FIT_SCREEN_HEIGHT(20), kScreenWidth-bgView.left*2, 15);
    [self.contentView addSubview:self.themeLabel];
    
    //actionview
    self.actionView = [[UIView alloc]initWithFrame:CGRectMake(0, self.themeLabel.bottom, kScreenWidth, 30)];
    [self.contentView addSubview:self.actionView];
    self.actionView.backgroundColor = RGBColor(249, 249, 249);
    
    UIImageView *markIcon = [[UIImageView alloc]initWithFrame:CGRectMake(35, 9, 12.5, 12.5)];
    markIcon.image = [UIImage imageNamed:@"QB_testNormal"];
    markIcon.tag = 100;
    [self.actionView addSubview:markIcon];
    
    UILabel *markLabel = [LabelTool createLableWithTextColor:k210Color font:Font(12)];
    markLabel.text = @"标为重点";
    CGSize size = [markLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:markLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width+5;
    markLabel.frame = CGRectMake(markIcon.right+7, 0, JGlabelContentWidth, self.actionView.height);
    markLabel.userInteractionEnabled = YES;
    markLabel.tag = 100;
    UITapGestureRecognizer *tap_point = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(clickBottomAction:)];
    [markLabel addGestureRecognizer:tap_point];
    
    [self.actionView addSubview:markLabel];
    
    //试题反馈
    UILabel *feedbackLabel = [LabelTool createLableWithTextColor:k210Color font:Font(12)];
    feedbackLabel.text = @"试题反馈";
    feedbackLabel.userInteractionEnabled = YES;
    feedbackLabel.frame = CGRectMake(self.actionView.width-30.5-JGlabelContentWidth, markLabel.top, markLabel.width, markLabel.height);
    feedbackLabel.tag = 102;
    UITapGestureRecognizer *tap_feedback = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(clickBottomAction:)];
    [feedbackLabel addGestureRecognizer:tap_feedback];
    [self.actionView addSubview:feedbackLabel];
    
    //忽略此题
    UILabel *ignoreLabel = [LabelTool createLableWithTextColor:k210Color font:Font(12)];
    ignoreLabel.text = @"忽略此题";
    ignoreLabel.tag = 101;
    ignoreLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_ignore = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(clickBottomAction:)];
    [ignoreLabel addGestureRecognizer:tap_ignore];
    ignoreLabel.frame = CGRectMake(feedbackLabel.left-JGlabelContentWidth-30.5, feedbackLabel.top, feedbackLabel.width, feedbackLabel.height);
    [self.actionView addSubview:ignoreLabel];
    
    
}

# pragma mark -- 点击底部action
- (void)clickBottomAction:(UITapGestureRecognizer *)tap {
    if (self.ClickBottomActionBlock) {
        self.ClickBottomActionBlock(tap.view.tag - 100);
    }
}

- (void)setModel:(ExamModel *)model {
    
    UIImageView *markIcon = (UIImageView *)[_actionView viewWithTag:100];
    if (model.mark) {
        self.markKeyPointImg.hidden = NO;
        markIcon.image = [UIImage imageNamed:@"QB_testSele"];
    }else {
        self.markKeyPointImg.hidden = YES;
        markIcon.image = [UIImage imageNamed:@"QB_testNormal"];
    }
}

@end
