//
//  ECardInfoModel.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/21.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECardInfoModel : BaseModel

/*
 {
     id = 9;
     isMust = 0;
     isSelect = 0;
     name = "\U5b66\U5386";
 }
 */

@property (nonatomic, assign) NSInteger id;//itemid
@property (nonatomic, assign) BOOL isMust;//是否必填项
@property (nonatomic, assign) BOOL isSelect;//是否选择栏目
@property (nonatomic, copy) NSString *name;//item标题
@property (nonatomic, copy) NSString *value;//填写内容

@end

NS_ASSUME_NONNULL_END
