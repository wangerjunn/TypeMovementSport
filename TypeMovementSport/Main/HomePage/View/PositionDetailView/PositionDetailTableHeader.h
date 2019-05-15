//
//  PositionDetailTableHeader.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionDetailTableHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *conView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *moreIcon;

//@property (nonatomic, copy) void (^clickCellBlock)();

@end
