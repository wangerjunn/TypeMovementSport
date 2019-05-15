//
//  BaseListViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseListViewController : BaseViewController <
    UITableViewDataSource,
    UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

/**
 *  默认注册一种cell 如果多种 使用注册方法添加即可
 *
 *  @param frame      tabView的frame
 *  @param nibName    定制cell  的xib名字
 *  @param identifier cell的重用标示符
 */
- (void)initTableViewWithFrame:(CGRect)frame cellNibName:(NSString *)nibName identifier:(NSString *)identifier;
- (void)initTableViewWithFrame:(CGRect)frame cellNibName:(NSString *)nibName identifier:(NSString *)identifier style:(UITableViewStyle)style;

@end
