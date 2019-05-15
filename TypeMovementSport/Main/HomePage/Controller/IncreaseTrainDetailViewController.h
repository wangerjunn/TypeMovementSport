//
//  IncreaseTrainDetailViewController.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "TrainModel.h"

@interface IncreaseTrainDetailViewController : BaseViewController

//@property (nonatomic, strong) NSString *findURLString;
//@property (nonatomic, strong) NSString *navTitle;
//@property (nonatomic, strong) NSString *shareImgString;
//@property (nonatomic, strong) NSString *brandFlag;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *phone;
//@property (nonatomic, strong) NSString *train_id;
//@property (nonatomic, strong) NSString *time;

@property (nonatomic, copy) void (^PaySuccessCallbackBlock)(void);
@property (nonatomic, strong) TrainModel *trainModel;

@end
