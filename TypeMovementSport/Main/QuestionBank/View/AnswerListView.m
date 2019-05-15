//
//  AnswerListView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "AnswerListView.h"

//vc
#import "AnswerCollectionViewCell.h"
#import "ArticleCommentView.h"

@interface AnswerListView () <
    UICollectionViewDelegate,
    UICollectionViewDataSource> {
        UICollectionView *answerCollection;
        NSInteger index;
        UILabel * countLabel;
        CGPoint startContentOffset;
        CGPoint willEndContentOffset;
        CGPoint endContentOffset;
}

@property (nonatomic, assign) TestQuestionsEnum testQuestionsEnum;
@property (nonatomic, strong) NSMutableDictionary *examInfoDic;//答题信息
@property (nonatomic, assign) NSInteger rightNum;
@property (nonatomic, copy) NSString *examTitle;

@end

@implementation AnswerListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
             testQuestionType:(TestQuestionsEnum)type
            data:(NSMutableArray<ExamModel *> *)examDataArr {
    if (self = [super initWithFrame:frame]) {
        self.testQuestionsEnum = type;
        if (type == TestQuestionsExam) {
            self.examInfoDic = [NSMutableDictionary dictionary];
        }
        self.examDataArr = examDataArr;
        index = 0;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    UIView *footerView = [self createFooterView];
    [self addSubview:footerView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kScreenWidth, footerView.top);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    answerCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, footerView.top) collectionViewLayout:layout];
    answerCollection.backgroundColor = [UIColor whiteColor];
    [answerCollection registerClass:AnswerCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    answerCollection.dataSource = self;
    answerCollection.delegate = self;
    answerCollection.pagingEnabled = YES;
    answerCollection.showsHorizontalScrollIndicator = NO;
    answerCollection.bounces = NO;
    if (@available(iOS 11.0, *)) {
        answerCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    answerCollection.contentOffset = CGPointMake(kScreenWidth*index, 0);
    
    [self addSubview:answerCollection];
}

- (UIView *)createFooterView {
    
    CGFloat hgt_footer = 50;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - hgt_footer, self.width, hgt_footer)];
    footerView.backgroundColor = [UIColor whiteColor];
   
    
    UIImageView *menuImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17.5, 15, 15)];
    menuImg.image = [UIImage imageNamed:@"QB_answerMenu"];
    
    countLabel = [LabelTool createLableWithTextColor:k210Color font:Font(13)];
    countLabel.frame = CGRectMake(menuImg.right + 10, 18, 80, 14);
    countLabel.text = [NSString stringWithFormat:@"%d/%lu", 1 , (unsigned long)self.examDataArr.count];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(16, 16, 100, 20);
    [footerView addSubview:btn];
    
    [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat wdt_icon = 28;
    CGFloat coorX = self.width - 20 - wdt_icon;
    if (self.testQuestionsEnum == TestQuestionsExam) {
        //考试
        UIButton *submitBtn = [ButtonTool createButtonWithTitle:@"我要交卷"
                                                     titleColor:[UIColor whiteColor]
                                                      titleFont:Font(15)
                                                      addTarget:self
                                                         action:@selector(submitTestQuestion)];
        submitBtn.frame = CGRectMake(footerView.width-92, 0, 92, footerView.height);
        submitBtn.backgroundColor = kOrangeColor;
        [footerView addSubview:submitBtn];
        
        coorX = submitBtn.left - 20 - wdt_icon;
    }
    //下一题
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(coorX, 12.5, wdt_icon, wdt_icon)];
    nextImg.image = [UIImage imageNamed:@"QB_next"];
    nextImg.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextAction)];
    [nextImg addGestureRecognizer:tap];
    
    UIImageView *upImg = [[UIImageView alloc] initWithFrame:CGRectMake(nextImg.left - 20-nextImg.width, nextImg.top, nextImg.width, nextImg.height)];
    upImg.image = [UIImage imageNamed:@"QB_last"];
    upImg.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lastAction)];
    [upImg addGestureRecognizer:tap1];
    
    [footerView addSubview:menuImg];
    [footerView addSubview:countLabel];
    [footerView addSubview:nextImg];
    [footerView addSubview:upImg];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.examDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *iden = @"cell";

    AnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    if (!cell) {
        cell = [[AnswerCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height - kNavigationBarHeight - 50)];
    }
    NSLog(@"%ld",(long)indexPath.item);
    
    ExamModel *model = self.examDataArr[indexPath.item];
    cell.serialNumber = indexPath.item+1;
    cell.testQuestionEnum = self.testQuestionsEnum;
    cell.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    cell.model = model;
    
    if (self.testQuestionsEnum == TestQuestionsExam) {
        
        TO_WEAK(self, weakSelf);
        cell.clickConfirmButtonBlcok = ^(NSInteger index) {
            [weakSelf nextAction];
        };
        
        cell.chooseAnswerBlcok = ^(NSString *chooseItem) {
            TO_STRONG(weakSelf, strongSelf);
            NSDictionary *dic = @{
                                  @(model.id):chooseItem,
                                  @"answer":model.answer
                                  };
            
            [strongSelf.examInfoDic setObject:dic forKey:@(model.id)];
        };
    }else if (self.testQuestionsEnum == TestQuestionsBrowse) {
        //试题浏览
        
        TO_WEAK(self, weakSelf);
        cell.questionOperationBlcok = ^(NSInteger index) {
            switch (index) {
                case 0:{
                    //标记重点
                    [weakSelf userQuestionsMarkById:model.id index:indexPath];
                }
                    break;
                case 1:{
                    //忽略此题
                    [weakSelf userQuestionsIgnore:model.id index:indexPath.item];
                }
                    break;
                case 2:{
                    //试题反馈
                    [weakSelf showFeedbackView:model.id];
                }
                    break;
                    
                    
                default:
                    break;
            }
        };
    }

    return cell;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    startContentOffset = scrollView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    willEndContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    endContentOffset = scrollView.contentOffset;
    
    if (endContentOffset.x < willEndContentOffset.x && willEndContentOffset.x < startContentOffset.x) {
        
        index = endContentOffset.x / kScreenWidth;
        countLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)index+1, (unsigned long)_examDataArr.count];
        
    } else if (endContentOffset.x > willEndContentOffset.x && willEndContentOffset.x > startContentOffset.x) {
        
        index = endContentOffset.x / kScreenWidth;
        countLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)index+1, (unsigned long)_examDataArr.count];
    }
}

