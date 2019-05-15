//
//  BaseView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/5.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"
#import "RefreshView.h"

@interface BaseView ()

@property (strong,nonatomic) RefreshView *loadingView;

@end


@implementation BaseView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"%@----hitTest:", [self class]);
//    // 如果控件不允许与用户交互那么返回 nil
//    if (self.userInteractionEnabled == NO || self.alpha <= 0.01 || self.hidden == YES) {
//        return nil;
//    }
//    // 如果这个点不在当前控件中那么返回 nil
//    if (![self pointInside:point withEvent:event]) {
//        return nil;
//    }
//    // 从后向前遍历每一个子控件
//    for (int i = (int)self.subviews.count - 1; i >= 0; i--) {
//        // 获取一个子控件
//        UIView *lastVw = self.subviews[i];
//        // 把当前触摸点坐标转换为相对于子控件的触摸点坐标
//        CGPoint subPoint = [self convertPoint:point toView:lastVw];
//        // 判断是否在子控件中找到了更合适的子控件
//        UIView *nextVw = [lastVw hitTest:subPoint withEvent:event];
//        // 如果找到了返回
//        if (nextVw) {
//            return nextVw;
//        }
//    }
//    // 如果以上都没有执行 return, 那么返回自己(表示子控件中没有"更合适"的了)
//    return  self;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 将字典装换成字符串 用于签名
- (NSString *)dictToStr:(NSDictionary *)dict
{
NSMutableString * signOriginalStrTemp = [[self dictionaryToJson:dict] mutableCopy];
// 去掉空格和换行
NSArray  * arr = [signOriginalStrTemp componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n ()\\"]];
    NSString * signOriginalStr = [arr componentsJoinedByString:@""];
    
    return signOriginalStr;
    
}

//字典转JSON字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
//    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


/**
 *  开始动画
 *
 */
- (void)startLoadingAnimation {
    [self.loadingView showView:self];
}

/**
 *  结束动画
 */
- (void)stopLoadingAnimation {
    [self.loadingView dismissView];
}

/**
 *  动画超时block处理
 */
- (void)loadingAnimationTimeOutHandle:(void (^)(void))block {
    
    self.RefreshDataBlock = block;
    TO_WEAK(self, weakSelf);
    [self.loadingView timeOutHandle:^{
        if (weakSelf.RefreshDataBlock) {
            weakSelf.RefreshDataBlock();
        }
    }];
}

- (RefreshView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[RefreshView alloc] initLoadingView];
    }
    
    return _loadingView;
}

@end
