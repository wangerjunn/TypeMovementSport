//
//  PayFinishedViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/15.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "PayFinishedViewController.h"
#import "MyTrainViewController.h"//我的培训

//view
#import "PayFinishedCell.h"

@interface PayFinishedViewController ()
{
    UIImageView *successImg;
    UILabel *successLabel;
    UILabel *thanksLabel;
    UIButton *checkLesson;
    UILabel *payMoney;
    UILabel *moneyLabel;
}

@end

@implementation PayFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"支付完成"];
    
    [self createUI];
}

- (void)createUI {
    
    successImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 35, 44, 70, 70)];
    successImg.image = [UIImage imageNamed:@"general_paySuccess"];
    [self.view addSubview:successImg];
    
    successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, successImg.frame.size.height + 64, kScreenWidth, 18)];
    successLabel.font = Font(18);
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.textColor = [UIColor blackColor];
    successLabel.text = @"恭喜您, 付款成功";
    [self.view addSubview:successLabel];
    
    thanksLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, successLabel.frame.origin.y + 30, kScreenWidth, 12)];
    thanksLabel.font = Font(12);
    thanksLabel.textAlignment = NSTextAlignmentCenter;
    thanksLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    thanksLabel.text = @"感谢您对型动汇的支持";
    [self.view addSubview:thanksLabel];
    
    payMoney = [[UILabel alloc] initWithFrame:CGRectMake(46, thanksLabel.frame.origin.y + 71, 100, 15)];
    payMoney.font = Font(15);
    payMoney.textColor = [UIColor blackColor];
    payMoney.text = @"支付金额:";
    [self.view addSubview:payMoney];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 196, thanksLabel.frame.origin.y + 71, 170, 15)];
    moneyLabel.font = Font(15);
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.text = [NSString stringWithFormat:@"¥ %@", self.goodsPrice];
    [self.view addSubview:moneyLabel];
    
//    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, payMoney.frame.origin.y + 36, kScreenWidth, 156) style:UITableViewStylePlain];
//    detailTableView.delegate = self;
//    detailTableView.dataSource = self;
//    detailTableView.scrollEnabled = NO;
//    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    detailTableView.rowHeight = 26;
//    [self.view addSubview:detailTableView];
//    if (@available(iOS 11.0,*)) {
//        detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        detailTableView.estimatedRowHeight = 0;
//        detailTableView.estimatedSectionHeaderHeight = 0;
//        detailTableView.estimatedSectionFooterHeight = 0;
//    }
//    [detailTableView registerClass:[PayFinishedCell class] forCellReuseIdentifier:@"cell"];
//    
//    
//    checkLesson = [UIButton buttonWithType:UIButtonTypeCustom];
//    checkLesson.frame = CGRectMake(0, kScreenHeight - 113, kScreenWidth, 49);
//    checkLesson.backgroundColor = [UIColor colorWithHexString:@"#FF6B00"];
//    
//    [checkLesson setTitle:@"查看购买内容" forState:UIControlStateNormal];
//    
//    [checkLesson setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    checkLesson.titleLabel.font = Font(18);
//    [self.view addSubview:checkLesson];
//    [checkLesson addTarget:self action:@selector(checkMyLesson:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PayFinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewScrollPositionNone;
//    cell.titleLabel.text = titleArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.infoLabel.text = self.goodsName;
    }  else if (indexPath.row == 1) {
        cell.infoLabel.text = kServiceTele;
    }
    return cell;
    
}

- (void)checkMyLesson:(UIButton *)sender {
    
    if (self.backViewController && [NSStringFromClass(self.backViewController.class) isEqualToString:@"IncreaseTrainDetailViewController"]) {
        //增值培训
        MyTrainViewController *myTrain = [[MyTrainViewController alloc] init];
        myTrain.backViewController = self.backViewController;
        [self.navigationController pushViewController:myTrain animated:YES];
    }else {
        [self goBack];
    }

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
