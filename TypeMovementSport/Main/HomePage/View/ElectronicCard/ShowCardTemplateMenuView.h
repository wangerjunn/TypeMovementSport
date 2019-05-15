//
//  ShowCardTemplateMenuView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/26.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface ShowCardTemplateMenuView : BaseView

@property (nonatomic, copy) void (^buttonClickBlock)(NSInteger index);


/**
 显示菜单view

 @param frame frame description
 @param block index 0：取消，1：分享，2：展示设置，3：修改信息
 @return self
 */
- (instancetype)initMenuViewByFrame:(CGRect)frame block:(void (^)(NSInteger index))block;

@end
