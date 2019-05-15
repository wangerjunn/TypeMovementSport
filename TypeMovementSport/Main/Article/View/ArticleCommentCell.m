//
//  ArticleCommentCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleCommentCell.h"

@implementation ArticleCommentCell{
    UIView *bgView;
    
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
    //头像
    self.UserFaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(11, 25, 50, 50)];
    [self.UserFaceImg setContentMode:UIViewContentModeScaleAspectFill];
    self.UserFaceImg.clipsToBounds = YES;
    [self.UserFaceImg setCornerRadius:25];
    [self.contentView addSubview:self.UserFaceImg];
    
    //回复
    self.ReplyLabel = [LabelTool createLableWithTextColor:k75Color font:Font(11)];
    self.ReplyLabel.textAlignment = NSTextAlignmentRight;
    self.ReplyLabel.text = @"回复";
    self.ReplyLabel.frame = CGRectMake(kScreenWidth - 40 - 40, 32, 40, 16);
    [self.contentView addSubview:self.ReplyLabel];
    
    //姓名
    self.titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(15)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.frame = CGRectMake(self.UserFaceImg.right + 19,
                                       self.ReplyLabel.top, self.ReplyLabel.left - self.UserFaceImg.right - 19,
                                       self.ReplyLabel.height);
    [self.contentView addSubview:self.titleLabel];
    
    //时间
    self.DateLabel = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
    self.DateLabel.textAlignment = NSTextAlignmentLeft;
    self.DateLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+5, _ReplyLabel.right-_titleLabel.left, _titleLabel.height);
    [self.contentView addSubview:self.DateLabel];
    
    //评论内容
    self.CommentLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    self.CommentLabel.textAlignment = NSTextAlignmentLeft;
    self.CommentLabel.numberOfLines = 0;
    self.CommentLabel.frame =CGRectMake(self.DateLabel.left , self.DateLabel.bottom + 10, _DateLabel.width, 36);
    [self.contentView addSubview:self.CommentLabel];
    
    //共几条评论
    bgView = [[UIView alloc] initWithFrame:CGRectMake(self.DateLabel.left, self.CommentLabel.bottom + 10, self.CommentLabel.width, 22)];
    bgView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    [self.contentView addSubview:bgView];
    
    self.ContentLabel = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
    self.ContentLabel.textAlignment = NSTextAlignmentLeft;
    self.ContentLabel.frame =CGRectMake(11, 0, self.CommentLabel.width - 22, 22);
    [bgView addSubview:self.ContentLabel];
    
    self.lane = [[UIView alloc] init];
    self.lane.backgroundColor = k210Color;
    [self.contentView addSubview:self.lane];
}

- (void)setModel:(ArticleCommentModel *)model {
    _model = model;
    [self.UserFaceImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headImg]] placeholderImage:[UIImage imageNamed:holdImage]];
    self.titleLabel.text = model.name;
    
    if (model.dateCreated) {
        NSTimeInterval timeInterval = [model.dateCreated floatValue] / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY.MM.dd      HH:dd"];
        
        NSString *dateStr = [df stringFromDate:date];
        self.DateLabel.text = [NSString stringWithFormat:@"%@",dateStr];
    }
    
    
    
    if (model.contentHeight > 36) {
        self.CommentLabel.frame = CGRectMake(_CommentLabel.left, _CommentLabel.top, _CommentLabel.width, model.contentHeight);
    }else{
        self.CommentLabel.frame = CGRectMake(_CommentLabel.left, _CommentLabel.top, _CommentLabel.width, 36);
    }
    
    _CommentLabel.text = model.content;
    
    [UITool label:_CommentLabel andLineSpacing:3 andColor:k75Color];
    
    if (!model.isHidenTotalView) {
        bgView.frame = CGRectMake(self.DateLabel.left, self.CommentLabel.bottom + 10, self.CommentLabel.width, 22);
        
        self.lane.frame = CGRectMake(self.UserFaceImg.left,
                                     130+model.contentHeight - 1, kScreenWidth - 22, 0.5);
        
        self.ContentLabel.text = [NSString stringWithFormat:@"共%ld条回复>",(long)model.count];
    }else{
        bgView.hidden = YES;
        self.ReplyLabel.hidden = YES;
        self.lane.frame = CGRectMake(self.UserFaceImg.left,
                                     98+_model.contentHeight - 1, kScreenWidth - 22, 0.5);
    }
    
}

@end
