
#import "RefreshView.h"

@interface RefreshView ()

@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation RefreshView


- (instancetype)initLoadingView {
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.centerImageView];
        
        NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"lanqiu_color.png"],[UIImage imageNamed:@"lanqiu_color.png"],[UIImage imageNamed:@"lanqiu_color.png"],[UIImage imageNamed:@"lanqiu_color.png"],[UIImage imageNamed:@"lanqiu_color.png"],[UIImage imageNamed:@"lanqiu_color.png"],[UIImage imageNamed:@"lanqiu_color.png"],[UIImage imageNamed:@"lanqiu_color.png"], nil];
//        i = arc4random()%8;
        
        _centerImageView.image = [imageArray objectAtIndex:0];
        
        _centerImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 110);
        
        [self showLoadingView];
    }
    
    return self;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    
    return _centerImageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 30)];
        _label.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 70);
    }
    
    return _label;
}

- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 40, 40);
        
        [_reloadButton addTarget:self action:@selector(onclickReload:) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        _reloadButton.center = CGPointMake(self.label.center.x, self.label.center.y+40);
        [_reloadButton.layer setBorderWidth:1];
        [_reloadButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_reloadButton.layer setCornerRadius:20];
    }
    
    return _reloadButton;
}

-(void)showView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
        self.backgroundColor = [UIColor whiteColor];
        [view addSubview:self];
    });
}

-(void)timeOutHandle:(void (^)(void))block{
    
    self.RefreshDataBlock = block;
    
    [self addSubview:self.label];
    _label.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 - 70);
    _label.textColor = [UIColor grayColor];
    _label.text = @"网络不太好哦，刷新来看看";
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.reloadButton];
    _reloadButton.hidden = NO;
    [_centerImageView.layer removeAllAnimations];
    
}

-(void)onclickReload:(id)sender{
    _label.text = @"";
    [_centerImageView setHidden:NO];
    [self showLoadingView];
    _reloadButton.hidden = YES;
    if (self.RefreshDataBlock) {
        self.RefreshDataBlock();
    }
}

-(void)dismissView{
    TO_WEAK(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(),^{
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf removeFromSuperview];
    });
}

- (void)showLoadingView {
    CABasicAnimation * rotationAnimation;rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI *2.0];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    [_centerImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

-(void)dealloc{
}

+ (void)dismissWithErrorView{
    
}


@end





