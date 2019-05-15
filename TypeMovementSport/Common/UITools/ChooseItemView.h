//
//  ChooseResumeItemView.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/29.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface ChooseItemView : BaseView

@property (nonatomic, copy) void (^seleBlock)(NSString *seleCon);


/**
 简历信息编辑view
 
 @param viewTitle 当前页面标题
 @param conArr 包含字符串的选项数组
 @param seleContent 已选择的内容，isMultiple为YES时多选，内容以‘,’分割
 @param isMutiple 是否多选
 @param block 选中block
 @return self
 */
- (instancetype)initCityMenuViewByViewTitle:(NSString *)viewTitle
                                    arr:(NSArray <NSString*> *)conArr
                            seleContent:(NSString *)seleContent
                                 isMultiple:(BOOL)isMutiple
                              seleBlock:(void (^)(NSString *seleCon))block;

- (void)show;

@end
