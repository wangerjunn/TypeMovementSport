//
//  EmptyView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

@property (nonatomic, strong) UIImageView *placeholderImageView;

- (instancetype)initEmptyViewByFrame:(CGRect)frame
                    placeholderImage:(id)placeholderImage
                     placeholderText:(NSString *)placeholderText;

@end
