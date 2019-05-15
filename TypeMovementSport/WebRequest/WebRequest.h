//
//  WebRequest.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebRequest : NSObject

typedef void(^DownloadSuccessBlock)(NSDictionary *dict,NSString *remindMsg);
typedef void(^DownloadFailedBlock)(NSError *error);


+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock;

+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock;

+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict photoArr:(NSArray *)photoArr viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock;

@end
