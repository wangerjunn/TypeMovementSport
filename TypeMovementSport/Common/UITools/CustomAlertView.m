//
//  CustomAlertView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/10/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "CustomAlertView.h"
#import "AppDelegate.h"

@interface CustomAlertView () {
    
    NSString *__leftButtonTitle;
    NSString *__rightButtonTitle;
    NSString *_viewTitle;
    NSString *_content;
}

@end

@implementation CustomAlertView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static CustomAlertView * _shareCustomAlertView = nil;
+ (CustomAlertView *)shareCustomAlertView{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //WithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight)
        _shareCustomAlertView = [[CustomAlertView alloc] init];
        _shareCustomAlertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    });
    
    return _shareCustomAlertView;
}

- (void)showTitle:(NSString *)title
          content:(NSString *)content
 buttonTitle:(NSString *)btnTitle
            block:(void (^)(NSInteger index))buttonBlock{
    
    
    [self removeSubviews];
    _viewTitle = title;
    _content = content;
   
    __rightButtonTitle = btnTitle;
    self.ClickButtonBlock = buttonBlock;
    
    [self createUI:YES];
}

- (void)showTitle:(NSString *)title
                content:(NSString *)content
        leftButtonTitle:(NSString *)_leftButtonTitle
       rightButtonTitle:(NSString *)_rightButtonTitle
                  block:(void (^)(NSInteger))buttonBlock {
    
    [self removeSubviews];
    _viewTitle = title;
    _content = content;
    __leftButtonTitle = _leftButtonTitle;
    __rightButtonTitle = _rightButtonTitle;
    self.ClickButtonBlock = buttonBlock;
    
    [self createUI:NO];
}

- (void)removeSubviews {
    UIView *bgView = (UIView *)[self viewWithTag:100];
    if (bgView) {
        [bgView removeFromSuperview];
        bgView = nil;
    }
    
    
}

- (void)createUI:(BOOL)isSingleBtn {
    
    
    //WithFrame:CGRectMake(35, kScreenHeight/2.0-78, kScreenWidth - 70, 156)
    UIView * bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(35);
        make.right.mas_equalTo(self).offset(-35);
//        make.height.mas_equalTo(156);
//        make.centerY.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
    [bgView setTag:100];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    
    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (appDelegate.isRotation) {
//        bgView.frame = CGRectMake((self.frame.size.width - self.frame.size.height + 70)/2.0 , kScreenHeight / 2 - 75, self.frame.size.height - 70, 156);
//    }
    
    _titleLabel = [LabelTool createLableWithTextColor:UIColorFromRGB(0x222222) font:Font(18)];
    [bgView addSubview:_titleLabel];
//    _titleLabel.frame = CGRectMake(15, 20, bgView.width - 30, 18);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = _viewTitle;
//    _titleLabel.backgroundColor = [UIColor yellowColor];
    if (_viewTitle.length < 1) {
        _titleLabel.text = @"温馨提示";
    }
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(bgView).offset(-15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(18);
    }];
    
    _contentLabel = [LabelTool createLableWithTextColor:UIColorFromRGB(0x222222) font:Font(15)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.text = _content;
//    _contentLabel.backgroundColor = [UIColor redColor];
     [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisVertical];
//    CGSize size = [UITool sizeOfStr:_content
//                            andFont:Font(15)
//                         andMaxSize:CGSizeMake(_titleLabel.width, 1000)
//                   andLineBreakMode:NSLineBreakByCharWrapping
//                          lineSpace:1];
    
//    _contentLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+15, _titleLabel.width, size.height);
    [bgView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_titleLabel);
        make.right.mas_equalTo(bgView).offset(-15);
        make.top.mas_equalTo(self->_titleLabel.mas_bottom).offset(15);
//        make.height.mas_equalTo(size.height);
    }];
    
    
    _rightButton = [ButtonTool createButtonWithTitle:__rightButtonTitle
                                               titleColor:k46Color
                                                titleFont:Font(15)
                                                addTarget:self
                                                   action:@selector(clickButtonAction:)];
    _rightButton.tag = 2;
    if (__rightButtonTitle.length < 1) {
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
    }
//    _rightButton.frame = CGRectMake(_leftButton.right + 10, _leftButton.top, _leftButton.width, _leftButton.height);
    [bgView addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_contentLabel.mas_right).offset(-50);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self->_contentLabel.mas_bottom).offset(20);
//        make.top.width.height.equalTo(self->_leftButton);
        make.bottom.equalTo(bgView).offset(-10);
    }];
    
    _leftButton = [ButtonTool createButtonWithTitle:__leftButtonTitle
                                         titleColor:k46Color
                                          titleFont:Font(15)
                                          addTarget:self
                                             action:@selector(clickButtonAction:)];
    _leftButton.tag = 1;
    if (__leftButtonTitle.length < 1) {
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    //    _leftButton.frame = CGRectMake(bgView.width - 140, _contentLabel.bottom+20, 50, 44);
    [bgView addSubview:_leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_rightButton.mas_left).offset(-60);
        make.top.width.height.equalTo(self->_rightButton);
//        make.top.mas_equalTo(self->_contentLabel.mas_top).offset(20+size.height);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(44);
    }];
    
//    CGFloat bgHgt = _rightButton.bottom + 5;
//    bgView.frame = CGRectMake(bgView.left, self.height/2.0 - bgHgt/2.0, bgView.width, bgHgt);
    
    //单项按钮
    if (isSingleBtn) {
        _leftButton.hidden = YES;
        [_rightButton setTitleColor:kOrangeColor forState:UIControlStateNormal];
    }
    
    [self show];
}

- (void)clickButtonAction:(UIButton *)btn {
    
    if (self.ClickButtonBlock) {
        self.ClickButtonBlock(btn.tag-1);
    }
    if (btn.tag == 1) {
        //左侧按钮，默认取消
    }else{
        //右侧按钮，默认确定
    }
    
    [self removeSelf];
}

- (void)removeSelf {
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.3 animations:^{

        [weakSelf removeFromSuperview];
        
    } completion:^(BOOL finished) {

    }];
}

- (void)show {
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:_shareCustomAlertView];
    
    [_shareCustomAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(appDelegate.window);
    }];
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        [appDelegate.window addSubview:weakSelf];
    } completion:^(BOOL finished) {
        
    }];
}

@end
