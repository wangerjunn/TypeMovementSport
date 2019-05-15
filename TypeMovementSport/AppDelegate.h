//
//  AppDelegate.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <UMengUShare/WeiboSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isRotation;
//微信回调Block
 @property (copy, nonatomic) void(^WXCallBackResultBlock)(BaseResp*);
//新浪微博回调block
@property (copy, nonatomic) void(^SinaWBCallBackResultBlock)(WBBaseResponse*);

- (void)changeWindowRootViewController;

@end

