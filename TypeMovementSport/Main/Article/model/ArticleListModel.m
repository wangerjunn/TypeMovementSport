//
//  ArticleListModel.m
//  TypeMovementSport
//
//  Created by XDH on 2018/10/31.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleListModel.h"

@implementation ArticleListModel

+ (void)getArticleListByPara:(NSDictionary *)para
                                             url:(NSString *)url
                       viewController:(UIViewController *)viewController
                                        result:(void (^)(NSDictionary *, NSError *))result {
    NSString *urlString = [kBaseUrl stringByAppendingString:url];
    [WebRequest PostWithUrlString:urlString parms:para viewControll:viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        if (result) {
            result(dict,nil);
        }
    } failed:^(NSError *error) {
        if (result) {
            result(nil,error);
        }
    }];
}

@end
