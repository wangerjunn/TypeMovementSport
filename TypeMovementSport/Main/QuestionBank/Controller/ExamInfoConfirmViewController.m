//
//  ExamInfoConfirmViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ExamInfoConfirmViewController.h"
#import "AnswerListViewController.h"

#import "UserModel.h"

@interface ExamInfoConfirmViewController ()
{
    UIView *bgView;//背景
    UIImageView *headImg;//头像
    UILabel *nameLab;//姓名
    UIImageView *laneOng;
    UILabel *subjectLab;
    UILabel *questionBankLab;
    UILabel *examStandardLab;
    UILabel *qualifiedLab;
    UIImageView *shadowImg;
    UIImageView *startExam;//开始考试
    
    NSString *test_database;
    NSString *test_subject;
    NSString *qualified;
    NSString *juanzi_id;
    NSString *test_time;
    NSString *single_grade;
    NSString *several_grade;
    NSString *show_standard;
}
@end

@implementation ExamInfoConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"考试信息"];
    self.view.backgroundColor = RGBACOLOR(241, 243, 246, 1);
    [self createUI];
}


- (void)createUI {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(40), FIT_SCREEN_HEIGHT(80), kScreenWidth - FIT_SCREEN_WIDTH(80), FIT_SCREEN_HEIGHT(341))];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView setCornerRadius:10];
    [self.view addSubview:bgView];
    
    NSData *data = UserDefaultsGet(kUserModel);
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    headImg = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width - 50)/2.0, 19, 50, 50)];
    [headImg setCornerRadius:headImg.height/2.0];
    headImg.image = [UIImage imageNamed:holdFace];
    [headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:holdImage]];
    [bgView addSubview:headImg];
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, headImg.y + 50 + FIT_SCREEN_HEIGHT(18), bgView.width, 15)];
    nameLab.font = Font(15);
    nameLab.textColor = k75Color;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.text = model.nickName;
    [bgView addSubview:nameLab];
    
    laneOng = [[UIImageView alloc] initWithFrame:CGRectMake(22, nameLab.y + 15 + FIT_SCREEN_HEIGHT(28), bgView.width - 44, 1.5)];
    laneOng.image = [UIImage imageNamed:@"QB_dotted"];
    [bgView addSubview:laneOng];
    CGSize size = [@"考试科目" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(K_TEXT_FONT_12),NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    UILabel *subjectTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, laneOng.y + 1.5 + FIT_SCREEN_HEIGHT(34), JGlabelContentWidth, 13)];
    subjectTitleLabel.textColor = k210Color;
    subjectTitleLabel.text = @"考试科目";
    subjectTitleLabel.font = Font(K_TEXT_FONT_12);
    [bgView addSubview:subjectTitleLabel];
    
    subjectLab = [[UILabel alloc] initWithFrame:CGRectMake(subjectTitleLabel.width + subjectTitleLabel.x + 5, subjectTitleLabel.y, bgView.width - 22 - JGlabelContentWidth - 22, 13)];
    subjectLab.font = Font(K_TEXT_FONT_12);
    subjectLab.text = @"《国职理论模拟练习》";
    subjectLab.textAlignment = NSTextAlignmentRight;
    subjectLab.textColor = k46Color;
    [bgView addSubview:subjectLab];
    
    UILabel *qbTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, subjectTitleLabel.y + 13 + FIT_SCREEN_HEIGHT(19), JGlabelContentWidth, 13)];
    qbTitleLabel.textColor = k210Color;
    qbTitleLabel.text = @"考试题库";
    qbTitleLabel.font = Font(K_TEXT_FONT_12);
    [bgView addSubview:qbTitleLabel];
    
    questionBankLab = [[UILabel alloc] initWithFrame:CGRectMake(qbTitleLabel.width + qbTitleLabel.x + 5, qbTitleLabel.y, bgView.width - 22 - JGlabelContentWidth - 22, 13)];
    questionBankLab.font = Font(K_TEXT_FONT_12);
    questionBankLab.textAlignment = NSTextAlignmentRight;
    questionBankLab.textColor = k46Color;
    questionBankLab.text = @"《国职理论模拟测试》";
    [bgView addSubview:questionBankLab];
    
    UILabel *examTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, qbTitleLabel.y + 13 + FIT_SCREEN_HEIGHT(19), JGlabelContentWidth, 13)];
    examTitleLabel.textColor = k210Color;
    examTitleLabel.text = @"考试科目";
    examTitleLabel.font = Font(K_TEXT_FONT_12);
    [bgView addSubview:examTitleLabel];
    
    examStandardLab = [[UILabel alloc] initWithFrame:CGRectMake(examTitleLabel.width + examTitleLabel.x + 5, examTitleLabel.y, bgView.width - 22 - JGlabelContentWidth - 22, 13)];
    examStandardLab.font = Font(K_TEXT_FONT_12);
    examStandardLab.textAlignment = NSTextAlignmentRight;
    examStandardLab.textColor = k46Color;
    examStandardLab.text = [NSString stringWithFormat:@"100题，%ld分钟",(long)_questionModel.examMinute];
    [bgView addSubview:examStandardLab];
    
    UILabel *qualifiedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, examTitleLabel.y + 13 + FIT_SCREEN_HEIGHT(19), JGlabelContentWidth, 13)];
    qualifiedTitleLabel.textColor = k210Color;
    qualifiedTitleLabel.text = @"考试科目";
    qualifiedTitleLabel.font = Font(K_TEXT_FONT_12);
    [bgView addSubview:qualifiedTitleLabel];
    
    qualifiedLab = [[UILabel alloc] initWithFrame:CGRectMake(qualifiedTitleLabel.width + qualifiedTitleLabel.x + 5, qualifiedTitleLabel.y, bgView.width - 22 - JGlabelContentWidth - 22, 13)];
    qualifiedLab.font = Font(K_TEXT_FONT_12);
    qualifiedLab.textAlignment = NSTextAlignmentRight;
    qualifiedLab.textColor = k46Color;
   
    qualifiedLab.text = [NSString stringWithFormat:@"100分满分，%ld及格",(long)_questionModel.passScore];;
    [bgView addSubview:qualifiedLab];
    
    shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(40) + 25, bgView.y + bgView.height, kScreenWidth - FIT_SCREEN_WIDTH(80) - 50, 17)];
    shadowImg.image = [UIImage imageNamed:@"general_shadow"];
    [self.view addSubview:shadowImg];
    
    CGFloat wdtStart = 142;
    startExam = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - wdtStart)/2.0, bgView.y + bgView.height + 50, 142, 85)];
    startExam.image = [UIImage imageNamed:@"QB_startExam"];
    [self.view addSubview:startExam];
    startExam.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmBtnAction)];
    [startExam addGestureRecognizer:tap];
    
}

# pragma mark -- 开始考试
- (void)confirmBtnAction {
    
    [self getTestData:self.questionModel];
}

#pragma mark -- 获取考试题
- (void)getTestData:(QuestionModel *)model {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kQuestionFindAllByClass parms:@{@"classesId":@(model.id?model.id:0)} viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
//                TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            @autoreleasepool {
                for (NSDictionary *tmp in list) {
                    ExamModel *model = [[ExamModel alloc] initWithDictionary:tmp error:nil];
                    [arr addObject:model];
                }
            }
            
            if (list.count < 1) {
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"暂无试题" buttonTitle:nil block:nil];
                return;
            }
            AnswerListViewController *answerList = [[AnswerListViewController alloc]init];
            answerList.backViewController = self;
            answerList.testQuestionsEnum = TestQuestionsExam;
            answerList.examDataArr = arr;
            answerList.backViewController = self.backViewController;
            answerList.classesId = model.id;
            answerList.examLevelName = model.title;
            answerList.questionModel = weakSelf.questionModel;
            [weakSelf.navigationController pushViewController:answerList animated:YES];
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
