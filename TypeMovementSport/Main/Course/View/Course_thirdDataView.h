//
//  Course_thirdDataView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"
#import "VideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course_thirdDataView : BaseView
@property (nonatomic, copy) void (^seleBlock)(NSInteger seleIndex);//选择视频
@property (nonatomic, copy) void (^shareVideoBlock)(NSInteger seleIndex);//分享试看

/**
 简历信息编辑view
 
 @param viewTitle 当前页面标题
 @param conArr 包含字符串的选项数组
 @param block 选中block
 @return self
 */
- (instancetype)initViewByViewTitle:(NSString *)viewTitle
                                        arr:(NSArray *)conArr
                                  seleBlock:(void (^)(NSInteger seleIndex))block;

- (void)show;

- (void)dismissView;
@end

NS_ASSUME_NONNULL_END
