//
//  BaseNavigationViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationViewController : UINavigationController

//开启滑动返回手势
- (void)openSlideBack;

//关闭滑动返回手势
- (void)closeSlideBack;
    
@end
