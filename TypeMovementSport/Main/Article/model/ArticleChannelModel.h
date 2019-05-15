//
//  ArticleChannelModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/10/31.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleChannelModel : BaseModel

@property (nonatomic, assign) NSInteger id;//频道id
@property (nonatomic, copy) NSString *name;//频道名称
@property (nonatomic, assign) BOOL isGetData;

@end
