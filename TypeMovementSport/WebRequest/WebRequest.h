//
//  WebRequest.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WebChangeCanReachable2NotReachable @"WebChangeCanReachable2NotReachable"
#define WebChangeNotReachable2CanReachable @"WebChangeNotReachable2CanReachable"


@interface WebMonitors : NSObject

+ (BOOL)webIsOK:(NSError **)error;

//检测web能否正常访问 能正常访问， 则返回yes 否则no
- (BOOL)webIsOK:(NSError **)error;

+ (WebMonitors *)share;

@end

@interface WebRequest : NSObject

typedef void(^DownloadSuccessBlock)(NSDictionary *dict,NSString *remindMsg);
typedef void(^DownloadFailedBlock)(NSError *error);


+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock;

+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock;

+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict photoArr:(NSArray *)photoArr viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock;

@end
