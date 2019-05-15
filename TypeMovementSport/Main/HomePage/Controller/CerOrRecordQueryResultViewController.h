//
//  CerOrRecordQueryResultViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/17.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CerOrRecordQueryResultViewController : BaseViewController

@property (nonatomic, strong) NSArray *certList;//证书数据
@property (nonatomic, strong) NSArray *scoreList;//成绩数据
@property (nonatomic, strong) NSString *From;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
