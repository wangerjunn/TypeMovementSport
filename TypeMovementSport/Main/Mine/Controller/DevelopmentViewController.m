//
//  DevelopmentViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "DevelopmentViewController.h"
#import "DeveloperConfig.h"

@interface DevelopmentViewController () {
    NSArray *_urls;
}

@end

@implementation DevelopmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setMyTitle:@"开发者调试"];
    _urls = [DeveloperConfig getAllUrls];
    [self initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) cellNibName:nil identifier:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _urls.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    }
    NSDictionary *urlInfo = _urls[indexPath.row];
    cell.textLabel.text = urlInfo[@"name"];
    cell.detailTextLabel.text = urlInfo[@"url"];
    if ([urlInfo[@"url"] isEqualToString:[DeveloperConfig getCurrentUrl]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [DeveloperConfig changeCurrentConfigUrl:indexPath.row];
    _urls = [DeveloperConfig getAllUrls];
    [tableView reloadData];
    [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"切换成功,将自动退出" buttonTitle:@"确定" block:^(NSInteger index) {
        [Tools clearLoginData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }];
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