- (void)reloadData {
    [answerCollection reloadData];
    countLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)index+1, (unsigned long)(_examDataArr.count)];
}

- (void)setRightNum:(NSInteger)rightNum {
    _rightNum = rightNum;
}

- (void)setExamTitle:(NSString *)examTitle {
    _examTitle = examTitle;
}

# pragma mark -- 显示菜单
- (void)showMenu:(UIButton *)btn {
    WrongQuestionsViewController *wrongQuestions = [[WrongQuestionsViewController alloc]init];
    wrongQuestions.examDataArr = self.examDataArr;
    wrongQuestions.testQuestionsEnum = self.testQuestionsEnum;
    wrongQuestions.rightNum = _rightNum;
    wrongQuestions.wrongNum = self.examDataArr.count - _rightNum;
    wrongQuestions.examTitle = _examTitle;;
    TO_WEAK(self, weakSelf);
    wrongQuestions.submitBlock = ^{
        [weakSelf submitTestQuestion];
    };
    
    wrongQuestions.ClickItemNum = ^(NSInteger itemNo) {
      //选择题号
        TO_STRONG(weakSelf, strongSelf);
        if (strongSelf->index == itemNo) {
            return;
        }
        strongSelf->index = itemNo;
        [strongSelf chooseExamTestByIndex:itemNo];
    };
    [self.viewController.navigationController pushViewController:wrongQuestions animated:YES];
}

# pragma mark -- 下一题
- (void)nextAction {
    if (index+1 < _examDataArr.count) {
        index += 1;
        [self chooseExamTestByIndex:index];
    }
}

# pragma mark -- 上一题
- (void)lastAction {
    if (index > 0) {
        index-=1;
        [self chooseExamTestByIndex:index];
    }
}

#pragma mark -- 根据下标跳转到指定考题
- (void)chooseExamTestByIndex:(NSInteger)examIndex {
//    TO_WEAK(self, weakSelf);
    index = examIndex;
//    [UIView animateWithDuration:0.5 animations:^{
//        TO_STRONG(weakSelf, strongSelf);
    [answerCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:examIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//        [strongSelf->answerCollection setContentOffset:CGPointMake(kScreenWidth * examIndex, 0) animated:YES];
    countLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)examIndex+1, (unsigned long)_examDataArr.count];
