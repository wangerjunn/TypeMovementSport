//
//  MySignViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "MySignViewController.h"

#import "MySignView.h"

@interface MySignViewController ()

@end

@implementation MySignViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setMyTitle:@"我的签到"];
    
    TO_WEAK(self, weakSelf);
    MySignView *signView = [[MySignView alloc] initMySignViewByFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) integralCount:self.integralCount];
    signView.signCallbackBlock = ^{
        if (weakSelf.signDoneBlock) {
            weakSelf.signDoneBlock();
        }
    };
    
    [self.view addSubview:signView];
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
