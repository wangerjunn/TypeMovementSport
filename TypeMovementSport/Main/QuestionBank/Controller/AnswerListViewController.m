//
//  AnswerListViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "AnswerListViewController.h"
#import "GetExamResultViewController.h"//查询成绩结果

#import "AnswerListView.h"
#import "CustomAlertView.h"

@interface AnswerListViewController () {
    dispatch_source_t _timer;
    AnswerListView *answerListView;
    NSInteger spendMinutes;//耗时分钟
    NSInteger spendSecond;//耗时秒
}

@property (nonatomic, strong) UILabel *countdownLabel;

@end

@implementation AnswerListViewController


- (void)goBack {
    //离开页面时清除定时器
    if (self.testQuestionsEnum == TestQuestionsExam) {
//        NSInteger noAnswerCount = [answerListView getNoAnswerCount];
//        NSString *content = [NSString stringWithFormat:@"您还有%ld道题未作答，确定交卷吗？",(long)noAnswerCount];
        NSString *content = @"是否放弃答题";
        TO_WEAK(self, weakSelf);
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:content leftButtonTitle:nil rightButtonTitle:nil block:^(NSInteger index) {
            if (index == 1) {
                TO_STRONG(weakSelf, strongSelf);
                if (strongSelf->_timer) {
                    dispatch_source_cancel(strongSelf->_timer);
                    strongSelf->_timer = nil;
                }

                [super goBack];
            }

        }];
//        [answerListView submitTestQuestion];
    }else {
        [super goBack];
    }
    
}

# pragma mark -- 一键还原
- (void)oneKeyRecovery {
    
    TO_WEAK(self, weakSelf);
    [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"是否恢复所有已忽略题目" leftButtonTitle:nil rightButtonTitle:nil block:^(NSInteger index) {
        if (index == 1) {
            //确定
            [weakSelf userQuestionsRestore];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.testQuestionsEnum == TestQuestionsExam) {
        //设置导航栏倒计时
        self.countdownLabel = [LabelTool createLableWithTextColor:k46Color font:[UIFont fontWithName:@"DINCondensed-Bold" size: 15]];
        self.countdownLabel.frame = CGRectMake(0, 0, kScreenWidth/2.0, 30);
        self.countdownLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = self.countdownLabel;
        
        [self createTimeOut];
    }else if (self.testQuestionsEnum == TestQuestionsBrowse) {
        //试题浏览
        [self setNavItemWithImage:@"QB_reset"
                  imageHightLight:@"QB_reset"
                           isLeft:NO target:self
                           action:@selector(oneKeyRecovery)];
    }
    [self createUI];
}

- (void)createUI {
    answerListView = [[AnswerListView alloc] initWithFrame:
                      CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)
                                          testQuestionType:self.testQuestionsEnum
                                                      data:self.examDataArr];
    
    answerListView.classesId = self.classesId;
    [answerListView setRightNum:self.rightNum];
    [answerListView setExamTitle:_examLevelName];
    TO_WEAK(self, weakSelf);
    answerListView.submitBlock = ^ (NSDictionary *info){
        TO_STRONG(weakSelf, strongSelf);
        if (strongSelf->_timer) {
            dispatch_source_cancel(strongSelf->_timer);
            strongSelf->_timer = nil;
        }
        
        if (info) {
            GetExamResultViewController *getExamResult = [[GetExamResultViewController alloc]init];
            getExamResult.examLevelName = strongSelf->_examLevelName;
            getExamResult.passScore = weakSelf.questionModel.passScore;
            getExamResult.fullScore = 100;
            getExamResult.sumTime = weakSelf.questionModel.examMinute;
            getExamResult.useTime = 60*60 - (strongSelf->spendMinutes*60 + strongSelf->spendSecond);
            if (info[@"score"]) {
                getExamResult.actualScore = [info[@"score"] integerValue];
            }
            [weakSelf.navigationController pushViewController:getExamResult animated:YES];
        }
    };
    
    if (self.chooseExamIndex > 0) {
        [answerListView chooseExamTestByIndex:self.chooseExamIndex];
    }
    [self.view addSubview:answerListView];
    
}

- (void)createTimeOut {
    
    //获取当前时间
    NSString *nowDateString = [self getCurrentTimeyyyymmdd];
    
    //计算获取倒计时之后的时间
    NSDate *deadLineDate = [NSDate dateWithTimeInterval:60*60 sinceDate:[NSDate date]];
    NSString *deadlineDateStr = [self getDateString:deadLineDate];
    
    NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:nowDateString deadlineStr:deadlineDateStr];
    
    __weak __typeof(self) weakSelf = self;
    
    if (_timer == nil) {
        __block NSInteger timeout = secondsCountDown; // 倒计时时间
        TO_STRONG(weakSelf, strongSelf);
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                
                if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                    dispatch_source_cancel(strongSelf->_timer);
                    strongSelf->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        weakSelf.countdownLabel.text = @"当前活动已结束";
                        weakSelf.countdownLabel.text = @"考试时间结束";
                        [strongSelf->answerListView submitTestQuestion];
                    });
                } else { // 倒计时重新计算 时/分/秒
                    NSInteger days = (int)(timeout/(3600*24));
                    NSInteger hours = (int)((timeout-days*24*3600)/3600);
                    NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                    
                    strongSelf->spendMinutes = minute;
                    strongSelf->spendSecond = second;
                    NSString *strTime = [NSString stringWithFormat:@"倒计时：%02ld分%02ld秒", (long)minute, (long)second];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.countdownLabel.text = strTime;
                        
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                }
            });
            dispatch_resume(_timer);
        }
    }
    
}

/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    
    return [self getDateString:now];
}


/**
 获取时间的字符串
 
 @param date 要格式化的时间
 @return 格式化的时间
 */
- (NSString *)getDateString:(NSDate *)date {
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:date];
    
    return dayStr;
}


/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}

#pragma mark -- 一键还原接口
- (void)userQuestionsRestore {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserQuestionsRestore parms:@{@"classesId":@(_classesId?_classesId:0)} viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
//        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            if ([dict[@"bool"] integerValue] == 1) {
                [weakSelf loadExamData];
            }
//            NSArray *list = dict[@"list"];
//
//            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
//            for (NSDictionary *tmp in list) {
//                @autoreleasepool {
//                    ExamModel *model = [[ExamModel alloc] initWithDictionary:tmp error:nil];
//                    [arr addObject:model];
//                }
//            }
//
//            strongSelf.examDataArr = arr;
//            strongSelf->answerListView.examDataArr = arr;
//            [strongSelf->answerListView reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 一键还原之后加载数据
- (void)loadExamData {
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kQuestionFindAllByClass parms:@{@"classesId":@(_classesId?_classesId:0)} viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
//            NSArray *modelArr = [ExamModel arrayOfModelsFromDictionaries:list error:nil];
//            NSArray *dictArr = [ExamModel arrayOfDictionariesFromModels:modelArr];
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    ExamModel *model = [[ExamModel alloc] initWithDictionary:tmp error:nil];
                    [arr addObject:model];
                }
            }
            strongSelf.examDataArr = arr;
            strongSelf->answerListView.examDataArr = arr;
            [strongSelf->answerListView reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
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
