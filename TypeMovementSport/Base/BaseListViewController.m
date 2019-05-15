//
//  BaseListViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseListViewController.h"

@interface BaseListViewController ()

@end

@implementation BaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 默认注册一种cell 如果多种 使用注册方法添加即可
- (void)initTableViewWithFrame:(CGRect)frame cellNibName:(NSString *)nibName identifier:(NSString *)identifier
{
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:(UITableViewStylePlain)];
    _tableView.backgroundColor = [UIColor colorWithRed:241.f/255 green:242.f/255 blue:243.f/255 alpha:1.00f];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = UIColorFromRGB(0xececec);
    if (@available(iOS 11.0,*)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if (nibName.length > 1) {
        [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
    }
    
    [self.view addSubview:_tableView];
}
- (void)initTableViewWithFrame:(CGRect)frame cellNibName:(NSString *)nibName identifier:(NSString *)identifier style:(UITableViewStyle)style
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:style];
    _tableView.backgroundColor = [UIColor colorWithRed:241.f/255 green:242.f/255 blue:243.f/255 alpha:1.00f];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = UIColorFromRGB(0xececec);
    if (nibName.length > 1) {
        [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
    }
    
    if (@available(iOS 11.0,*)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:_tableView];
}


#pragma mark -- datasource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"子类要重写此方法");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"子类要重写此方法");
    return nil;
    
}

#pragma mark -- 线偏移
- (void)viewDidLayoutSubviews {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
