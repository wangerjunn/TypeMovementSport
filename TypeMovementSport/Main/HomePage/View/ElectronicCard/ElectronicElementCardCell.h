//
//  ElectronicElementCardCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/25.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectronicElementCardCell : UICollectionViewCell

/*
 标题
 */
@property (nonatomic, strong)UILabel *titLab;
/*
 是否选中
 */
@property (nonatomic, assign) BOOL isSele;

/*
 必选项
 */
@property (nonatomic, strong)UILabel *priceLab;
/*
 必选项
 */
@property (nonatomic, strong)UIImageView *bgView;

@end
