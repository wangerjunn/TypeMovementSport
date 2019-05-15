//
//  SignInNewView.m
//  HRMP
//
//  Created by Mac on 2018/4/26.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import "SignInHeaderView.h"
#import "ParamFile.h"

@implementation SignInHeaderView{
    UILabel *numberLab;
    UILabel *SignInLab;
    UILabel *jiFenLab;
    UIView *lane;
    UILabel *DayLab;
    UILabel *DayNumberLab;
    UIImageView *bgImg;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        
    }
    return self;
    
}
- (void)userInfoWithNumber:(NSString *)Number DayNum:(NSString *)DayNum {
    numberLab.text = Number;
    DayLab.text = DayNum;    
    [self changeframe];
}
- (void)createUI {
    bgImg = [[UIImageView alloc] init];
    bgImg.image = [UIImage imageNamed:@"mine_rect"];
    [self addSubview:bgImg];
    
    numberLab = [[UILabel alloc] init];
    numberLab.font = Font(34);
    numberLab.textColor = k255Color;
    numberLab.textAlignment = NSTextAlignmentCenter;
    numberLab.text = @"0";
    [self addSubview:numberLab];
    
    SignInLab = [[UILabel alloc] init];
    SignInLab.textColor = k75Color;
    SignInLab.font = Font(K_TEXT_FONT_10);
    SignInLab.text = @"本月连续签到";
    SignInLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:SignInLab];
    
    jiFenLab = [[UILabel alloc] init];
    jiFenLab.textColor = k75Color;
    jiFenLab.font = Font(10);
    jiFenLab.text = @"我的积分";
    jiFenLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:jiFenLab];
    
    lane = [[UIView alloc] init];
    lane.backgroundColor = LaneCOLOR;
    [self addSubview:lane];
    
    DayLab = [[UILabel alloc] init];
    DayLab.textColor = k255Color;
    DayLab.font = Font(34);
    DayLab.textAlignment = NSTextAlignmentCenter;
    DayLab.text = @"0";
    [self addSubview:DayLab];
    
    DayNumberLab= [[UILabel alloc] init];
    DayNumberLab.textColor = k255Color;
    DayNumberLab.font = Font(K_TEXT_FONT_14);
    DayNumberLab.text = @"天";
    [self addSubview:DayNumberLab];
  
}
- (void)changeframe {
    bgImg.frame = CGRectMake(0, 0, self.width, self.height);
    
    numberLab.frame = CGRectMake((self.width - FIT_SCREEN_WIDTH(320))/2.0, (self.height - 34 - FIT_SCREEN_HEIGHT(8) - 10)/2.0, FIT_SCREEN_WIDTH(320)/2.0, 34);
    jiFenLab.frame = CGRectMake(numberLab.x, numberLab.y + 34 +FIT_SCREEN_HEIGHT(8), numberLab.width, 10);
    lane.frame = CGRectMake(numberLab.x + numberLab.width, (self.height - FIT_SCREEN_HEIGHT(49))/2.0, 0.5, FIT_SCREEN_HEIGHT(49));
    
    CGSize size2 = [DayLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(34),NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth2 = size2.width;
    
    CGSize size3 = [DayNumberLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth3 = size3.width;
    DayLab.frame =CGRectMake(lane.x + (FIT_SCREEN_WIDTH(320)/2.0 - JGlabelContentWidth2 - JGlabelContentWidth3)/2.0, numberLab.y, JGlabelContentWidth2, 34);
    DayNumberLab.frame = CGRectMake(DayLab.x+JGlabelContentWidth2, DayLab.y+DayLab.height - 18, JGlabelContentWidth3, 14);
    
    SignInLab.frame = CGRectMake(lane.x, jiFenLab.y, jiFenLab.width, 10);
    
}


@end
