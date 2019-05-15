//
//  GetExamResultViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "GetExamResultViewController.h"
#import "QuestionListViewController.h"
#import "ReviewQuestionViewController.h"
#import "AnswerListViewController.h"

//view
#import "ShareView.h"
#import "ZZGradientProgress.h"
#import "UIColor+Hex.h"

@interface GetExamResultViewController () {
    
    UIScrollView *mainView;
    UIView *bgView;
    UIImageView *resultImg;
    UILabel *resultLab;
    UIImageView *BgImg;
    UILabel *resultTitLab;//题库title
    ZZGradientProgress *circle2;
    ZZGradientProgress *circle;
    UILabel *TimeLab;//时间标题
    UILabel *sumScoreLabel;//考试分数
    UILabel *sumScoreTitleLabel;//标题
    UILabel *timeConLaebl;//考试用时时长
    
    UIImageView *testReview;//考题回顾
    UIImageView *closeImg;//关闭
    int minutes;
    int seconds;
}
@end

@implementation GetExamResultViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}


- (void)createUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    mainView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor whiteColor];
    bgView = [[UIView alloc] initWithFrame:
              CGRectMake(0, 0, kScreenWidth, kScreenHeight * 2 / 3 )];
    [mainView addSubview:bgView];
    [self.view addSubview:mainView];
    
    //考试结果图标
    resultImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 78)/2.0, 60, 78 , 78 )];
    [mainView addSubview:resultImg];
    
    //考试结果文字提醒
    resultLab = [[UILabel alloc] initWithFrame:CGRectMake(20, resultImg.bottom  + 18, kScreenWidth - 40, 15)];
    
    resultLab.textAlignment = NSTextAlignmentCenter;
    resultLab.textColor = [UIColor whiteColor];
    resultLab.font = Font(15);
    [mainView addSubview:resultLab];
    
    NSInteger testTotal_grade = self.actualScore;//当前者考取的分数
    NSInteger pass_grade = self.passScore;//及格线
    
