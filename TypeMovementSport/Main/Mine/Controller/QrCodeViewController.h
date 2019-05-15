//
//  QrCodeViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2019/2/27.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^QRBlock)(void);

@interface QrCodeViewController : BaseViewController

@property (nonatomic,copy)QRBlock qrBlock;


@end

NS_ASSUME_NONNULL_END
