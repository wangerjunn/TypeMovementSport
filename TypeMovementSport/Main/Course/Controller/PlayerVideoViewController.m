//
//  PlayerVideoViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/10/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PlayerVideoViewController.h"

#import "AppDelegate.h"

#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"

@interface PlayerVideoViewController () {
    
    NSString *fileName;//进度保存的路径
    NSString *strTime;//获取保存的播放时间
    NSString *saveKey;//保存时间时对应的KEY
}

@property (nonatomic,weak) CLPlayerView *playerView;


@end

@implementation PlayerVideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isRotation = YES;
    [self setNewOrientation:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isRotation = NO;
    [self setNewOrientation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 90, self.view.CLwidth, 300)];
    
    _playerView = playerView;
    [self.view addSubview:_playerView];
    _playerView.whereFrom = self.fromWhere;
    
    _playerView.user_tel = self.user_tel;
    if ([self.fromWhere isEqualToString:@"Home"]) {
        
    }else {
        [self searchProgress];
    }
    
    //重复播放，默认不播放
    _playerView.repeatPlay = YES;
    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    _playerView.isLandscape = NO;
    //设置等比例全屏拉伸，多余部分会被剪切
    _playerView.fillMode = ResizeAspect;
    //设置进度条背景颜色
    //_playerView.progressBackgroundColor = [UIColor purpleColor];
    //设置进度条缓冲颜色
    //_playerView.progressBufferColor = [UIColor redColor];
    //设置进度条播放完成颜色
    _playerView.progressPlayFinishColor = kOrangeColor;
    //全屏是否隐藏状态栏
    //_playerView.fullStatusBarHidden = NO;
    //转子颜色
    //_playerView.strokeColor = [UIColor redColor];
    //视频地址
    _playerView.url = [NSURL URLWithString:self.liveUrl];
    _playerView.user_tel = self.user_tel;
    _playerView.course_video_play_ms = [NSString stringWithFormat:@"%@",self.course_video_play_ms];
    _playerView.course_vidoe_lock_flag = [NSString stringWithFormat:@"%@",self.course_video_lock_flag];
    _playerView.share_show_ms =[NSString stringWithFormat:@"%@",self.share_show_second]; ;
    _playerView.share_show_after_text = self.share_show_after_text;
    _playerView.self.course_video_points = self.self.course_video_points;
    _playerView.fileName = fileName;
    _playerView.saveKey = saveKey;
    _playerView.whereFrom = self.fromWhere;
    _playerView.shareBen = self.shareInfoDic;
    _playerView.time_limit_flag = [NSString stringWithFormat:@"%@",self.time_limit_flag];
    _playerView.videoId = [NSString stringWithFormat:@"%@",self.videoId];
    
    
    [_playerView playVideo];
    if ([self.fromWhere isEqualToString:@"Home"]) {
        
    }else {
        [_playerView seekToPlayTime:strTime];
    }
    
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
        [self back];
    }];
    //播放完成回调
    [_playerView endPlay:^{
        //销毁播放器
        [self back];
        NSLog(@"播放完成");
    }];
    
    //触发购买弹框时的通知
    
    //取消购买时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"CloseVideoViewNotification" object:nil];
    
    //点击购买按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toPurchaseVideo) name:@"PurchaseVideoNotification" object:nil];
}

- (void)setNewOrientation:(BOOL)fullscreen{
    if (fullscreen) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }else{
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

- (void)searchProgress {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    NSString *documents = [array objectAtIndex:0];
    
    fileName = [documents stringByAppendingPathComponent:@"setup.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
    saveKey = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%@",@"123"],self.VideoType,self.liveUrl];
    if (dict) {
        strTime = dict[saveKey];
    }
    
}

- (void)back{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isRotation = NO;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark -- 购买视频
- (void)toPurchaseVideo {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isRotation = NO;
    
    TO_WEAK(self, weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        
//        TO_STRONG(weakSelf, strongSelf);
        if ([weakSelf.fromWhere isEqualToString:@"Home"]) {
           //视频来源来自首页，判断是否登录
           
        }else {
            
            if (weakSelf.showPurchaseViewBlock) {
                weakSelf.showPurchaseViewBlock();
            }
        }
        
    }];
}

#pragma mark -- 试看弹出购买提示时点击取消
- (void)closeView {
    [self back];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [_playerView destroyPlayer];
    _playerView = nil;
}

- (void)dealloc {
    [_playerView destroyPlayer];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
