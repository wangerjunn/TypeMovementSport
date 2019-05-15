//
//  ExclusiveCardCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/25.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExclusiveCardCell : UITableViewCell

/*
 标题
 */
@property (nonatomic, strong)UILabel *titLab;

/*
 填空
 */
@property (nonatomic, strong)UITextField *priceLab;
/*
 图标
 */
@property (nonatomic, strong)UIImageView *imgMore;

@end
