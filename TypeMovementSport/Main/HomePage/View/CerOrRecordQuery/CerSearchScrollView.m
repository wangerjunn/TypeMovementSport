//
//  CerSearchScrollView.m
//  HRMP
//
//  Created by Mac on 2018/5/17.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import "CerSearchScrollView.h"

@implementation CerSearchScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view       = [super hitTest:point withEvent:event];
    BOOL hitHead       = point.y < (275 - self.offset.y);
    if (hitHead || !view) {
        self.scrollEnabled = NO;
        if (!view) {
            for (UIView* subView in self.subviews) {
                if (subView.frame.origin.x == self.contentOffset.x) {
                    view = subView;
                }
            }
        }
        return view;
    } else {
        self.scrollEnabled = YES;
        return view;
    }
}


@end
