//
//  HP_RequireMenuView.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HP_RequireMenuView : UIView

@property (nonatomic, copy) void (^seleBlock)(NSMutableArray *arr);


/**
 薪资下拉view
 
 @param frame 视图坐标
 @param conArr 包含NSDictionary的数组
 @param block 选中block
 @return self
 */
- (instancetype)initCityMenuViewByFrame:(CGRect)frame
                                    arr:(NSMutableArray <NSDictionary*> *)conArr
                              seleBlock:(void (^)(NSMutableArray *arr))block;

- (void)show;

@end
