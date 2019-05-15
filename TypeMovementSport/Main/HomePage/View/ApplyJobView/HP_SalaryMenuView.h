//
//  HP_SalaryMenuView.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HP_SalaryMenuView : UIView

@property (nonatomic, copy) void (^seleBlock)(NSString *seleCon);


/**
 薪资下拉view
 
 @param frame 视图坐标
 @param conArr 包含字符串的薪资数组
 @param seleContent 已选择的薪资内容
 @param block 选中block
 @return self
 */
- (instancetype)initCityMenuViewByFrame:(CGRect)frame
                                    arr:(NSArray <NSString*> *)conArr
                            seleContent:(NSString *)seleContent
                              seleBlock:(void (^)(NSString *seleCon))block;

- (void)show;

@end
