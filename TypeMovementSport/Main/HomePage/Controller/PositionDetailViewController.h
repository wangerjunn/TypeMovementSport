//
//  PositionDetailViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"

@interface PositionDetailViewController : BaseViewController

@property (nonatomic, assign) BOOL isHidenCompanyInfo;//是否显示公司信息 NO:可跳转到公司信息，YES:不可跳转
@property (nonatomic, assign) NSInteger positionId;//职位id
@property (nonatomic, assign) BOOL isSelfPublishPosition;//是否是自己发布的职位

@end