//    }];
}

# pragma mark -- 提交试卷
- (void)submitTestQuestion {
    
    NSInteger answerNum = self.examInfoDic.allKeys.count;
    
    NSString *content = [NSString stringWithFormat:@"您还有%zi道题未作答，确定交卷吗？",(self.examDataArr.count - answerNum)];
    TO_WEAK(self, weakSelf);
    [[CustomAlertView shareCustomAlertView] showTitle:nil content:content leftButtonTitle:nil rightButtonTitle:nil block:^(NSInteger index) {
        if (index == 1) {
             [weakSelf userExamRecordsCreate];
        }
       
    }];

}

#pragma mark -- 获取未答题数量
- (NSInteger)getNoAnswerCount {
    NSInteger answerNum = self.examInfoDic.allKeys.count;
    return self.examDataArr.count - answerNum;
}

#pragma mark -- 试题反馈输入view
- (void)showFeedbackView:(NSInteger)modelId {
    TO_WEAK(self, weakSelf);
    ArticleCommentView *commentView = [[ArticleCommentView alloc] initArticleCommentViewByViewTitle:@"试题反馈" block:^(NSString *commentContent) {
        [weakSelf userQuestionFeedback:modelId con:commentContent];
    }];
    
    [commentView show];
}

#pragma mark -- 创建考试记录
- (void)userExamRecordsCreate {
    
    NSInteger rightNum = 0;
    NSInteger errorNum = 0;
    //便利答题数组内容
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    NSArray *allKeys = self.examInfoDic.allKeys;
    for (id key in allKeys) {
        @autoreleasepool {
            NSDictionary *dic = self.examInfoDic[key];
            NSArray *allValues = dic.allValues;
            
            if ([allValues.firstObject isEqualToString:allValues.lastObject]) {
                rightNum += 1;
            }
            [mDic setObject:dic[key] forKey:[NSString stringWithFormat:@"%@",key]];
        }
    }
    
    errorNum = self.examDataArr.count - rightNum;
    
    NSString *answerJson = [mDic JSONString];
    
    NSDictionary *para = @{
                           @"classesId":@(_classesId?_classesId:0),
                           @"answer":answerJson?answerJson:@"",//回答的答案(jsonString) {"1":"a","2":"b"}
                           @"successCount":@(rightNum),
                           @"errorCount":@(errorNum)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserExamRecordsCreate parms:para viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            if (strongSelf.submitBlock) {
                NSDictionary *scorePara = @{
                                            @"score":@(rightNum)
                                            };
                strongSelf.submitBlock(scorePara);
            }
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 标为重点
- (void)userQuestionsMarkById:(NSInteger)modelId index:(NSIndexPath *)indexPath {
    NSDictionary *para = @{
                           @"classesId":@(_classesId?_classesId:0),
                           @"questionsId":@(modelId?modelId:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserQuestionsMark parms:para viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            ExamModel *model = self.examDataArr[indexPath.item];
            model.mark = [dict[@"bool"] boolValue];
            
            [strongSelf->answerCollection reloadItemsAtIndexPaths:@[indexPath]];
            
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 试题忽略
- (void)userQuestionsIgnore:(NSInteger)modelId index:(NSInteger)index {
    NSDictionary *para = @{
                           @"classesId":@(_classesId?_classesId:0),
                           @"questionsId":@(modelId?modelId:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserQuestionsIgnore parms:para viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            [strongSelf.examDataArr removeObjectAtIndex:index];
            strongSelf->countLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)index+1, (unsigned long)(strongSelf->_examDataArr.count)];
            [strongSelf->answerCollection reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 试题反馈
- (void)userQuestionFeedback:(NSInteger)modelId con:(NSString *)content {
    NSDictionary *para = @{
                           @"ceedback":content?content:@"",
                           @"questionsId":@(modelId?modelId:0)
                           };
    
//    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserQuestionFeedback parms:para viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            
        }else {
             [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
       

    } failed:^(NSError *error) {
        
    }];
}

@end
