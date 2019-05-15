//
//  ArticleCommentDetailViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseListViewController.h"
#import "ArticleCommentModel.h"

@interface ArticleCommentDetailViewController : BaseListViewController

@property (nonatomic, assign) NSInteger articleId;//文章id
@property (nonatomic, assign) NSInteger commentId;//评论id
@property (nonatomic, strong) ArticleCommentModel *model;
@property (nonatomic, copy) void (^CommentSuccessRefreshUIBlock)(void);

@end
