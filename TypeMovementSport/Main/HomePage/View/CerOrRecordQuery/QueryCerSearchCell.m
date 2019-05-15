//
//  QueryCerSearchCell.m
//  HRMP
//
//  Created by Mac on 2018/5/15.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import "QueryCerSearchCell.h"

@implementation QueryCerSearchCell{
    UILabel *professionLab;
    UILabel *examStatusLab;
    UILabel *theoryTitleLab;
    UILabel *opeTitleLab;
    UIImageView *bgImg;
    UIImageView *ShareImg;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
    }
    return self;
    
}
- (void)createViews {
    bgImg = [[UIImageView alloc] init];
    bgImg.image = [UIImage imageNamed:@"HP_record_bg"];
    [self.contentView addSubview:bgImg];
    bgImg.userInteractionEnabled = YES;
    professionLab = [[UILabel alloc] init];
    professionLab.text = @"职业等级";
    professionLab.textColor = k75Color;
    professionLab.font = Font(11);
    [bgImg addSubview:professionLab];
    
    self.professionLevelLab = [[UILabel alloc] init];
    self.professionLevelLab.textColor = k46Color;
    self.professionLevelLab.font = Font(15);
    [bgImg addSubview:self.professionLevelLab];
    
    examStatusLab = [[UILabel alloc] init];
    examStatusLab.text = @"考试状态";
    examStatusLab.textColor = k75Color;
    examStatusLab.font = Font(11);
    [bgImg addSubview:examStatusLab];
    
    self.examResultLab =[[UILabel alloc] init];
    self.examResultLab.textColor = k46Color;
    self.examResultLab.font = Font(15);
    [bgImg addSubview:self.examResultLab];
    
    ShareImg = [[UIImageView alloc] init];
    ShareImg.image = [UIImage imageNamed:@"HP_train_share"];
    [bgImg addSubview:ShareImg];
    
    self.ShareView = [[UIView alloc] init];
    [bgImg addSubview:self.ShareView];
    
    self.theoryScoreLab =[[UILabel alloc] init];
    self.theoryScoreLab.textColor = kOrangeColor;
    self.theoryScoreLab.font = Font(24);
    self.theoryScoreLab.textAlignment = NSTextAlignmentCenter;
    [bgImg addSubview:self.theoryScoreLab];
    
    self.opeScoreLab =[[UILabel alloc] init];
    self.opeScoreLab.textColor = kOrangeColor;
    self.opeScoreLab.font = Font(24);
    self.opeScoreLab.textAlignment = NSTextAlignmentCenter;
    [bgImg addSubview:self.opeScoreLab];
    
    theoryTitleLab = [[UILabel alloc] init];
    theoryTitleLab.text = @"理论科目";
    theoryTitleLab.textColor = k75Color;
    theoryTitleLab.font = Font(11);
    [bgImg addSubview:theoryTitleLab];
    
    opeTitleLab =[[UILabel alloc] init];
    opeTitleLab.text = @"实操科目";
    opeTitleLab.textColor = k75Color;
    opeTitleLab.font = Font(11);
    [bgImg addSubview:opeTitleLab];
    
}
- (void)layoutSubviews {
    bgImg.frame = CGRectMake((kScreenWidth - FIT_SCREEN_WIDTH(343))/2.0, FIT_SCREEN_HEIGHT(10), FIT_SCREEN_WIDTH(343), FIT_SCREEN_HEIGHT(140));
    CGSize size = [ professionLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:professionLab.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    professionLab.frame = CGRectMake(FIT_SCREEN_WIDTH(23), FIT_SCREEN_HEIGHT(25), JGlabelContentWidth, 11);
    CGSize size1 = [ self.professionLevelLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.professionLevelLab.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth1 = size1.width;
    self.professionLevelLab.frame = CGRectMake(FIT_SCREEN_WIDTH(23), professionLab.y+professionLab.height+FIT_SCREEN_HEIGHT(6), JGlabelContentWidth1, 15);
    examStatusLab.frame = CGRectMake(FIT_SCREEN_WIDTH(23),  self.professionLevelLab.y+ self.professionLevelLab.height + FIT_SCREEN_HEIGHT(16), JGlabelContentWidth, 11);
    CGSize size2 = [ self.professionLevelLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.professionLevelLab.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth2 = size2.width;
    self.examResultLab.frame = CGRectMake(FIT_SCREEN_WIDTH(23),  examStatusLab.y+ examStatusLab.height + FIT_SCREEN_HEIGHT(6), JGlabelContentWidth2, 15);
    
    ShareImg.frame = CGRectMake(bgImg.width - FIT_SCREEN_WIDTH(15.5) - FIT_SCREEN_WIDTH(14.5), FIT_SCREEN_HEIGHT(12), FIT_SCREEN_WIDTH(14.5), FIT_SCREEN_HEIGHT(13.5));
    self.ShareView.frame = CGRectMake(bgImg.width - 50, FIT_SCREEN_HEIGHT(10),  40, FIT_SCREEN_HEIGHT(20));
    
    opeTitleLab.frame = CGRectMake(bgImg.width - FIT_SCREEN_WIDTH(28) - JGlabelContentWidth, FIT_SCREEN_HEIGHT(76)+24, JGlabelContentWidth, 11);
    
    theoryTitleLab.frame = CGRectMake(bgImg.width - FIT_SCREEN_WIDTH(56) - JGlabelContentWidth*2  , opeTitleLab.y, JGlabelContentWidth, 11);
    
    self.theoryScoreLab.frame = CGRectMake(theoryTitleLab.x-5, FIT_SCREEN_HEIGHT(67), JGlabelContentWidth+10, 24);
    
    self.opeScoreLab.frame =CGRectMake(opeTitleLab.x-5, FIT_SCREEN_HEIGHT(67), JGlabelContentWidth+10, 24);
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
