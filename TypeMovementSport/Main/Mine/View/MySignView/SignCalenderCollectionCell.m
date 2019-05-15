//
//  SignCalenderCollectionCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/28.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "SignCalenderCollectionCell.h"

@implementation SignCalenderCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    CGFloat wdtLabel = 25;
    self.dayLab = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
    self.dayLab.frame = CGRectMake(self.width/2.0-wdtLabel/2.0, 0, wdtLabel, wdtLabel);
    self.dayLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dayLab];
    
    //三角
    self.triangleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_sign_triangle"]];
    //FIT_SCREEN_WIDTH(9), FIT_SCREEN_HEIGHT(6)
    
    CGFloat triangleWdt = FIT_SCREEN_WIDTH(9);
    self.triangleIcon.frame = CGRectMake(self.width/2.0-triangleWdt/2.0, self.dayLab.bottom+2, triangleWdt, FIT_SCREEN_HEIGHT(6));
    [self.contentView addSubview:self.triangleIcon];
    
}

- (void)setModel:(CalendarModel *)model {
    _model = model;
    
    if (model.dateStatus == 1) {
        self.dayLab.textColor = k46Color;
    }else {
        self.dayLab.textColor = k210Color;
    }
//    switch (model.dateStatus) {
//        case 0:
//            //上月数据
//
//            break;
//        case 1:
//            //本月数据
//
//            break;
//        case 2:
//            //下月数据
//            self.dayLab.textColor = k75Color;
//            break;
//
//        default:
//            break;
//    }
    
    if (model.isSigned) {
        [self.dayLab setCornerRadius:self.dayLab.height/2.0];
        self.dayLab.backgroundColor = kOrangeColor;
        self.dayLab.textColor = [UIColor whiteColor];
    } else {
        self.dayLab.backgroundColor = [UIColor clearColor];
        [self.dayLab setCornerRadius:0];
    }
    
    self.dayLab.text = model.dateNum;
    
    if (model.isToday) {
        self.dayLab.text = @"今天";
        self.triangleIcon.hidden = NO;
    } else {
        self.triangleIcon.hidden = YES;
    }
    
}
@end
