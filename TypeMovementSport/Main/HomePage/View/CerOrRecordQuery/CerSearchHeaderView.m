//
//  CerSearchHeaderView.m
//  HRMP
//
//  Created by Mac on 2018/5/17.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import "CerSearchHeaderView.h"
@interface CerSearchHeaderView ()
@end
@implementation CerSearchHeaderView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UIButton class]]) {
        return view;
    }
    return nil;
}
@end
