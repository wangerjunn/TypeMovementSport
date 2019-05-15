//
//  Course_theoryHeaderView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/11.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Course_theoryHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *themeLabel;//标题
@property (nonatomic, strong) UILabel *purchaseStatusLabel;//购买状态
@property (nonatomic, strong) UIImageView *moreIcon;//更多
@property (nonatomic, assign) BOOL isUnFold;
@property (nonatomic, copy) void (^clickFolderBlock)(void);
- (void)showMoreIcon;//显示更多图标


@end
