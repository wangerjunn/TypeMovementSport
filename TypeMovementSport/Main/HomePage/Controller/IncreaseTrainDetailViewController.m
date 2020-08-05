//
//  IncreaseTrainDetailViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "IncreaseTrainDetailViewController.h"
#import "OrderPayViewController.h"
#import <WebKit/WebKit.h>

//view
#import "ShareView.h"

@interface IncreaseTrainDetailViewController () {
    WKWebView *_webView;
}
@end

@implementation IncreaseTrainDetailViewController

# pragma mark -- 分享到平台
- (void)shareToPlatform {
    
    NSString *url = [NSString stringWithFormat:@"%@%zi",kWebTrainShare,self.trainModel.id];
    ShareView  *share = [[ShareView alloc]initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:@"" shareTitle:_trainModel.title shareDesp:kShareDefaultText shareLogo:kShareDefaultLogo shareUrl:url];
    
    [share show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:_trainModel?_trainModel.title:@""];
    [self setNavItemWithImage:@"HP_train_share"
              imageHightLight:@"HP_train_share"
                       isLeft:NO
                       target:self
                       action:@selector(shareToPlatform)];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    [self createUI];
}

- (void)createUI {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:
                     CGRectMake(0, kScreenHeight-kNavigationBarHeight-42,
                                kScreenWidth, 42)];
    btn.backgroundColor = kOrangeColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"支付定金" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(payView) forControlEvents:UIControlEventTouchDown];
    btn.tag = 100;
    
    if (self.trainModel.isPay) {
        [btn setTitle:@"已购买" forState:UIControlStateNormal];
        btn.enabled = NO;
    }
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, btn.top)];
    //http://test.xingdongsport.com/web/t/1
    NSString *url = [NSString stringWithFormat:@"%@%zi",kWebTrainDetail,self.trainModel.id];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        request.HTTPShouldHandleCookies = YES;
    
    [_webView loadRequest:request];
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    [self.view addSubview:btn];
}

# pragma mark -- 支付定金
- (void)payView {
    OrderPayViewController *orderPay = [[OrderPayViewController alloc]init];
    orderPay.orderName = _trainModel.title;
    orderPay.goodsId = [NSString stringWithFormat:@"%ld",(long)_trainModel.id];
    orderPay.orderAmount = _trainModel.earnest/100;
    orderPay.orderEnum = OrderTypeTrain;
    orderPay.navTitle = @"定金支付";
    orderPay.backViewController = self;
    orderPay.PaySuccessBlock = ^{
       //支付成功的回调
        UIButton *payBtn = (UIButton *)[self.view viewWithTag:100];
        [payBtn setTitle:@"已购买" forState:UIControlStateNormal];
        payBtn.enabled = NO;
    };
    [self.navigationController pushViewController:orderPay animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [SVProgressHUD dismiss];
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
