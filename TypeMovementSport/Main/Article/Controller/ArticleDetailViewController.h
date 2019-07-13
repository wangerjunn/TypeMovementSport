//
//  ArticleDetailViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"

@interface ArticleDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) NSInteger articleId;//文章id
@property (nonatomic, copy) void (^articleCollectionResultBlock)(void);

@end
