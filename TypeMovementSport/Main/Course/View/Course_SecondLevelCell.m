//
//  Course_SecondLevelCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "Course_SecondLevelCell.h"

@implementation Course_SecondLevelCell {
    UIView *conView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
    
}

- (void)createView {
    conView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-FIT_SCREEN_WIDTH(55))/2.0, FIT_SCREEN_HEIGHT(130))];
    conView.backgroundColor = [UIColor whiteColor];
    conView.layer.cornerRadius = 15;
    [self.contentView addSubview:conView];
    
    //是否购买
    _lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(conView.width-12-15, 15, 12, 15)];
    _lockIcon.image = [UIImage imageNamed:@"course_video_lock"];
    [conView addSubview:_lockIcon];
    
    
    _titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
    _titleLabel.frame = CGRectMake(18, 10, conView.width-18*2-_lockIcon.width-5, 36);
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [conView addSubview:_titleLabel];
    
    //多少项内容
    _itemCountLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
    _itemCountLabel.frame = CGRectMake(_titleLabel.left, conView.height - 36, _titleLabel.width/2.0, 12);
//    _itemCountLabel.text = @"1323项";
    [conView addSubview:_itemCountLabel];
    
    //价格
    _priceLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_12)];
    _priceLabel.frame = CGRectMake(_titleLabel.left, _itemCountLabel.top - 10 - 20, _titleLabel.width, 20);
    [conView addSubview:_priceLabel];
    
    CGFloat wdtTypeIcon =  32;
    CGFloat hgtTypeIcon = 25;
    _videoTypeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(conView.width-wdtTypeIcon-15, conView.height-15-hgtTypeIcon, wdtTypeIcon, hgtTypeIcon)];
    _videoTypeIcon.image = [UIImage imageNamed:@"course_videoType"];
    _videoTypeIcon.backgroundColor = [UIColor clearColor];
    
    UIView *videoBgView = [[UIView alloc] initWithFrame:CGRectMake(_videoTypeIcon.right-22, _videoTypeIcon.top-3, 31, 31)];
    videoBgView.backgroundColor = kOrangeColor;
    [videoBgView setCornerRadius:31/2.0];
    [conView addSubview:videoBgView];
    [conView addSubview:_videoTypeIcon];
}

- (void)setModel:(QuestionModel *)model {
    _model = model;
    if (model.price == 0 || model.expireTime != 0) {
        _lockIcon.hidden = YES;
    }else {
        _lockIcon.hidden = NO;
    }
    
    _priceLabel.text = @"免费";
    if (model.price != 0) {
        _priceLabel.text = [NSString stringWithFormat:@"RMB %.2f",model.price/100];
    }
    _titleLabel.text = model.name;
    _itemCountLabel.text = [NSString stringWithFormat:@"%ld项",model.videoList.count];
}
@end
