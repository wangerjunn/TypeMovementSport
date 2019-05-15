//
//  ArticleCollectListViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleCollectListViewController.h"

//view
#import "ArticleView.h"

@interface ArticleCollectListViewController ()

@end

@implementation ArticleCollectListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"文章收藏"];
    
    [self createUI];
}

- (void)createUI {
    ArticleView *articleView = [[ArticleView alloc] initArticleViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) articleChannelId:0 isFromCollection:YES];
    [self.view addSubview:articleView];
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
