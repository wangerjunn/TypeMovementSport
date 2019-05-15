//
//  ChatRoomViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/31.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "EaseMessageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSDictionary *userInfoDic;//用户信息

@end

NS_ASSUME_NONNULL_END
