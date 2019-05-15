//
//  QuestionListViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "QuestionListViewController.h"
#import "ReviewQuestionViewController.h"
#import "OrderPayViewController.h"

#import "QuestionListView.h"

@interface QuestionListViewController ()

@property (nonatomic, strong) QuestionListView *listView;
@end

@implementation QuestionListViewController

#pragma mark -- 试题回顾
- (void)reviewQuestion {
    [MobClick event:@"练习页面的试题回顾"];
    ReviewQuestionViewController *review = [[ReviewQuestionViewController alloc]init];
    
    [self.navigationController pushViewController:review animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavBarColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"模拟练习"];
    [self setNavItemWithTitle:@"试题回顾" isLeft:NO target:self action:@selector(reviewQuestion)];
    
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.listView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, kScreenHeight - 100 - kNavigationBarHeight, 90, 90)];
    
    img.image = [UIImage imageNamed:@"general_purchase"];
     img.userInteractionEnabled = YES;
    img.tag = 1111;
    [self.view addSubview:img];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPurchase)];
    [img addGestureRecognizer:tap];
    
    _listView.IsShowPurchaseIconBlock = ^(BOOL isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
             img.hidden = !isShow;
        });
       
    };
   
    TO_WEAK(self, weakSelf);
    _listView.ClickPurchaseBlock = ^{
       //购买
        [weakSelf clickPurchase];
    };
}

- (QuestionListView *)listView {
    if (!_listView) {
        _listView = [[QuestionListView alloc] initQuestionListViewById:_questionModel.id frame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
    }
    return _listView;
}

#pragma mark -- 点击购买
- (void)clickPurchase {
    
    [MobClick event:@"题库，试题购买"];
    OrderPayViewController *orderPay = [[OrderPayViewController alloc]init];
    orderPay.hidesBottomBarWhenPushed = YES;
    orderPay.orderName = self.questionModel.name;
    orderPay.goodsId = [NSString stringWithFormat:@"%ld",(long)_questionModel.id];
    orderPay.orderAmount = _questionModel.price/100;
    orderPay.orderEnum = OrderTypeClasses;
    orderPay.backViewController = self;
    TO_WEAK(self, weakSelf);
    orderPay.PaySuccessBlock = ^{
        
        UIImageView *purchaseIcon = (UIImageView *)[weakSelf.view viewWithTag:1111];
        purchaseIcon.hidden = YES;
        if (weakSelf.PaySuccessCallbackBlock) {
            weakSelf.PaySuccessCallbackBlock();
        }
        TO_STRONG(weakSelf, strongSelf);
       //支付成功的回调
        strongSelf->_listView.isPurchase = YES;
    };
    [self.navigationController pushViewController:orderPay animated:YES];
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