//    fullGrade = 100;//满分
    if (testTotal_grade == self.fullScore) {
        resultImg.image = [UIImage imageNamed:@"QB_pass"];
        resultLab.text = @"恭喜您，获得满分！！！";
        
    } else if (testTotal_grade >= pass_grade && testTotal_grade < self.fullScore) {
        resultImg.image = [UIImage imageNamed:@"QB_pass"];
        
        resultLab.text = @"很棒，继续加油哦！！！";
        
    } else if (testTotal_grade < pass_grade) {
        resultImg.image = [UIImage imageNamed:@"QB_fail"];
        resultLab.text = @"加油，再接再厉！！！";
    }
    
    
    //矩形背景view
    BgImg = [[UIImageView alloc] initWithFrame:CGRectMake(resultLab.left, resultLab.bottom + 30, resultLab.width, 300)];
    BgImg.image = [UIImage imageNamed:@"mine_btmRect"];
    BgImg.alpha = 0.95;
    BgImg.userInteractionEnabled = YES;
    [mainView addSubview:BgImg];
    
    resultTitLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 15+20, BgImg.width - 100, 35)];
    
    resultTitLab.textColor = [UIColor colorWithRed:117/256.0 green:117/256.0 blue:117/256.0 alpha:1];
    resultTitLab.textAlignment = NSTextAlignmentCenter ;
    resultTitLab.font = Font(13);
    resultTitLab.text = [NSString stringWithFormat:@"%@",self.examLevelName];
    resultTitLab.numberOfLines = 0;
    resultLab.lineBreakMode = NSLineBreakByCharWrapping;
    [BgImg addSubview:resultTitLab];
    
    UIImageView *shareIcon = [[UIImageView alloc] initWithFrame:CGRectMake(BgImg.width - 15 - 21, resultTitLab.top, 21, 21)];
    shareIcon.image = [UIImage imageNamed:@"QB_shareIcon"];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareBtnAction)];
    [shareIcon addGestureRecognizer:tap1];
    shareIcon.userInteractionEnabled = YES;
    [BgImg addSubview:shareIcon];
    
    //2.半径自定义、两端圆角、不显示文本、显示背景线条、渐变颜色两端固定
    CGFloat xCrack = BgImg.width / 9.0;
    CGFloat itemWidth = BgImg.width / 3.0;
    circle = [[ZZGradientProgress alloc] initWithFrame:
              CGRectMake(xCrack, resultTitLab.bottom + 50 ,
                         itemWidth, itemWidth)
                                            startColor:[UIColor colorWithRed:247/255.0
                                                                       green:150/255.0
                                                                        blue:22/255.0
                                                                       alpha:1]
                                              endColor:[UIColor colorWithRed:255/255.0
                                                                       green:107/255.0
                                                                        blue:0/255.0 alpha:1]
                                            startAngle:-90
                                           reduceAngle:0
                                           strokeWidth:10];
    circle.backgroundColor = [UIColor clearColor];
    circle.radius = itemWidth/2.0;
    circle.roundStyle = YES;
    circle.showProgressText = NO;
    circle.showPathBack = YES;
    circle.pathBackColor = [UIColor colorWithRed:220/255.0
                                           green:220/255.0
                                            blue:220/255.0
                                           alpha:1];
    circle.colorGradient = NO;
    circle.progress = testTotal_grade /100.0;
    [BgImg addSubview:circle];
    
    //2.半径自定义、两端圆角、不显示文本、显示背景线条、渐变颜色两端固定，用时
    circle2 = [[ZZGradientProgress alloc] initWithFrame:
               CGRectMake(circle.right + xCrack, circle.top ,
                          circle.width, circle.height)
                                             startColor:[UIColor colorWithRed:247/255.0
                                                                        green:150/255.0
                                                                         blue:22/255.0
                                                                        alpha:1]
                                               endColor:[UIColor colorWithRed:255/255.0
                                                                        green:107/255.0
                                                                         blue:0/255.0
                                                                        alpha:1]
                                             startAngle:-90
                                            reduceAngle:0
                                            strokeWidth:10];
    circle2.backgroundColor = [UIColor clearColor];
    circle2.radius = itemWidth/2.0;
    circle2.roundStyle = YES;
    circle2.showProgressText = NO;
    circle2.showPathBack = YES;
    circle2.pathBackColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    circle2.colorGradient = NO;
    
    seconds = (int)self.useTime % 60;
    minutes = (int)self.useTime / 60;
    
    circle2.progress = (minutes + seconds / 60.0) / self.sumTime;
    [BgImg addSubview:circle2];
    
    
    sumScoreLabel = [[UILabel alloc] initWithFrame:circle.frame];
    sumScoreLabel.textColor = kOrangeColor;
    sumScoreLabel.textAlignment = NSTextAlignmentCenter;
    sumScoreLabel.font = Font(23);
    sumScoreLabel.text = [NSString stringWithFormat:@"%zi",self.actualScore];
    [BgImg addSubview: sumScoreLabel];
    
    seconds = (int)self.useTime %  60;
    minutes = (int)self.useTime / 60;
    NSString *timeStr = [NSString stringWithFormat:@"%.2d'%.2d''", minutes, seconds];
    
    timeConLaebl = [[UILabel alloc] initWithFrame:circle2.frame ];
    timeConLaebl.textColor = kOrangeColor;
    timeConLaebl.textAlignment = NSTextAlignmentCenter;
    timeConLaebl.font = Font(23);
    timeConLaebl.text = timeStr;
    [BgImg addSubview: timeConLaebl];
    
    
    sumScoreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(circle.left, circle.bottom+20 , circle.width, 15)];
    sumScoreTitleLabel.text  = @"得分";
    sumScoreTitleLabel.textColor = k75Color;
    sumScoreTitleLabel.textAlignment = NSTextAlignmentCenter;
    sumScoreTitleLabel.font = Font(K_TEXT_FONT_12);
    [BgImg addSubview: sumScoreTitleLabel];
    
    TimeLab = [[UILabel alloc] initWithFrame:CGRectMake(circle2.left, sumScoreTitleLabel.top ,
                                                        sumScoreTitleLabel.width, sumScoreTitleLabel.height)];
    TimeLab.text  = @"用时";
    TimeLab.textColor = k75Color;
    TimeLab.textAlignment = NSTextAlignmentCenter;
    TimeLab.font = Font(12);
    [BgImg addSubview: TimeLab];
    
    
    BgImg.frame = CGRectMake(BgImg.left, BgImg.top, BgImg.width, TimeLab.bottom + 50);
    
    bgView.height = BgImg.bottom - 100;
    
    [bgView.layer addSublayer:[UIColor setPayGradualChangingColor:bgView
                                                        fromColor:@"FF6B00" toColor:@"F98617"]];

    
    //试题回顾
    CGFloat resultHeight = 64;
    CGFloat resultWidth = 148;
    CGFloat testReview_coorX = (kScreenWidth - resultWidth *2) / 3.0;
    testReview = [[UIImageView alloc] initWithFrame:CGRectMake(testReview_coorX, BgImg.bottom + 50, resultWidth , resultHeight)];
    testReview.image = [UIImage imageNamed:@"QB_testReview"];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]
                                                                            initWithTarget:self
                                                                           action:@selector(reviewQuestion)];
    [testReview addGestureRecognizer:tap2];
    testReview.userInteractionEnabled = YES;
    
    [mainView addSubview:testReview];
    
    closeImg = [[UIImageView alloc] initWithFrame:
                                                            CGRectMake(testReview.right + testReview_coorX,
                                                             testReview.top, testReview.width , testReview.height)];
    closeImg.image = [UIImage imageNamed:@"QB_close"];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]
                                                                            initWithTarget:self
                                                                           action:@selector(closeView)];
    [closeImg addGestureRecognizer:tap3];
    closeImg.userInteractionEnabled = YES;
    
    [mainView addSubview:closeImg];
    
    mainView.contentSize = CGSizeMake(mainView.width, closeImg.bottom +  20);
}
- (void)closeView{
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[QuestionListViewController class]]) {
            QuestionListViewController *questionList = (QuestionListViewController *)vc;
            [self.navigationController popToViewController:questionList animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 试题回顾
- (void)reviewQuestion {
    ReviewQuestionViewController *reviewQuestion = [[ReviewQuestionViewController alloc]init];
    [self.navigationController pushViewController:reviewQuestion animated:YES];
}

- (void)shareBtnAction {
    
    UIImage *image = [ImageTool imageFromView:mainView];
    
    NSData *data = UIImagePNGRepresentation(image);
    NSString *shareTitle = [NSString stringWithFormat:@"健身教练国职专业理论模拟考试\n%@",self.examLevelName];
    ShareView *shareView = [[ShareView alloc]initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:nil shareTitle:shareTitle shareDesp:kShareDefaultText shareLogo:kShareDefaultLogo shareUrl:data];
    [shareView show];
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
