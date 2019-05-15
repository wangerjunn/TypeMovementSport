//
//  EnterpriseAuthViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseListViewController.h"
#import "PositionModel.h"

@interface PublishPositionViewController : BaseListViewController

@property (nonatomic, strong) PositionModel *positionModel;
@property (nonatomic, copy) void (^RightBarItemBlock)(NSDictionary *dict);

@end
