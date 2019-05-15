//
//  ArticleCommentCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCommentModel.h"

@interface ArticleCommentCell : UITableViewCell

/**用户头像*/
@property (nonatomic, strong) UIImageView *UserFaceImg;
/**评论标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**日期标题*/
@property (nonatomic, strong) UILabel *DateLabel;
/**时间标题*/
//@property (nonatomic, strong) UILabel *TimeLabel;
/**评论内容*/
@property (nonatomic, strong) UILabel *CommentLabel;
/**回复按钮*/
@property (nonatomic, strong) UILabel *ReplyLabel;
/**评论回复*/
@property (nonatomic, strong) UILabel *ContentLabel;
/**线条*/
@property (nonatomic, strong) UIView *lane;

@property (nonatomic, strong) ArticleCommentModel *model;

@end
