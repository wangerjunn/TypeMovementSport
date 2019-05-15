//
//  VideoModel.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/11.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel  : BaseModel
/*
 {
 attemptSecond = "-1";
 id = 1;
 img = "<null>";
 isAttempt = 1;
 name = "公共理论  第1章";
 isShare = "1:分享，0:未分享"
 tips =                         {
     attemptSecond = "允许试看时间(如果不允许试看,不需要再判断此字段)";
     img = "封面图";
     isAttempt = "是否允许试看";
     name = "视频名称";
     url = "路径";
 };
 url = "http://v.sport-osta.cn/75e175eada4f429c818618ba39f322e4/d9563ed5c6c543f2af0e2ef6fe609818-1a3ecb63ef4bbe4c94a51c65730cf704.mp4";
 }
 */

@property (nonatomic, copy) NSString *name;//视频名称
@property (nonatomic, copy) NSString *url;//视频路径
@property (nonatomic, copy) NSString *img;//视频路径
@property (nonatomic, copy) NSString *attemptSecond;//允许试看时间(如果不允许试看,不需要再判断此字段)
@property (nonatomic, assign) NSInteger id;//视频id
@property (nonatomic, assign) BOOL isAttempt;//是否允许试看 0:不允许，1:允许试看
@property (nonatomic, assign) BOOL isPurchase;//是否购买了视频
@property (nonatomic, assign) BOOL isShare;////允许试看时，判断是否已经分享完成

@end

NS_ASSUME_NONNULL_END
