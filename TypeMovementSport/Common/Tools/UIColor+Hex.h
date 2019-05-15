//
//  UIColor+Hex.h
//  BeStudent_Teacher
//
//  Created by XDH on 16/8/17.
//  Copyright © 2016年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
- (NSString *)HEXString;

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
+ (CAGradientLayer *)setPayGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
+ (CAGradientLayer *)setExclusiveCardChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
@end
