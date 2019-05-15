//
//  ArticleView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface ArticleView : BaseView


/**
 初始化文章view

 @param frame view's frame
 @param articleChannelId 文章频道id
 @param isFromCollection 我的收藏
 @return self
 */
- (instancetype)initArticleViewWithFrame:(CGRect)frame
                        articleChannelId:(NSInteger)articleChannelId
                        isFromCollection:(BOOL)isFromCollection;

- (void)loadData;

@end
