//
//  CourseViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/5.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "CourseViewController.h"
#import "HomeViewController.h"

//view
#import "Course_theoryView.h"//国职理论view
#import "Course_actOpeSubView.h"
#import "Course_increaseVideoSubView.h"
#import "BoldNavigationTitleView.h"

#import "OrderPayViewController.h"

//model
#import "QuestionModel.h"

@interface CourseViewController () <UIScrollViewDelegate> {
    NSMutableArray *videoTypeArr;
    UIView *_topBtnLine;
    UIView *_topBtnView;
    NSInteger _curSeleIndex;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) Course_theoryView *theoryView;//理论
@property (nonatomic, strong) Course_actOpeSubView *actualOperationView;//实操
@property (nonatomic, strong) Course_increaseVideoSubView *increaseVideoView;//增值view
@property (nonatomic, assign) BOOL isFromHomePage;//来自首页
@property (nonatomic, assign) CourseVideoEnum curSeleVideoEnum;

@end

@implementation CourseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBarColor:[UIColor whiteColor]];
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)selectIndex:(CourseVideoEnum)videoEnum {
    
    _curSeleVideoEnum = videoEnum;
    UIButton *btn = (UIButton *)[_topBtnView viewWithTag:videoEnum+100];
    if (btn) {
        [self chooseCourseType:btn];
    }
}

# pragma mark -- 国职理论 | 国职实操 | 增值视频
- (void)chooseCourseType:(UIButton *)btn {
    
    if (btn.tag - 100 == _curSeleIndex) {
        return;
    }
    
    _curSeleIndex = btn.tag - 100;
    NSInteger index = self.mainScrollView.contentSize.width / kScreenWidth;
    for (int i = 0; i < index; i++) {
        UIButton *tmpBtn = (UIButton *)[_topBtnView viewWithTag:100+i];
        tmpBtn.selected = NO;
    }
    _topBtnLine.left = btn.left + 4;
    switch (btn.tag) {
        case 100:{
            if (_theoryView == nil) {
                [self.mainScrollView addSubview:self.theoryView];
            }
        }
            break;
        case 101:{
            if ( _actualOperationView == nil) {
                [self.mainScrollView addSubview:self.actualOperationView];
            }
        }
            break;
        case 102:{
            if (_increaseVideoView == nil) {
                [self.mainScrollView addSubview:self.increaseVideoView];
            }
        }
            break;
            
        default:
            break;
    }
    
    btn.selected = YES;
    [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth*(btn.tag-100), 0) animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenBackBtn];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers.firstObject isKindOfClass:[HomeViewController class]]) {
        _isFromHomePage = YES;
    }
    
    [self initData];
}

#pragma mark -- 初始化数据，必须登录时展示
- (void)initData {
    if (videoTypeArr == nil && [Tools isLoginAccount]) {
        videoTypeArr = [NSMutableArray array];
        
        [self startLoadingAnimation];
        [self getAllVideoType];
    }
}

- (void)createUI {
    
    _topBtnView = [self createTopBtnView];
    [self.view addSubview:_topBtnView];
    
    [self.view addSubview:self.mainScrollView];
    
    switch (_curSeleVideoEnum) {
        case Course_increaseVideo:{
            //进阶课程
            [self.mainScrollView addSubview:self.increaseVideoView];
            [self selectIndex:_curSeleVideoEnum];
        }
            break;
        case Course_actOpeVideo:{
            //国职实操
            [self.mainScrollView addSubview:self.actualOperationView];
            [self selectIndex:_curSeleVideoEnum];
        }
            break;
            
        default:
            
            //国职理论
             [self.mainScrollView addSubview:self.theoryView];
            break;
    }

}

//创建顶部按钮view
- (UIView *)createTopBtnView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    topView.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[BoldNavigationTitleView alloc] initBoldNavigationTitleView:@"Course 课程" boldPart:@"Course"];
    CGFloat coorX = 20;
    titleView.left = 10;
    [topView addSubview:titleView];
    
