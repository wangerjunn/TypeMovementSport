//
//  Course_theoryHeaderView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/11.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "Course_theoryHeaderView.h"

@implementation Course_theoryHeaderView

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
    self.contentView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(clickFolderOrUnFold)];
    [self.contentView addGestureRecognizer:tap];
    
    CGFloat coorX = 27.5;
    self.purchaseStatusLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(11)];
    self.purchaseStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.purchaseStatusLabel.frame = CGRectMake(kScreenWidth -50 -coorX, 16, 50, 20);
    [self.contentView addSubview:self.purchaseStatusLabel];
    self.purchaseStatusLabel.layer.masksToBounds = YES;
    self.purchaseStatusLabel.layer.cornerRadius = 5;
    self.purchaseStatusLabel.layer.borderWidth = 1;
    self.purchaseStatusLabel.layer.borderColor = kOrangeColor.CGColor;
    
    self.themeLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
    
    self.themeLabel.frame = CGRectMake(coorX, 0, self.purchaseStatusLabel.left - coorX - 5, 52);
    self.themeLabel.numberOfLines = 0;
    self.themeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.themeLabel];
    
    
    
    
    self.moreIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 30,16,12, 18)];
    self.moreIcon.image = [UIImage imageNamed:@"general_rightArrow"];
    self.moreIcon.hidden = YES;
    [self.contentView addSubview:self.moreIcon];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.themeLabel.left, 0, kScreenWidth-self.themeLabel.left*2, .5)];
    line.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:line];
}

- (void)showMoreIcon {
    self.moreIcon.hidden = NO;
    
    self.purchaseStatusLabel.origin = CGPointMake(self.moreIcon.left - self.purchaseStatusLabel.width - 10, self.purchaseStatusLabel.top);
    
    self.themeLabel.frame = CGRectMake(self.themeLabel.left,
                                       self.themeLabel.top,
                                       self.purchaseStatusLabel.left - self.themeLabel.left - 5,
                                       self.themeLabel.height);
}

# pragma mark -- 点击抽屉关闭或打开
- (void)clickFolderOrUnFold {
    
    if (self.clickFolderBlock) {
        self.isUnFold = !self.isUnFold;
        if (!self.isUnFold) {
            self.moreIcon.transform = CGAffineTransformIdentity;
            
        }else{
            self.moreIcon.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        self.clickFolderBlock();
    }
   
    
    
}

@end
