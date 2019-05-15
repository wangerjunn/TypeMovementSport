//
//  QuestionListView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface QuestionListView : BaseView

@property (nonatomic, copy) void (^IsShowPurchaseIconBlock)(BOOL isShow);
@property (nonatomic, copy) void (^ClickPurchaseBlock)(void);
@property (nonatomic, assign) BOOL isPurchase;

- (instancetype)initQuestionListViewById:(NSInteger)questionId frame:(CGRect)frame;


@end
