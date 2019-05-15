//
//  BoldNavigationTitleView.m
//  TypeMovementSport
//
//  Created by XDH on 2019/3/16.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BoldNavigationTitleView.h"

@implementation BoldNavigationTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initBoldNavigationTitleView:(NSString *)title boldPart:(NSString *)boldPartContent {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLaebl = [LabelTool createLableWithTextColor:k46Color font:[UIFont fontWithName:@"DINCondensed-Bold" size: 18]];
        CGFloat coorX = 0;
        titleLaebl.frame = CGRectMake(coorX, 0, self.width-coorX*2, 35);
        titleLaebl.text = title;
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:titleLaebl.text];
        
        if (boldPartContent != nil) {
            NSRange range = [title rangeOfString:boldPartContent];
            [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size: 30] range:range];
        }else {
            [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size: 30] range:NSMakeRange(0, titleLaebl.text.length)];
        }
        
        titleLaebl.attributedText = attri;
        [self addSubview:titleLaebl];
    }
    
    return self;
}
@end
