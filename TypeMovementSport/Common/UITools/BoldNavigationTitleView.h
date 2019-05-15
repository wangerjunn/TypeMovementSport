//
//  BoldNavigationTitleView.h
//  TypeMovementSport
//
//  Created by XDH on 2019/3/16.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoldNavigationTitleView : BaseView


/**
 导航栏标题view

 @param title 标题内容 eg: "文章 Article"
 @param boldPartContent 加粗部分 "文章"
 @return 导航标题view
 */
- (instancetype)initBoldNavigationTitleView:(NSString *)title boldPart:(NSString *)boldPartContent;

@end

NS_ASSUME_NONNULL_END
