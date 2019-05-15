//
//  QuestionBankViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/24.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "QuestionBankViewController.h"

//view
#import "QuestionBankListView.h"
#import "BoldNavigationTitleView.h"

@interface QuestionBankViewController ()

@property (nonatomic, strong) QuestionBankListView *listView;
@end

@implementation QuestionBankViewController
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBarColor:[UIColor whiteColor]];
    
    if (_listView == nil) {
        [self.view addSubview:self.listView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hiddenBackBtn];
//     [self setMyTitle:@"模拟练习"];
    
    
    
    UIView *topView = [[BoldNavigationTitleView alloc] initBoldNavigationTitleView:@"Exam 练习" boldPart:@"Exam"];
    
//    [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
//    topView.backgroundColor = [UIColor whiteColor];
//
//    UILabel *titleLaebl = [LabelTool createLableWithTextColor:k46Color font:Font(17)];
//    CGFloat coorX = 20;
//    titleLaebl.frame = CGRectMake(coorX, 0, topView.width-coorX*2, 35);
//    titleLaebl.text = @"Exam 练习";
//    titleLaebl.font = [UIFont fontWithName:@"DINCondensed-Bold" size: 18];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:titleLaebl.text];
//    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size: 30] range:NSMakeRange(0, @"Exam".length)];
//    titleLaebl.attributedText = attri;
//    [topView addSubview:titleLaebl];
    
    self.navigationItem.titleView = topView;
}

- (QuestionBankListView *)listView {
    if (_listView == nil) {
        _listView =  [[QuestionBankListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight)];
    }
    
    return _listView;
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
