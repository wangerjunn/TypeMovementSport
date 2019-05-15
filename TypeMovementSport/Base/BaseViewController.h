//
//  BaseViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIViewController *backViewController;//返回到视图

/**设置返回按钮*/
- (void)setBackItem:(NSString *)imageName AndTitleColor:(UIColor *)color;

/**设置导航栏图片按钮*/
- (void)setNavItemWithImage:(NSString *)imageName
            imageHightLight:(NSString *)hightLight
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action;

/**设置导航栏文字按钮*/
- (void)setNavItemWithTitle:(NSString *)title
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action;
/**隐藏导航栏按钮*/
- (void)setNavItemWithTitle:(NSString *)title isLeft:(BOOL)isLeft;

/**设置当前页标题*/
- (void)setMyTitle:(NSString *)title;


/**设置当前页标题 设置颜色*/
- (void)setMyTitle:(NSString *)title color:(UIColor *)color;

/**返回键,子类不重写默认返回上一页*/
- (void)goBack;

/**隐藏返回按钮*/
- (void)hiddenBackBtn;

/**显示返回按钮*/
- (void)showBackBtn;

/**设置导航栏的颜色*/
- (void)setNavBarColor:(UIColor *)color;

//滑动返回页面
- (void)openSlideBack;

//关闭滑动返回
- (void)closeSlideBack;

/**
 *  开始动画
 *
 */
- (void)startLoadingAnimation;

/**
 *  结束动画
 */
- (void)stopLoadingAnimation;

/**
 *  动画超时block处理
 */
- (void)loadingAnimationTimeOutHandle:(void (^)(void))block;

@property (nonatomic, copy) void (^RefreshDataBlock)(void);

//隐藏键盘
- (void)hiddenKeyBoard;

// 将字典装换成字符串 用于签名
- (NSString *)dictToStr:(NSDictionary *)dict;
@end
