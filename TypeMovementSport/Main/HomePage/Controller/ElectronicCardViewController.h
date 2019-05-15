//
//  ElectronicCardViewController.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"

@interface ElectronicCardViewController : BaseViewController

@property (nonatomic, strong) NSNumber *templateId;//模板id
@property (nonatomic, strong) NSArray *templateArr;//模板数组
@property (nonatomic, assign) BOOL isQrCode;//二维码

@end
