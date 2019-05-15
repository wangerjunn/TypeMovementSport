//
//  RequireMenuCollectionViewCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "RequireMenuCollectionViewCell.h"
#import "ParamFile.h"

@implementation RequireMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _label = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_14)];
        _label.layer.borderColor = k210Color.CGColor;
        _label.layer.borderWidth = 1;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.cornerRadius = 4;
        [self.contentView addSubview:_label];
    }
    
    return self;
}

//- (void)setContent:(NSString *)content size:(NSString *)sizeStr {
//
//    CGSize size = CGSizeFromString(sizeStr);
//
//    _content = content;
//    _label.text = content;
//
//    _label.frame = CGRectMake(0, 2, size.width, size.height-4);
//
//}

- (void)layoutSubviews {
    [super layoutSubviews];

    _label.frame = CGRectMake(0, 2, self.width, self.height-4);
}

@end
