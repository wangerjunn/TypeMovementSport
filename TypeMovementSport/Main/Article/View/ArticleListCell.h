//
//  ArticleListCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"

@interface ArticleListCell : UITableViewCell

/**展示图片*/
@property (nonatomic, strong) UIImageView *shouImg;
/**浏览图片*/
@property (nonatomic, strong) UIImageView *commentImg;
/**关注图片*/
@property (nonatomic, strong) UIImageView *focusOnImg;
/**试题标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**详解*/
@property (nonatomic, strong) UILabel *breakLabel;
/**评论数*/
@property (nonatomic, strong) UILabel *commentCountLabel;
/**收藏数*/
@property (nonatomic, strong) UILabel *collectionCountLabel;
/**判断是否是首页*/
@property (nonatomic, strong) NSString *FROME;
- (void)layoutSubviews;

@property (nonatomic, strong) ArticleListModel *model;

@end
