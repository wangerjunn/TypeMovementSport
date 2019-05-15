//
//  BaseViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "UITool.h"
#import "RefreshView.h"

@interface BaseViewController ()
@property (strong,nonatomic) UILabel * titleLable;
@property (strong,nonatomic) RefreshView *loadingView;
@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    UIImageView *line = [UITool findHairlineImageViewUnder:self.navigationController.view];
    
    line.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIImageView *line = [UITool findHairlineImageViewUnder:self.navigationController.view];
    
    line.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationItem.rightBarButtonItem
    self.view.backgroundColor = [UIColor whiteColor];
    // 默认是现实返回箭头
    [self setBackItem:@"general_back" AndTitleColor:[UIColor blackColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavBarColor:[UIColor whiteColor]];
}

/**设置返回按钮*/
- (void)setBackItem:(NSString *)imageName AndTitleColor:(UIColor *)color {
    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
    pop.frame = CGRectMake(0, 40, 40, 40); //10.5, 19
    [pop addTarget: self action: @selector(goBack) forControlEvents: UIControlEventTouchUpInside];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, pop.height)];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = @"";
//    label.textColor = color;
//    label.font = [UIFont systemFontOfSize:16];
//    [pop addSubview:label];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    UIImage *image = [UIImage imageNamed:imageName];
    icon.image = image?image:[UIImage imageNamed:@"general_back"];
    [pop addSubview:icon];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:pop];
    self.navigationItem.leftBarButtonItem = item;
}

/**设置导航栏图片按钮*/
- (void)setNavItemWithImage:(NSString *)imageName
            imageHightLight:(NSString *)hightLight
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action {
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStylePlain) target:target action:action];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barItem;
    }else
        self.navigationItem.rightBarButtonItem = barItem;
}

/**设置导航栏文字按钮*/
- (void)setNavItemWithTitle:(NSString *)title
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action{
    UIBarButtonItem * titleBar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
//    titleBar.tintColor = [UIColor blackColor];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = titleBar;
    } else{
        self.navigationItem.rightBarButtonItem = titleBar;
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                     NSForegroundColorAttributeName : k52Color,
                                                                     NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:14]
                                                                     } forState:UIControlStateNormal];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                     NSForegroundColorAttributeName : k52Color,
                                                                     NSFontAttributeName : Font(14)
                                                                     } forState:UIControlStateSelected];
}

/**设置导航栏按钮标题*/
- (void)setNavItemWithTitle:(NSString *)title isLeft:(BOOL)isLeft {
    UIBarButtonItem * titleBar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(emptyMethd)];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = titleBar;
    }else
        self.navigationItem.rightBarButtonItem = titleBar;
}

- (void)emptyMethd{
}

/**设置当前页标题*/
- (void)setMyTitle:(NSString *)title {
    [self setMyTitle:title color:k46Color];
}

/**设置当前页标题 设置颜色*/
- (void)setMyTitle:(NSString *)title color:(UIColor *)color {
    [self configTitleView];
    self.titleLable.text = title;
    self.titleLable.textColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if (color != [UIColor blackColor])
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    else
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)configTitleView
{
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
    self.titleLable.font = [UIFont fontWithName:@"DINCondensed-Bold" size: 18];
    
    self.titleLable.numberOfLines = 2;
    self.titleLable.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLable;
}
    
/**返回键,子类不重写默认返回上一页*/
- (void)goBack {
    if (self.backViewController) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        for (UIViewController *vc in viewControllers) {
            if ([vc isMemberOfClass:self.backViewController.class]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/**隐藏返回按钮*/
- (void)hiddenBackBtn {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.hidesBackButton = YES;
}

/**显示返回按钮*/
- (void)showBackBtn {
    [self setBackItem:@"返回" AndTitleColor:[UIColor blackColor]];
}

/**设置导航栏的颜色*/
- (void)setNavBarColor:(UIColor *)color {
    [self.navigationController.navigationBar setBackgroundImage:[ImageTool createImageWithColor:color size:CGSizeMake(kScreenWidth, kNavigationBarHeight)] forBarMetrics:(UIBarMetricsDefault)];
}

//滑动返回页面
- (void)openSlideBack {
    //开启滑动返回手势和效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

//关闭滑动返回
- (void)closeSlideBack {
    //开启滑动返回手势和效果
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
/**
 *  开始动画
 *
 */
- (void)startLoadingAnimation {    
    [self.loadingView showView:self.view];
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

//隐藏键盘
- (void)hiddenKeyBoard {
    [self.view endEditing:YES];
}

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
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)dealloc{
    debugMethod();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
