//
//  WebViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface WebViewController () <WKNavigationDelegate>

@end

@implementation WebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)reloadWebView{
    [_webView reload];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:self.httpTitle];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
    
    NSMutableURLRequest *request;
    if (self.data) {
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_httpUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        request.HTTPMethod = @"POST";
        
        [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSData *JsonData = [NSJSONSerialization dataWithJSONObject:_data options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPShouldHandleCookies = YES;
        request.HTTPBody = JsonData;
    }else{
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_httpUrl]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        request.HTTPShouldHandleCookies = YES;
        
    }
    
    [self.webView loadRequest:request];
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    //设置第三方Bridge是否可用
    [WebViewJavascriptBridge enableLogging];
    
    //关联webView和bridge
    WebViewJavascriptBridge * _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    [_bridge setWebViewDelegate:self];
    id data = @{@"name" : @"xiaoxiao"};
    [_bridge callHandler:@"ocCallJSFunction" data:data responseCallback:^(id response) {
        NSLog(@"这里是OC调用JS成功后，JS回调的参数:%@", response);
        
    }];
    
    //js给oc传值.'passValue'为双方自定义的统一方法名；'data'为JS传过来的值；'responseCallback'为OC收到值后给JS返回的回调
    [_bridge registerHandler:@"passValue" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //打印js传过来的值
        NSLog(@"%@", data);
        
        //返回给js的值
        responseCallback(@"收到了");
    }];
    
    
    [self setNavBarColor:[UIColor whiteColor]];
    
}
-(void)setHttpUrl:(NSString *)httpUrl{
    _httpUrl = httpUrl;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_httpUrl]]];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([[request.URL absoluteString]isEqualToString:@""]) {
        
        //需要做的事情
        
        return NO;
    }
    return YES;
    
}

- (void)reload{
    [self.webView reload];
}
- (void)stopLoading{
    [self.webView stopLoading];
}

- (void)back{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (void)goForward{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

# pragma mark -- WKNavigationDelegate

# pragma mark --链接开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

# pragma mark -- 收到服务器重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

# pragma mark -- 加载错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

# pragma mark -- 加载完成时
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (!self.httpTitle) {
        [self setMyTitle:self.webView.title];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
