//
//  UIView+UIViewController.h
//  05 Responder
//
//  Created by wei.chen on 15/3/13.
//  Copyright (c) 2015年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewController)

- (UIViewController *)viewController;

- (UITableViewCell *)tableviewCell;

/*设置顶部圆角*/
- (void)setCornerOnTop:(CGFloat )cornerRadius;

/*设置底部圆角*/
- (void)setCornerOnBottom:(CGFloat )cornerRadius;

/*设置左边圆角*/
- (void)setCornerOnLeft:(CGFloat )cornerRadius;

/*设置右边圆角*/
- (void)setCornerOnRight:(CGFloat )cornerRadius;

/*设置四边圆角*/
- (void)setCornerRadius:(CGFloat)cornerRadius;

@end
