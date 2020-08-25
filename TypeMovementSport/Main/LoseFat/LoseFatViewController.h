//
//  LoseFatViewController.h
//  TypeMovementSport
//
//  Created by 小二郎 on 2019/7/11.
//  Copyright © 2019年 小二郎. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoseFatViewController : BaseViewController

@property (nonatomic, strong) NSString *viewTitle;
@property (nonatomic, strong) NSString *viewEnglishTitle;
@property (nonatomic, strong) NSString *typeId;//类型ID
@property (nonatomic, assign) BOOL isFromHomePage;

@end

NS_ASSUME_NONNULL_END
