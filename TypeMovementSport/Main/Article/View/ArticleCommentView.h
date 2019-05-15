//
//  ArticleCommentView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface ArticleCommentView : BaseView

@property (nonatomic, copy) void (^commentBlock)(NSString *commentContent);

- (instancetype)initArticleCommentViewByViewTitle:(NSString *)viewTitle block:(void (^)(NSString *commentContent))block;

- (void)show;

@end
