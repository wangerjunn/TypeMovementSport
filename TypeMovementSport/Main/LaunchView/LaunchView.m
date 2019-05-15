//
//  LaunchView.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/29.
//  Copyright © 2019年 XDH. All rights reserved.
//

#define kLaunchImageKey @"launchImage"
#define kGetImagePath @"getImagePath"//获取图片路径

#import "LaunchView.h"

static LaunchView *launchView = nil;

@interface LaunchView ()

@property (nonatomic, strong) UIImageView *launchImageView;

@end


@implementation LaunchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)shareLaunchView {
    @synchronized (self) {
       static dispatch_once_t once;
        dispatch_once(&once, ^{
            launchView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
            //请求启动图片
            launchView.backgroundColor = [UIColor clearColor];
            launchView.contentMode = UIViewContentModeScaleAspectFill;
            dispatch_async(dispatch_get_main_queue(), ^{
                [launchView getLaunchImage];
            });
            
        });
    }
    
    return launchView;
}

- (UIImageView *)launchImageView {
    if (!_launchImageView) {
        _launchImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _launchImageView.backgroundColor = [UIColor whiteColor];
        NSString *filePath = [self getFilePathWithImageName:UserDefaultsGet(kLaunchImageKey)];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        _launchImageView.image = [UIImage imageWithData:data];
    }
    
    return _launchImageView;
}


- (void)show {
    if (UserDefaultsGet(kLaunchImageKey)) {
        //存在启动图片
        [self addSubview:self.launchImageView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        
        //延时执行
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.launchImageView.alpha = 0;
                
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                
            }];
        });
    }
    
}


/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self deleteOldImage];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setValue:imageUrl forKey:kGetImagePath];
            [userDefaults setValue:imageName forKey:kLaunchImageKey];
            [userDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imageName = [userDefaults valueForKey:kLaunchImageKey];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}



#pragma mark -- 获取启动动图
- (void)getLaunchImage {
    
    TO_WEAK(self, weakSelf);
    
    [WebRequest PostWithUrlString:kLaunchImage parms:nil viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg intValue] == 999) {
            NSArray *list = dict[@"list"];
            
            if (list.count > 0) {
                // 拼接沙盒路径
                NSString *imgPath = list.firstObject;
                if (UserDefaultsGet(kGetImagePath)) {
                    NSString *cacheImgPath = UserDefaultsGet(kGetImagePath);
                    if ([cacheImgPath isEqualToString:imgPath]) {
                        return;
                    }
                }
                [weakSelf downloadAdImageWithUrl:imgPath imageName:kLaunchImageKey];
            }
            
            /*
             list =     (
             "http://img.mm4000.com/file/1/a2/271ace1a71_800.jpg",
             "http://attachments.gfan.net.cn/forum/201804/06/185600bby96vduct9v6vyx.jpg",
             "http://img.kutoo8.com/upload/image/45191903/8_320x480.jpg"
             );
             */
        }
    } failed:^(NSError *error) {
        
    }];
}

@end
