//
//  CustomAlertView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/10/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface CustomAlertView : BaseView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

/**
 点击按钮block，index从左至右从0到1
 */
@property (nonatomic, copy) void (^ClickButtonBlock)(NSInteger index);

//- (void)show;

+ (instancetype)shareCustomAlertView;

/**
 初始化弹框view
 
 @param title viewtitle
 @param content 显示内容
 @param leftBtnTitle 左侧按钮标题 可为nil，默认显示‘取消’
 @param rightBtnTitle 右侧按钮标题 可为nil，默认显示‘确定’
 @param buttonBlock 点击button回调
 */
- (void)showTitle:(NSString *)title
                 content:(NSString *)content
     leftButtonTitle:(NSString *)leftBtnTitle
  rightButtonTitle:(NSString *)rightBtnTitle
                    block:(void (^)(NSInteger index))buttonBlock;


/**
 单个按钮

 @param title viewtitle
 @param content 显示内容
 @param btnTitle 按钮标题 可为nil，默认显示‘确定'
 @param buttonBlock 点击button回调
 */
- (void)showTitle:(NSString *)title
                 content:(NSString *)content
           buttonTitle:(NSString *)btnTitle
                    block:(void (^)(NSInteger index))buttonBlock;

@end
