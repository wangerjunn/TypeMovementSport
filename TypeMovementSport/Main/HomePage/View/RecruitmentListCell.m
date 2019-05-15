//
//  RecruitmentListCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "RecruitmentListCell.h"

@implementation RecruitmentListCell {
    UIView *lane;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = FIT_SCREEN_WIDTH(61)/2.0;
    [self.headImg setContentMode:UIViewContentModeScaleAspectFill];
    self.headImg.clipsToBounds = YES;
    [self.contentView addSubview:self.headImg];
    
    self.nameLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(15)];
    [self.contentView addSubview:self.nameLabel];
    
    self.positionLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
    [self.contentView addSubview:self.positionLabel];
    
    self.salaryLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_12)];
    [self.contentView addSubview:self.salaryLabel];
    
    self.placeLabel = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
    self.placeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.placeLabel.layer.masksToBounds = YES;
    self.placeLabel.layer.borderWidth = 1;
    self.placeLabel.layer.borderColor = k210Color.CGColor;
    [self.contentView addSubview:self.placeLabel];
    
    self.experienceLabel = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
    self.experienceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.experienceLabel.layer.masksToBounds = YES;
    self.experienceLabel.layer.borderWidth = 1;
    self.experienceLabel.layer.borderColor = k210Color.CGColor;
    [self.contentView addSubview:self.experienceLabel];
    
    self.eduLevelLabel = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
    self.eduLevelLabel.textAlignment = NSTextAlignmentCenter;
    
    self.eduLevelLabel.layer.masksToBounds = YES;
    self.eduLevelLabel.layer.borderWidth = 1;
    self.eduLevelLabel.layer.borderColor = k210Color.CGColor;
    [self.contentView addSubview:self.eduLevelLabel];
    
    self.statusLabel = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.layer.borderColor = k210Color.CGColor;
    [self.contentView addSubview:self.statusLabel];
    
    lane = [[UIView alloc] init];
    lane.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:lane];
    
}
- (void)layoutSubviews {
    self.headImg.frame = CGRectMake(FIT_SCREEN_WIDTH(14),  FIT_SCREEN_HEIGHT(14), FIT_SCREEN_WIDTH(61), FIT_SCREEN_HEIGHT(61));
    
    CGSize size = [ self.nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nameLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    self.nameLabel.frame = CGRectMake(self.headImg.right + FIT_SCREEN_WIDTH(14), self.headImg.top, JGlabelContentWidth, 17);
    
    self.positionLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + FIT_SCREEN_HEIGHT(9), kScreenWidth - self.nameLabel.left, 12);
    
    CGSize size1 = [ self.salaryLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.salaryLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth1 = size1.width;
    self.salaryLabel.frame = CGRectMake(self.width - FIT_SCREEN_WIDTH(24) -JGlabelContentWidth1 , FIT_SCREEN_HEIGHT(26), JGlabelContentWidth1, 12);
    
    CGSize size2 = [ self.placeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.placeLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth2 = size2.width + 15;
    self.placeLabel.frame = CGRectMake(self.positionLabel.left, self.positionLabel.bottom + FIT_SCREEN_HEIGHT(9), JGlabelContentWidth2, 14);
    
    CGSize size3 = [ self.experienceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.experienceLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth3 = size3.width +15;
    self.experienceLabel.frame = CGRectMake(self.placeLabel.right + FIT_SCREEN_WIDTH(10) , self.placeLabel.top, JGlabelContentWidth3, 14);
    
    CGSize size4 = [ self.eduLevelLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.eduLevelLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth4 = size4.width + 15;
    self.eduLevelLabel.frame = CGRectMake(self.experienceLabel.right + FIT_SCREEN_WIDTH(10) , self.placeLabel.top, JGlabelContentWidth4, 14);
    
    CGSize size5 = [ self.statusLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.statusLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth5 = size5.width + 15;
    self.statusLabel.frame = CGRectMake(self.eduLevelLabel.right + FIT_SCREEN_WIDTH(10) , self.placeLabel.top, JGlabelContentWidth5, 14);
    lane.frame = CGRectMake(FIT_SCREEN_WIDTH(14), self.height - 0.5, self.width - FIT_SCREEN_WIDTH(28), 0.5);
    
    self.eduLevelLabel.layer.cornerRadius = self.eduLevelLabel.width/8.0;
    self.experienceLabel.layer.cornerRadius = self.experienceLabel.width/8.0;
    self.placeLabel.layer.cornerRadius = self.placeLabel.width/8.0;
    self.statusLabel.layer.cornerRadius = self.statusLabel.width/16.0;
}


- (void)setModel:(ResumeModel *)model {
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:holdFace]];
    self.nameLabel.text =[NSString stringWithFormat:@"%@",model.name?model.name:@""];
    self.salaryLabel.text =[NSString stringWithFormat:@"%@",model.hopealary?model.hopealary:@""];
    self.positionLabel.text =[NSString stringWithFormat:@"%@",model.hopePosition?model.hopePosition:@""] ;;
    self.placeLabel.text =[NSString stringWithFormat:@"%@",model.hopeCity?model.hopeCity:@""];
    self.experienceLabel.text =[NSString stringWithFormat:@"%@",model.workExpYear?model.workExpYear:@""];
    self.eduLevelLabel.text = [NSString stringWithFormat:@"%@",model.education?model.education:@""];
    self.statusLabel.text =[NSString stringWithFormat:@"%@",model.hope?model.hope:@""];
}

@end
