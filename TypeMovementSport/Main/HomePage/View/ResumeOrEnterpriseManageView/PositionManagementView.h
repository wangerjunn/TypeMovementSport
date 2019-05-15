//
//  PositionManagementView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

typedef enum : NSUInteger {
    CompanyPublishPosition,//公司发布的职位
    UserSendToCompanyPosition,//用户投递的职位
    UserCollectionPosition,//用户收藏的职位
} PositionManamentEnum;

@interface PositionManagementView : BaseView

- (instancetype)initPositionManagementView:(PositionManamentEnum)positionEnum frame:(CGRect)frame requestPara:(NSDictionary *)requestPara;
@property (nonatomic, assign) PositionManamentEnum positionEnum;

- (void)reloadData;

- (void)setTableHeight:(CGFloat)height;

@end
