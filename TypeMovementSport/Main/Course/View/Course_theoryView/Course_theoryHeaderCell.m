//
//  Course_theoryHeaderCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/11.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "Course_theoryHeaderCell.h"

@implementation Course_theoryHeaderCell {
    UIImageView *shadowImg;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self createViews];
    }
    return self;
    
}
- (void)createViews {
    self.BgImg = [[UIImageView alloc] init];
    [self.BgImg setContentMode:UIViewContentModeScaleAspectFill];
    self.BgImg.clipsToBounds = YES;
    [self.contentView addSubview:self.BgImg];
    
    shadowImg = [[UIImageView alloc] init];
    shadowImg.image = [UIImage imageNamed:@"HP_shadow"];
    [self.contentView addSubview:shadowImg];
    
    self.titLab = [[UILabel alloc] init];
    self.titLab.textColor = k75Color;
    self.titLab.font = Font(12);
    self.titLab.numberOfLines = 0;
    [self.contentView addSubview:self.titLab];
    
}
- (void)layoutSubviews {
    
    self.BgImg.frame = CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(200));
    
    shadowImg.frame = CGRectMake(0, FIT_SCREEN_HEIGHT(200), kScreenWidth, 17);
    CGSize lblSize = [UITool sizeOfStr:self.titLab.text andFont:self.titLab.font andMaxSize:CGSizeMake(kScreenWidth - FIT_SCREEN_WIDTH(55), 1000) andLineBreakMode:NSLineBreakByCharWrapping lineSpace:3];
    
    self.titLab.frame = CGRectMake(FIT_SCREEN_WIDTH(27.5), FIT_SCREEN_HEIGHT(200) + FIT_SCREEN_HEIGHT(26), kScreenWidth - FIT_SCREEN_WIDTH(55), lblSize.height);
    
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
