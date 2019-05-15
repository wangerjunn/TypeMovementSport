//
//  ResumeUserInfoCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ResumeUserInfoCell.h"

@interface ResumeUserInfoCell () {
    UIImageView *chatImg;
    UIImageView *ageIcon;
    UIImageView *eduIcon;
    UIImageView *marriageIcon;
}

@end

@implementation ResumeUserInfoCell

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
    CGFloat coorX = FIT_SCREEN_WIDTH(30);
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(coorX, 10, 70, 70)];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 10.0;
    self.headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browseImage)];
    [self.headImg addGestureRecognizer:tap];
    
    [self.contentView addSubview:self.headImg];
    
    self.sexImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_applyJob_male"]];
    self.sexImg.frame = CGRectMake(self.headImg.right - 20, 5, 30, 30);
    [self.contentView addSubview:self.sexImg];
    
    
    UIImageView *shadowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_applyJob_rect"]];
    shadowImg.frame = CGRectMake(self.headImg.left-8.5, self.headImg.bottom, self.headImg.width+17, 23);
    [self.contentView addSubview:shadowImg];
    
    self.nameLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(15)];
//    self.nameLabel.text = @"小呀么XDH";
    self.nameLabel.frame =  CGRectMake(self.headImg.right + FIT_SCREEN_WIDTH(23), self.headImg.top+12, self.nameLabel.width+5, 16);;
    [self.contentView addSubview:self.nameLabel];
    
    chatImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_applyJob_msg"]];
    chatImg.frame = CGRectMake(_nameLabel.right+FIT_SCREEN_WIDTH(15), _nameLabel.top-2, 20, 20);
    [self.contentView addSubview:chatImg];
    
    
    UIImageView *expImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_applyJob_exp"]];
    expImg.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + FIT_SCREEN_HEIGHT(15), 13, 11);
    [self.contentView addSubview:expImg];
    _experienceLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    _experienceLabel.frame = CGRectMake(expImg.right+FIT_SCREEN_WIDTH(5), expImg.top, 20, 12);
    [self.contentView addSubview:_experienceLabel];
    
    
     ageIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_applyJob_birth"]];
    ageIcon.frame = CGRectMake(_experienceLabel.right+5, expImg.top-4, 17, 15);
    [self.contentView addSubview:ageIcon];
    _ageLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    [self.contentView addSubview:_ageLabel];
    _ageLabel.frame = CGRectMake(ageIcon.right+FIT_SCREEN_WIDTH(5), expImg.top,
                                 20, _experienceLabel.height);
    
    //教育
    eduIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_applyJob_edu"]];
    eduIcon.frame = CGRectMake(_ageLabel.right+5, expImg.top-3, 16, 14);
    [self.contentView addSubview:eduIcon];
    _eduLevelLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    _eduLevelLabel.frame = CGRectMake(eduIcon.right+FIT_SCREEN_WIDTH(5), expImg.top,
                                 _ageLabel.width, _ageLabel.height);
    [self.contentView addSubview:_eduLevelLabel];
    
//    marriageIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HP_applyJob_marry"]];
//    marriageIcon.frame = CGRectMake(_eduLevelLabel.right+5, expImg.top-2, 15, 12);
//    [self.contentView addSubview:marriageIcon];
//
//    _maritalStatusLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
//    _maritalStatusLabel.text = @"已婚";
//    [_maritalStatusLabel sizeToFit];
//
//    _maritalStatusLabel.frame = CGRectMake(marriageIcon.right+FIT_SCREEN_WIDTH(5), expImg.top,
//                                 _maritalStatusLabel.width+5, _experienceLabel.height);
//    [self.contentView addSubview:_maritalStatusLabel];
    
    
    //简介
    _introLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    _introLabel.numberOfLines = 0;
    _introLabel.frame = CGRectMake(_nameLabel.left, _ageLabel.bottom+10,
                                    kScreenWidth-_nameLabel.left-_headImg.left, 20);
    [self.contentView addSubview:_introLabel];
}

- (void)setModel:(ResumeModel *)model {
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:holdFace]];
    self.nameLabel.text = model.name;
    
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(self.nameLabel.left, self.headImg.top+12, self.nameLabel.width+5, 16);
    chatImg.frame = CGRectMake(_nameLabel.right+FIT_SCREEN_WIDTH(15), _nameLabel.top-2, 20, 20);
    
    if ([model.sex isEqualToString:@"女性"]) {
        self.sexImg.image = [UIImage imageNamed:@"HP_applyJob_female"];
    }
    
    self.experienceLabel.text = model.workExpYear;
    [_experienceLabel sizeToFit];
    _experienceLabel.frame = CGRectMake(_experienceLabel.left, _experienceLabel.top, _experienceLabel.width, 12);
    [self.contentView addSubview:_experienceLabel];
    
    ageIcon.left = _experienceLabel.right+5;
    self.ageLabel.text = model.birthday;
    [_ageLabel sizeToFit];
    
    _ageLabel.frame = CGRectMake(ageIcon.right+FIT_SCREEN_WIDTH(5), _ageLabel.top,
                                 _ageLabel.width, _experienceLabel.height);
    
    
    eduIcon.left = _ageLabel.right+5;
    self.eduLevelLabel.text = model.education;
    [_eduLevelLabel sizeToFit];
    _eduLevelLabel.frame = CGRectMake(eduIcon.right+FIT_SCREEN_WIDTH(5), _experienceLabel.top,
                                      _eduLevelLabel.width, _experienceLabel.height);
    
//    marriageIcon.left = _eduLevelLabel.right+5;
//    _maritalStatusLabel.left = marriageIcon.right+FIT_SCREEN_WIDTH(5);
    
    //个人简介
    _introLabel.text = model.introduction;
    
    CGSize size = [UITool sizeOfStr:_introLabel.text
                            andFont:Font(K_TEXT_FONT_12)
                         andMaxSize:CGSizeMake(kScreenWidth-_nameLabel.left-_headImg.left, MAXFLOAT)
                   andLineBreakMode:NSLineBreakByCharWrapping];
    
    _introLabel.frame = CGRectMake(_nameLabel.left, _ageLabel.bottom+10,
                                   kScreenWidth-_nameLabel.left-_headImg.left, size.height);
}

#pragma mark -- 浏览图片
- (void)browseImage {
    if (self.ClickHeadBlock) {
        self.ClickHeadBlock();
    }
}

@end
