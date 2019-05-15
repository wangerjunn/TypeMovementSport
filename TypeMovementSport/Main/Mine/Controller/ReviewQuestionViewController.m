//
//  ReviewQuestionViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ReviewQuestionViewController.h"

//view
#import "ReviewQuestionView.h"

@interface ReviewQuestionViewController ()

@end

@implementation ReviewQuestionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"试题回顾"];
    
    [self createUI];
}

- (void)createUI {
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    BOOL isFromMine = NO;
    
    if (viewControllers.count > 1) {
        NSString *className = NSStringFromClass(((UIViewController*)viewControllers[viewControllers.count-2]).class);
        if ([className isEqualToString:@"MineViewController"]) {
            isFromMine = YES;
        }
    }
    ReviewQuestionView *review = [[ReviewQuestionView alloc] initReviewQuestionViewByFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) isFromMine:isFromMine];
    
    [self.view addSubview:review];
    
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
