
//
//  EmptyView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView () {
    NSString *_placeholderText;
    id _placeholderImage;
}

@end
@implementation EmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initEmptyViewByFrame:(CGRect)frame placeholderImage:(id)placeholderImage placeholderText:(NSString *)placeholderText {
    
    if (self = [super initWithFrame:frame]) {
        _placeholderText = placeholderText;
        _placeholderImage = placeholderImage;
        
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    self.placeholderImageView = [[UIImageView alloc] init];
    
    CGFloat wdtImage = 0;
    CGFloat hgtImage = 0;
    if (_placeholderImage) {
        if ([_placeholderImage isMemberOfClass:NSString.class]) {
            self.placeholderImageView.image = [UIImage imageNamed:_placeholderImage];
        }else if ([_placeholderImage isMemberOfClass:UIImage.class]) {
            self.placeholderImageView.image = _placeholderImage;
        }
        
        wdtImage = self.placeholderImageView.image.size.width;
        hgtImage = self.placeholderImageView.image.size.height;
        
        if ( self.width < wdtImage) {
            hgtImage = hgtImage * (self.width / wdtImage);
            wdtImage = self.width;
        }
        
    }else {
        self.placeholderImageView.image = [UIImage imageNamed:@"general_empty.png"];
        wdtImage = 238/2.0;
        hgtImage = 213/2.0;
    }
    
    [self addSubview:self.placeholderImageView];

    
    self.placeholderImageView.size = CGSizeMake(wdtImage, hgtImage);
    self.placeholderImageView.center = self.center;
    
    if (_placeholderText) {
        UILabel *tipsTextLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
        tipsTextLabel.numberOfLines = 0;
        tipsTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        tipsTextLabel.textAlignment = NSTextAlignmentCenter;
        tipsTextLabel.text = _placeholderText;
        
        [tipsTextLabel sizeToFit];
        
        tipsTextLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(20), self.placeholderImageView.bottom+20, self.width-40, tipsTextLabel.height);
        [self addSubview:tipsTextLabel];
    }
}

@end
