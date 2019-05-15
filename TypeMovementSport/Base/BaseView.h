//
//  BaseView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/5.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
//占位
// 将字典装换成字符串 用于签名
- (NSString *)dictToStr:(NSDictionary *)dict;

//网络请求失败时，重新获取网络
@property (nonatomic, copy) void (^RefreshDataBlock)(void);

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

@end
