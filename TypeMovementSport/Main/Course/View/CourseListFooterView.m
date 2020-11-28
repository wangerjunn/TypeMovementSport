//
//  CourseListFooterView.m
//  TypeMovementSport
//
//  Created by xslpiOS on 2020/11/28.
//  Copyright © 2020 小二郎. All rights reserved.
//

#import "CourseListFooterView.h"

@interface CourseListFooterView ()

@property (nonatomic, strong) UILabel *conLabel;

@end

@implementation CourseListFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.conLabel];
        
        [self.conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@25);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(@15);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    
    return self;
}


- (void)setText:(NSString *)text {
    self.conLabel.text = text;
}
- (UILabel *)conLabel {
    if (!_conLabel) {
        _conLabel = [[UILabel alloc] init];
        _conLabel.numberOfLines = 0;
        _conLabel.font = [UIFont systemFontOfSize:14];
        _conLabel.textColor = [UIColor lightGrayColor];
    }
    
    return _conLabel;
}

@end