//    if (self.isFromHomePageIncreaseCourse || self.isFromHomePageCountryProfession) {
    if (self.isFromHomePage) {
        UIButton *cancelBtn = [ButtonTool createButtonWithImageName:@"general_cancel" addTarget:self action:@selector(goBack)];
        cancelBtn.frame = CGRectMake(topView.width - 20 - 15-10, titleView.top, 15+10, 15+10);
        [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [topView addSubview:cancelBtn];
    }
    
//    if (!self.isFromHomePageIncreaseCourse) {
        NSArray *titles = @[@"国职理论",@"国职实操",@"进阶课程"];
//        if (self.isFromHomePageCountryProfession) {
//            titles = @[@"国职理论",@"国职实操"];
//        }
        CGFloat wdtBtn = [UITool sizeOfStr:titles.firstObject andFont:Font(13) andMaxSize:CGSizeMake(kScreenWidth, 100) andLineBreakMode:NSLineBreakByCharWrapping].width;
        CGFloat coorX_btn = coorX;
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [ButtonTool createButtonWithTitle:titles[i]
                                                   titleColor:k46Color
                                                    titleFont:Font(13)
                                                    addTarget:self
                                                       action:@selector(chooseCourseType:)];
            
            btn.tag = 100+i;
            [btn setTitleColor:kOrangeColor forState:UIControlStateSelected];
            if (i == 0) {
                _curSeleIndex = i;
                btn.selected = YES;
            }
            
            btn.frame = CGRectMake(coorX_btn, titleView.bottom+20, wdtBtn, 20);
            [topView addSubview:btn];
            
            coorX_btn += wdtBtn + 25;
        }
        
        _topBtnLine = [[UIView alloc] initWithFrame:CGRectMake(coorX+4, titleView.bottom+20+20, wdtBtn-8, 3)];
        _topBtnLine.backgroundColor = kOrangeColor;
        [topView addSubview:_topBtnLine];
//    }
//else {
//        topView.height =  60;
//    }

    return topView;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _topBtnView.bottom, kScreenWidth, kScreenHeight-kNavigationBarHeight - _topBtnView.bottom - (_isFromHomePage ? 0 : kTabBarHeight))];
//        if (self.isFromHomePageCountryProfession) {
//            _mainScrollView.height = kScreenHeight - kNavigationBarHeight - _topBtnView.bottom;
//            //首页国职
//            [_mainScrollView setContentSize:CGSizeMake(kScreenWidth * 2, _mainScrollView.height)];
//        }else if (self.isFromHomePageIncreaseCourse) {
//            _mainScrollView.height = kScreenHeight - kNavigationBarHeight  - _topBtnView.bottom;
//            //首页进阶
//            [_mainScrollView setContentSize:CGSizeMake(kScreenWidth, _mainScrollView.height)];
//        }else {
            [_mainScrollView setContentSize:CGSizeMake(kScreenWidth * 3, _mainScrollView.height)];
//        }
        
        
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainScrollView;
}

//国职理论
- (Course_theoryView *)theoryView {
    if (!_theoryView) {
        QuestionModel *model;
        if (videoTypeArr.count > 0) {
            model = videoTypeArr.firstObject;
        }
        
        _theoryView = [[Course_theoryView alloc]initWithFrame:CGRectMake(0, 0, self.mainScrollView.width, self.mainScrollView.height) videoTypeId:model?model.id:0];
    }
    
    return _theoryView;
}

//国职实操
- (Course_actOpeSubView *)actualOperationView {
    if (!_actualOperationView) {
        
        QuestionModel *model;
        if (videoTypeArr.count > 1) {
            model = videoTypeArr[1];
        }
        _actualOperationView = [[Course_actOpeSubView alloc]initWithFrame:CGRectMake(self.mainScrollView.width, 0, self.mainScrollView.width, self.mainScrollView.height) videoTypeId:model?model.id:0];
    }
    
    return _actualOperationView;
}

//增值视频
- (Course_increaseVideoSubView *)increaseVideoView {
    if (!_increaseVideoView) {
        QuestionModel *model;
        if (videoTypeArr.count > 2) {
            model = videoTypeArr.lastObject;
        }
        
        CGFloat coorX = self.mainScrollView.width *2;
//        if (self.isFromHomePageIncreaseCourse) {
//            coorX = 0;
//        }
        _increaseVideoView = [[Course_increaseVideoSubView alloc]initWithFrame:CGRectMake(coorX, 0, self.mainScrollView.width, self.mainScrollView.height) videoTypeId:model?model.id:0];
    }
    
    return _increaseVideoView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = _mainScrollView.contentOffset.x / kScreenWidth;
    UIButton *btn = (UIButton *)[_topBtnView viewWithTag:index+100];
    [self chooseCourseType:btn];
}

#pragma mark -- 获取视频类型 国职理论 | 国职实操 | 增值视频
- (void)getAllVideoType {
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kClassesFindAllByRoot parms:@{@"type":@"VIDEO"} viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            
            for (NSDictionary *tmp in list) {
                QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->videoTypeArr addObject:model];
            }
            
            [weakSelf createUI];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        [weakSelf loadingAnimationTimeOutHandle:^{
            [weakSelf getAllVideoType];
        }];
    }];
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
