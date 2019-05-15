//
//  ArticleListModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/10/31.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleListModel : BaseModel

/*
 "id": 1,
 "name": "今日",
 "img": "0",
 "remark": "今日今日",
 "content": "今日今日今日今日今日今日今日今日今日今日",
 "dateCreated": 0,
 "commentCount": 6,
 "collectionCount": 0,
 "isCollection": false,
 "tips": {
     "name": "文章标题",
     "isCollection": "是否关注",
     "commentCount": "评论数量",
     "collectionCount": "收藏数量"
 }
 */
@property (nonatomic, assign) NSInteger id;//频道id
@property (nonatomic, copy) NSString *name;//文章名称
@property (nonatomic, copy) NSString *img;//文章图标
@property (nonatomic, copy) NSString *remark;//文章标题
@property (nonatomic, copy) NSString *content;//文章内容
@property (nonatomic, copy) NSString *dateCreated;//创建时间
@property (nonatomic, copy) NSString *shareUrl;//内容链接
@property (nonatomic, assign) NSInteger commentCount;//评论次数
@property (nonatomic, assign) NSInteger collectionCount;//收藏次数
@property (nonatomic, assign) BOOL isCollection;//是否收藏
@property (nonatomic, copy) NSDictionary *tips;//提示信息


/**
 获取文章列表数据 | 文章详情 | 关注|取消关注

 @param para 参数信息
 @param viewController viewController
 @param result 回调
 */
//+ (void)getArticleListByPara:(NSDictionary *)para
//                         url:(NSString *)url
//              viewController:(UIViewController *)viewController
//                      result:(void(^)(NSDictionary *data, NSError *error))result;
@end
