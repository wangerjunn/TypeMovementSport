//
//  CerSearchTitleView.h
//  HRMP
//
//  Created by Mac on 2018/5/17.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CerSearchTitleView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) void (^buttonSelected)(NSInteger index);
@end
