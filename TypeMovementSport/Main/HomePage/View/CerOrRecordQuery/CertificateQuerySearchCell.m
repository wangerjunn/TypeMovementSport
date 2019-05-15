//
//  CertificateQuerySearchCell.m
//  HRMP
//
//  Created by Mac on 2018/5/15.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import "CertificateQuerySearchCell.h"

@implementation CertificateQuerySearchCell{
    UIImageView *bgImg;
    UIImageView *ShareImg;
    UILabel *name;
    UILabel *place;
    UILabel *dengji;
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
    bgImg.image = [UIImage imageNamed:@"HP_cer_bg"];
    [self.contentView addSubview:bgImg];
    bgImg.userInteractionEnabled = YES;
    
    ShareImg = [[UIImageView alloc] init];
    ShareImg.image = [UIImage imageNamed:@"HP_train_share"];
    [bgImg addSubview:ShareImg];
    
    self.ShareView = [[UIView alloc] init];
    [bgImg addSubview:self.ShareView];
    
    self.examResultLab = [[UILabel alloc]init] ;
    self.examResultLab.text = @"健身教练国家职业资格";
    self.examResultLab.textColor = RGBACOLOR(194, 158, 110, 1);
    self.examResultLab.font = Font(K_TEXT_FONT_12);
    self.examResultLab.textAlignment = NSTextAlignmentCenter;
    [bgImg addSubview:self.examResultLab];
    
    self.examResultTitleLab = [[UILabel alloc]init] ;
    self.examResultTitleLab.text = @"社会体育指导员国家职业资格成绩";
    self.examResultTitleLab.textColor = k210Color;
    self.examResultTitleLab.font = Font(K_TEXT_FONT_10);
    self.examResultTitleLab.textAlignment = NSTextAlignmentCenter;
    [bgImg addSubview:self.examResultTitleLab];
    
    name = [[UILabel alloc] init];
    name.textAlignment =NSTextAlignmentCenter;
    name.textColor = RGBACOLOR(194, 158, 110, 1);
    name.text = @"姓名";
    name.font = Font(K_TEXT_FONT_10);
    [bgImg addSubview:name];
    
    self.NameLab =[[UILabel alloc] init];
    self.NameLab.textAlignment =NSTextAlignmentCenter;
    self.NameLab.textColor = k75Color;
    self.NameLab.font = Font(K_TEXT_FONT_14);
    [bgImg addSubview:self.NameLab];
    
    dengji =[[UILabel alloc] init];
    dengji.textAlignment =NSTextAlignmentCenter;
    dengji.textColor = RGBACOLOR(194, 158, 110, 1);
    dengji.text = @"职业工种与等级";
    dengji.font = Font(K_TEXT_FONT_10);
    
    [bgImg addSubview:dengji];
    
    self.professionLevelLab =[[UILabel alloc] init];
    self.professionLevelLab.textAlignment =NSTextAlignmentCenter;
    self.professionLevelLab.textColor = k75Color;
    self.professionLevelLab.font = Font(K_TEXT_FONT_14);
    self.professionLevelLab.numberOfLines = 0;
    [bgImg addSubview:self.professionLevelLab];
    
    self.NumberLab =[[UILabel alloc] init];
    self.NumberLab.textAlignment =NSTextAlignmentCenter;
    self.NumberLab.textColor = k75Color;
    self.NumberLab.font = Font(K_TEXT_FONT_10);
    [bgImg addSubview:self.NumberLab];
    
    self.PlaceView = [[UIView alloc] init];
    self.PlaceView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.PlaceView];
    self.PlaceView.hidden = YES;
    place = [[UILabel alloc] init];
    place.textAlignment =NSTextAlignmentCenter;
    place.textColor = k75Color;
    place.font = Font(15);
    place.text = @"没有获取到相关数据";
    [self.PlaceView addSubview:place];
}
- (void)layoutSubviews {
    self.PlaceView.frame = CGRectMake(0, 0, self.width, self.height);
    place.frame = CGRectMake(0, 0, self.PlaceView.width, self.PlaceView.height);
    bgImg.frame = CGRectMake((kScreenWidth - FIT_SCREEN_WIDTH(343))/2.0, FIT_SCREEN_HEIGHT(10),  FIT_SCREEN_WIDTH(343), FIT_SCREEN_HEIGHT(204));
    ShareImg.frame = CGRectMake(bgImg.width - FIT_SCREEN_WIDTH(15.5) - FIT_SCREEN_WIDTH(14.5), FIT_SCREEN_HEIGHT(12), FIT_SCREEN_WIDTH(14.5), FIT_SCREEN_HEIGHT(13.5));
    self.ShareView.frame = CGRectMake(bgImg.width - 50, FIT_SCREEN_HEIGHT(10),  40, FIT_SCREEN_HEIGHT(20));
    
    self.examResultLab.frame = CGRectMake(0, FIT_SCREEN_HEIGHT(57.5), bgImg.width, 12);
    
    self.examResultTitleLab.frame = CGRectMake(0, self.examResultLab.y+self.examResultLab.height + FIT_SCREEN_HEIGHT(5.5), bgImg.width, 10);

    name.frame = CGRectMake(0, FIT_SCREEN_HEIGHT(22)+self.examResultTitleLab.y+self.examResultTitleLab.height, FIT_SCREEN_WIDTH(148), 10);
    self.NameLab.frame = CGRectMake(0, FIT_SCREEN_HEIGHT(9)+name.y+name.height, FIT_SCREEN_WIDTH(148), 18);
    
    dengji.frame = CGRectMake(bgImg.width - 210, name.y, 210, 10);
    
  
   self.professionLevelLab.frame =CGRectMake(bgImg.width - 210, self.NameLab.y, 210, 14);
   
    self.NumberLab.frame = CGRectMake(0,bgImg.y+bgImg.height - FIT_SCREEN_HEIGHT(26) -10 , bgImg.width, 10);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
