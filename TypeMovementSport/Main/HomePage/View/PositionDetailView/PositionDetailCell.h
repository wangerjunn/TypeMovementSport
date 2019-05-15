//
//  PositionDetailCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionDetailCell : UITableViewCell

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) NSString *contentStr;

@property (strong, nonatomic) UIView *line;//底部的线条

//计算内容宽高
- (void)setContentStr:(NSString *)contentStr fontSize:(CGFloat)fontSize;

@end
