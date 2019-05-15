//
//  PerfectInfoViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"
@interface PerfectInfoViewController : BaseViewController

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, copy) void (^updateInfoBlock)();

@end
