
#import <UIKit/UIKit.h>

@interface RefreshView : UIView

- (instancetype)initLoadingView;
-(void)showView:(UIView *)view;
-(void)timeOutHandle:(void (^)(void))block;
-(void)dismissView;
- (void)showLoadingView;
@property (nonatomic, copy) void (^RefreshDataBlock)(void);

@end
