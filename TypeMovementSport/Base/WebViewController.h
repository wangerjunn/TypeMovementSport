//
//  WebViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewController : BaseViewController

@property (nonatomic,copy) NSString * httpUrl;
@property (nonatomic,copy) NSString * httpTitle;
@property (nonatomic,copy) NSDictionary *data;
@property (nonatomic,strong) WKWebView *webView;
- (void)reloadWebView;
- (void)reload;
- (void)stopLoading;

- (void)back;
- (void)goForward;

@end
