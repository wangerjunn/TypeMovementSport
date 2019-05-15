//
//  ArticleCommentView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleCommentView.h"

@interface ArticleCommentView () <UITextViewDelegate> {
    NSString *_viewTitle;
    UIView *bgView;
    UIView *conView;
    UITextView *commentTextView;
    
    UILabel *placeholderLabel;//输入框占位label
}

@end;

@implementation ArticleCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initArticleCommentViewByViewTitle:(NSString *)viewTitle
                                            block:(void (^)(NSString *commentContent))block {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        self.commentBlock = block;
        _viewTitle = viewTitle;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self addSubview:bgView];
    
    CGFloat coorX = FIT_SCREEN_WIDTH(26);
    CGFloat hgt = kScreenWidth - coorX*2;
    conView = [[UIView alloc] initWithFrame:CGRectMake(coorX, self.height/2.0-90, hgt, 180)];
    conView.backgroundColor = [UIColor whiteColor];
    [conView setCornerRadius:5];
    [self addSubview:conView];
    
    UILabel *titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_16)];
    titleLabel.frame = CGRectMake(15, 10, conView.width-30, 20);
    titleLabel.text = @"评论";
    if (_viewTitle) {
        titleLabel.text = _viewTitle;
    }
    [conView addSubview:titleLabel];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+5, titleLabel.width, conView.height - 50 - titleLabel.bottom - 10)];
    commentTextView.font = Font(K_TEXT_FONT_14);
    commentTextView.maxCharLength = 100;
    commentTextView.delegate = self;
    commentTextView.layer.borderColor = k46Color.CGColor;
    commentTextView.layer.borderWidth = 1;
    commentTextView.layer.cornerRadius = 2;
//    [commentTextView setCornerRadius:2];
//    commentTextView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [conView addSubview:commentTextView];
    
    placeholderLabel = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_14)];
    placeholderLabel.text = [NSString stringWithFormat:@"说点什么"];
    placeholderLabel.numberOfLines = 0;
    [placeholderLabel sizeToFit];
    
    placeholderLabel.frame = CGRectMake(5, 7.5, placeholderLabel.width, placeholderLabel.height);
    [commentTextView addSubview:placeholderLabel];
//    [commentTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    UIButton *rightButton = [ButtonTool createButtonWithTitle:@"确定"
                                          titleColor:kOrangeColor
                                           titleFont:Font(15)
                                           addTarget:self
                                              action:@selector(clickButtonAction:)];
    rightButton.tag = 2;
    rightButton.frame = CGRectMake(commentTextView.right - 50, conView.height - 50, 50, 44);
    [conView addSubview:rightButton];
    
    UIButton *leftButton = [ButtonTool createButtonWithTitle:@"取消"
                                                  titleColor:k46Color
                                                   titleFont:Font(15)
                                                   addTarget:self
                                                      action:@selector(clickButtonAction:)];
    leftButton.tag = 1;
    leftButton.frame = CGRectMake(rightButton.left - rightButton.width-40,
                                  rightButton.top, rightButton.width, rightButton.height);
    [conView addSubview:leftButton];
    
    [conView openAdjustLayoutWithKeyboard];
}

- (void)clickButtonAction:(UIButton *)btn {
    if (btn.tag == 1) {
        //取消
        [self removeFromSuperview];
    }else{
        //确定
        if (commentTextView.text.length < 1) {
            return;
        }
        if (self.commentBlock) {
            self.commentBlock(commentTextView.text);
        }
        [self removeFromSuperview];
    }
    
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        
        UIWindow * window=[UIApplication sharedApplication].keyWindow;
        
        [window addSubview:self];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    placeholderLabel.hidden = !(textView.text.length == 0);
}

@end
