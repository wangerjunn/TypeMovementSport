//
//  PlayerVideoViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/10/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "QuestionModel.h"

@interface PlayerVideoViewController : BaseViewController

@property (nonatomic, copy) NSString* liveUrl;//播放链接
@property (nonatomic, copy) NSString* user_tel;//用户手机号
@property (nonatomic, strong) NSString *course_video_play_ms;///**电话动画时间长度*/
@property (nonatomic, strong) NSArray *course_video_points;//动画开始时间
@property (nonatomic, strong) NSString *course_video_lock_flag;//是否显示分享试看 0不显示,1显示
@property (nonatomic, strong) NSString *share_show_second;/**分享试看出现的时间,单位秒*/
@property (nonatomic, strong) NSString *share_show_after_text;/**弹出分享试看的提示*/
@property (nonatomic, strong) NSString *videoPayFlag;/**苹果审核是否显示*/
@property (nonatomic, strong) NSString *IsPush;
@property (nonatomic, strong) NSString *fromWhere; //判断从哪个地方进入
@property (nonatomic, strong) NSString *VideoType;//播放的类型
@property (nonatomic, strong) NSString *ShowAlert;
@property (nonatomic, strong) NSString *videoId;//二级视频typeid
@property (nonatomic, strong) NSMutableDictionary *shareInfoDic;
@property (nonatomic, strong) NSString *time_limit_flag;

@property (nonatomic, copy) void (^showPurchaseViewBlock)(void);//显示购买view
@property (nonatomic, strong) QuestionModel *model;
@end
