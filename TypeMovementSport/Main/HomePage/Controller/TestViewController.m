//
//  TestViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/7.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <
    UITableViewDelegate,
UITableViewDataSource> {
    UITableView *table;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self createTable];
//    return;
    BaseView *view1 = [[BaseView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view1.backgroundColor = kOrangeColor;
    [self.view addSubview:view1];
    
    BaseView *view2 = [[BaseView alloc] initWithFrame:CGRectMake(25, 50, 50, 100)];
    view2.backgroundColor = [UIColor greenColor];
    [view1 addSubview:view2];
    view2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewB)];
    [view2 addGestureRecognizer:tap];
    
//    [UIImage imageWithContentsOfFile:<#(nonnull NSString *)#>]
    
    UIImage *image = [UIImage imageNamed:@"guideView_2"];
}

- (void)clickViewB {
    NSLog(@"点击了viewB");
}

- (void)createTable {
    
    table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
//    if (@available(iOS 11.0,*)) {
//        table.estimatedRowHeight = 0;
//        table.estimatedSectionHeaderHeight = 0;
//        table.estimatedSectionFooterHeight = 0;
//        table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    [self.view addSubview:table];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zi",indexPath.row];
    return cell;
    
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
