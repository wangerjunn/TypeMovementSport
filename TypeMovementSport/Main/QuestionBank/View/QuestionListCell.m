//
//  QuestionListCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "QuestionListCell.h"

@implementation QuestionListCell {
    UIView *bgView;
    UIView *laneView;
    UIImageView *lookImg;
    UILabel *lookLab;
    UIImageView *starImg;
    UILabel *starLab;
    UIImageView *bgYinImg;
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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViews];
    }
    
    return self;
}

- (void)createViews{
    
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 12.5;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    
    //标题
    self.titleLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(13)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [bgView addSubview:self.titleLabel];
    
    //练习次数
    self.finishCount = [LabelTool createLableWithTextColor:k75Color font:Font(11)];
    self.finishCount.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.finishCount];
    
    //考试得分
    self.KTCount = [LabelTool createLableWithTextColor:k75Color font:Font(11)];
    self.KTCount.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.KTCount];
    
    //考题章节
    self.numLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(K_TEXT_FONT_12)];
    self.numLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.numLabel];
    
    //是否免费图标
    self.freeImg = [[UIImageView alloc] init];
    self.freeImg.image = [UIImage imageNamed:@"QB_free"];
    [bgView addSubview:self.freeImg];
    
    //是否是上新的考题
    self.NewImg = [[UIImageView alloc] init];
    self.NewImg.image = [UIImage imageNamed:@"QB_new"];
    [bgView addSubview:self.NewImg];
    
    //横着的阴影
    laneView = [[UIView alloc] init];
    laneView.backgroundColor = k210Color;
    [bgView addSubview:laneView];
    
    //试题浏览view
    self.LOOKView = [[UIView alloc] init];
    [bgView addSubview:self.LOOKView];
    
    lookImg = [[UIImageView alloc] init];
    lookImg.image = [UIImage imageNamed:@"QB_browse"];
    [self.LOOKView addSubview:lookImg];
    
    lookLab = [LabelTool createLableWithTextColor:k255Color font:Font(K_TEXT_FONT_12)];
    lookLab.textAlignment = NSTextAlignmentCenter;
    lookLab.text = @"试题浏览";
    [self.LOOKView addSubview:lookLab];
    
    
    //我要考试view
    self.StarView = [[UIView alloc] init];
    [bgView addSubview:self.StarView];
    
    starImg = [[UIImageView alloc] init];
    starImg.image = [UIImage imageNamed:@"模拟笔副本"];
    [self.StarView addSubview:starImg];
    
    starLab = [LabelTool createLableWithTextColor:k255Color font:Font(K_TEXT_FONT_12)];
    starLab.text = @"我要考试";
    starLab.textAlignment = NSTextAlignmentCenter;
    [self.StarView addSubview:starLab];
    
    self.lane = [[UIView alloc] init];
    self.lane.backgroundColor = k210Color;
    [bgView addSubview:self.lane];
    
    bgYinImg = [[UIImageView alloc] init];
    bgYinImg.image = [UIImage imageNamed:@"HP_shadow"];
    [self.contentView addSubview:bgYinImg];
}
- (void)layoutSubviews {
    bgView.frame = CGRectMake(10, 17, kScreenWidth - 20, FIT_SCREEN_HEIGHT(110));
    
    CGSize size = [ self.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    self.titleLabel.frame = CGRectMake(19, 24, JGlabelContentWidth, 15);
    CGSize size3 = [ self.numLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.numLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth3 = size3.width;
    if (kScreenWidth > 320) {
        
    }else {
        self.titleLabel.numberOfLines = 0;
        bgView.height =FIT_SCREEN_HEIGHT(110) + 40;
        self.titleLabel.width = bgView.width - 14 - 18 -JGlabelContentWidth3 - 49 - 10 -10;
        self.titleLabel.height  = 36;
    }
    bgYinImg.frame = CGRectMake(30, bgView.bottom, kScreenWidth - 60, 8);
    CGSize size1 = [ self.finishCount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.finishCount.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth1 = size1.width;
    self.finishCount.frame =CGRectMake(19, self.titleLabel.y + self.titleLabel.height + 10, JGlabelContentWidth1, 11);
    CGSize size2 = [ self.KTCount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.KTCount.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth2 = size2.width;
    self.KTCount.frame = CGRectMake(self.finishCount.x + JGlabelContentWidth1 + 20,self.finishCount.y , JGlabelContentWidth2, 11);
    
    self.numLabel.frame = CGRectMake(bgView.width - 18 - JGlabelContentWidth3, 24.5, JGlabelContentWidth3, 13);
    self.freeImg.frame = CGRectMake(self.numLabel.x - 49 - 10, 15, 49, 44);
    self.NewImg.frame = CGRectMake(bgView.width - 18 -25,  self.numLabel.y +  self.numLabel.height + 9, 25, 12);
    
    laneView.frame = CGRectMake(0, self.finishCount.bottom + 15, bgView.width, 0.5);
    
    self.LOOKView.frame = CGRectMake(0, laneView.y, bgView.width / 2.0, bgView.height - laneView.y);
    CGSize size4 = [lookLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:lookLab.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth4 = size4.width;
    lookImg.frame = CGRectMake((self.LOOKView.width -JGlabelContentWidth4 - 16.5 - 5)/2.0, (self.LOOKView.height - 10.5)/2.0, 16.5, 10.5);
    lookLab.frame = CGRectMake(lookImg.x + 16.5 + 5, 0, JGlabelContentWidth4, self.LOOKView.height);
    
    CGSize size5 = [starLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:starLab.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth5 = size5.width;
    self.StarView.frame =CGRectMake(self.LOOKView.width, laneView.y, bgView.width / 2.0, bgView.height - laneView.y);
    CGFloat coorY_lane = laneView.bottom + (bgView.height - laneView.bottom)/2.0 - FIT_SCREEN_HEIGHT(33)/2.0;
    self.lane.frame = CGRectMake(self.StarView.left, coorY_lane, 0.5, FIT_SCREEN_HEIGHT(33));
    self.lane.hidden = NO;
    self.LOOKView.hidden = NO;
    if ([self.StarExerBtnstr isEqualToString:@"1"]) {
        self.lane.hidden = YES;
        self.LOOKView.hidden = YES;
        self.StarView.frame = CGRectMake(0, laneView.y, bgView.width, bgView.height - laneView.y);
    }
    starImg.frame = CGRectMake((self.StarView.width -JGlabelContentWidth5 - 12 - 5)/2.0, (self.StarView.height - 12)/2.0, 12, 12);
    starLab.frame = CGRectMake(starImg.x + 12 + 5, 0, JGlabelContentWidth5, self.StarView.height);
}

- (void)setModel:(QuestionModel *)model {
    _model = model;
    self.numLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.finishCount.text =  [NSString stringWithFormat:@"%ld 次练习",(long)model.examCount];
    self.KTCount.text = [NSString stringWithFormat:@"%ld分", (long)(model.successCount>=0?model.successCount:0)];
    if (model.price == 0) {
        self.freeImg.hidden = NO;
    }else {
        self.freeImg.hidden = YES;
    }
}

@end
