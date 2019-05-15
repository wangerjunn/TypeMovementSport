//
//  HP_CityMenuView.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HP_CityMenuView : UIView

@property (nonatomic, copy) void (^seleBlock)(NSString *seleCon,NSIndexPath *index);

- (instancetype)initCityMenuViewByFrame:(CGRect)frame
                              seleIndex:(NSIndexPath *)seleIndex
                              seleBlock:(void (^)(NSString *seleCon,NSIndexPath *index))block;

- (void)show;

@end
