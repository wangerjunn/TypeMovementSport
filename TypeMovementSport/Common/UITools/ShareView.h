//
//  ShareView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ShareScene {
    ShareToWx  = 0,//分享到微信
    ShareToPyq = 1,//分享到朋友圈
    ShareToWb = 2,//分享到微博
};

typedef void(^ShareResultBlcok)(id data, NSError *error);

@interface ShareView : UIView

@property (nonatomic, assign) BOOL forceShare;//强制分享

/**
 分享视图

 @param platforms 分享平台数组
 @param viewTitle 分享view标题
 @param shareTitle 分享标题
 @param shareDesp 分享内容
 @param shareLogo 分享logo
 @param shareUrl 分享内容为：图片| 链接
 @return self
 */
- (instancetype)initShareViewBySharePlaform:(NSArray <NSNumber *>*)platforms
                                  viewTitle:(NSString *)viewTitle
                                 shareTitle:(NSString *)shareTitle
                                  shareDesp:(NSString *)shareDesp
                                  shareLogo:(NSString *)shareLogo
                                   shareUrl:(id)shareUrl;

- (void)show;

@end
