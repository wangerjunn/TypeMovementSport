//
//  MySignViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"

@interface MySignViewController : BaseViewController

@property (nonatomic, copy) NSString *integralCount;
@property (nonatomic, copy) void (^signDoneBlock)(void);

@end
