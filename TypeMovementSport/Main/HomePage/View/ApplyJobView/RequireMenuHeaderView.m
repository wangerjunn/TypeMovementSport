//
//  RequireMenuHeaderView.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "RequireMenuHeaderView.h"
#import "ParamFile.h"

@implementation RequireMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(14)];
        _titleLabel.frame = CGRectMake(15, 0, self.width/2.0, self.height);
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    
    return self;
}

@end
