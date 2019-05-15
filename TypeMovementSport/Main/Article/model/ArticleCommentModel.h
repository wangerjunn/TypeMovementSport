//
//  ArticleCommentModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleCommentModel : BaseModel
/*
 "id": 21,
 "userId": 2,
 "name": "Pisces Mrs.",
 "headImg": "http://img.51gosports.com/upload/201810/23/2/1540259283974.png",
 "dateCreated": 1540782135177,
 "content": "We Will Wait",
 "parentName": null,
 "parentHeadImg": null,
 "count": 0,
 "sonList": [],
 "tips": {
         "userId": "评论用户id",
         "name": "评论用户的名称",
         "headImg": "评论用户的头像",
         "dateCreated": "创建时间戳",
         "content": "评论内容",
         "parentName": "评论的父级的用户的名称",
         "parentHeadImg": "评论的父级的用户的头像",
         "root": "评论根节点",
         "list": "所有评论这个评论的集合,按时间顺序排序",
         "count": "评论下的评论总数",
         "sonList": "评论下的评论"
 }
 */

@property (nonatomic, assign) NSInteger id;//评论id
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *headImg;//头像
@property (nonatomic, copy) NSString *content;//评论内容
@property (nonatomic, copy) NSString *dateCreated;//创建时间
@property (nonatomic, copy) NSString *parentName;//上级评论名称
@property (nonatomic, copy) NSString *parentHeadImg;//上级评论头像
@property (nonatomic, assign) NSInteger count;//评论数
@property (nonatomic, copy) NSArray *sonList;//评论列表
@property (nonatomic, copy) NSDictionary *tips;//提示信息

@property (nonatomic, assign) BOOL isHidenTotalView;//隐藏共几条回复view
@property (nonatomic, assign) CGFloat contentHeight;

@end
