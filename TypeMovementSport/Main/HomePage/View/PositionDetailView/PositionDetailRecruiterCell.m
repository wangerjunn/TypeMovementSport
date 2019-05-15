//
//  PositionDetailRecruiterCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PositionDetailRecruiterCell.h"

@implementation PositionDetailRecruiterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    CGFloat coorX = FIT_SCREEN_WIDTH(26);
    CGFloat wdt_head = FIT_SCREEN_WIDTH(40);
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(coorX, 10, wdt_head, wdt_head)];
    self.headImg.layer.cornerRadius = wdt_head/2.0;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.headImg];
    
    //状态
    self.statusLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_10)];
    CGFloat wdt_status = 45+83;
    
    self.statusLabel.frame = CGRectMake(kScreenWidth - wdt_status, self.headImg.center.y, wdt_status, 10);
    [self.contentView addSubview:self.statusLabel];
    
    //姓名
    self.recruiterLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(15)];
    self.recruiterLabel.frame = CGRectMake(self.headImg.right+15, 12, self.statusLabel.right - self.headImg.right - coorX, 16);
    [self.contentView addSubview:self.recruiterLabel];
    
    //职位
    self.positionLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
    self.positionLabel.frame = CGRectMake(_recruiterLabel.left, _recruiterLabel.bottom+FIT_SCREEN_HEIGHT(6), _recruiterLabel.width, 12);
    [self.contentView addSubview:self.positionLabel];
    
    
    
    self.tagView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tagView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tagView];
}

- (void)setTagsArr:(NSArray *)tagsArr {
    for (UIView *v in self.tagView.subviews) {
        [v removeFromSuperview];
    }
    
    CGFloat coorX = 0;
    CGFloat coorY = 0;
    CGFloat wdtView = kScreenWidth - self.headImg.left*2;
    
    for (int i = 0; i < tagsArr.count; i++) {
        
        UILabel *lab = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
        CGSize size = [tagsArr[i] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName,nil]];
        
        if ((coorX + size.width + 10) > wdtView) {
            coorX = 0;
            coorY += FIT_SCREEN_HEIGHT(20) + 20;
        }
        lab.frame = CGRectMake(coorX, coorY, size.width+10, FIT_SCREEN_HEIGHT(20));
        
        coorX += lab.width + 15;
        
//        if (coorX > wdtView) {
//            coorX = 0;
//            coorY += lab.height + 20;
//        }
        
        lab.textAlignment = NSTextAlignmentCenter;
        
        lab.text = tagsArr[i];
        lab.layer.cornerRadius = lab.height/2.0;
        lab.layer.masksToBounds = YES;
        lab.layer.borderColor = k210Color.CGColor;
        lab.layer.borderWidth = 1;
        [self.tagView addSubview:lab];
    }
    
    
    self.tagView.frame = CGRectMake(self.headImg.left, self.headImg.bottom+20, wdtView, coorY+FIT_SCREEN_HEIGHT(20)+20);
}

@end
