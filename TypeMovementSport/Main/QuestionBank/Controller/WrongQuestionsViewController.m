//
//  WrongQuestionsViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "WrongQuestionsViewController.h"
#import "AnswerListViewController.h"

//view
#import "TestCardCollectionViewCell.h"

@interface WrongQuestionsViewController () <
    UICollectionViewDelegate,
UICollectionViewDataSource> {
    UICollectionView *singleCollection;
}

@end

@implementation WrongQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.testQuestionsEnum) {
        case TestQuestionsBrowse:{
            [self setMyTitle:@"试题列表"];
        }
            break;
        case TestQuestionsExam:{
            [self setMyTitle:@"答题卡"];
            
        }
            break;
        case TestQuestionsReview:{
            [self setMyTitle:@"试题回顾"];
        }
            break;
            
        default:
            break;
    }
    
    
    [self createUI];
}

- (void)createUI {
    
    CGFloat hgt_btn = 0;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    [self.view addSubview:topView];
    if (self.testQuestionsEnum == TestQuestionsReview) {
        //试题回顾
        
        //正确
        UIImageView *trueImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 9, 16, 16)];
        trueImg.image = [UIImage imageNamed:@"QB_right"];
        [topView addSubview:trueImg];
        
        UILabel *trueLabel = [LabelTool createLableWithTextColor:UIColorFromRGB(0x808080) font:Font(15)];
        trueLabel.frame =  CGRectMake(37, 9, 30, 16);
        trueLabel.text = [NSString stringWithFormat:@"%zi",self.rightNum];
        [topView addSubview:trueLabel];
        
        //错题
        UIImageView *falseImg = [[UIImageView alloc] initWithFrame:CGRectMake(97, trueImg.top, trueImg.width, trueImg.height)];
        falseImg.image = [UIImage imageNamed:@"QB_wrong"];
        [topView addSubview:falseImg];
        
        UILabel *falseLabel = [LabelTool createLableWithTextColor:UIColorFromRGB(0x808080) font:Font(15)];
        falseLabel.frame = CGRectMake(118, trueLabel.top, trueLabel.width, trueLabel.height);
        falseLabel.text = [NSString stringWithFormat:@"%zi",self.wrongNum];
        [topView addSubview:falseLabel];
    }else {
        
        UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
        label.frame = CGRectMake(16, 0, topView.width-32, topView.height);
        label.numberOfLines = 0;
        label.text = self.examTitle;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        [topView addSubview:label];
        
        if (self.testQuestionsEnum == TestQuestionsExam) {
            //试题考试
            UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            hgt_btn = 40;
            finishBtn.frame = CGRectMake(0, kScreenHeight - kNavigationBarHeight  - hgt_btn, kScreenWidth, hgt_btn);
            finishBtn.backgroundColor = kOrangeColor;
            finishBtn.titleLabel.font = Font(16);
            [finishBtn setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
            [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.view addSubview:finishBtn];
            [finishBtn addTarget:self action:@selector(submitTestAndGetResult) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 24;
    layout.minimumInteritemSpacing = 24;
    layout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
    layout.itemSize = CGSizeMake((kScreenWidth - 169) / 6, (kScreenWidth - 169) / 6);
    
    singleCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 37, kScreenWidth, kScreenHeight - topView.bottom - kNavigationBarHeight - hgt_btn-10) collectionViewLayout:layout];
    singleCollection.backgroundColor = [UIColor whiteColor];
    
    
    singleCollection.dataSource = self;
    singleCollection.delegate = self;
    singleCollection.userInteractionEnabled = YES;
    singleCollection.bounces = NO;
    
    [self.view addSubview:singleCollection];
    
    [singleCollection registerClass:[TestCardCollectionViewCell class] forCellWithReuseIdentifier:@"singleCell"];
}

#pragma mark - UICollectionView Delegate

#pragma mark item 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.examDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TestCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"singleCell" forIndexPath:indexPath];
    cell.testNumLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item+1];
    
    ExamModel *model = _examDataArr[indexPath.item];
    
    if (self.testQuestionsEnum != TestQuestionsReview) {
        //浏览 | 考试
        cell.testNumLabel.textColor = kOrangeColor;
        cell.testNumLabel.backgroundColor = [UIColor whiteColor];
        cell.testNumLabel.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        if (self.testQuestionsEnum == TestQuestionsExam && model.ownAnswer.length > 0) {
            cell.testNumLabel.textColor = [UIColor whiteColor];
            cell.testNumLabel.backgroundColor = kOrangeColor;
            cell.testNumLabel.layer.borderColor = kOrangeColor.CGColor;
        }
    }else {
        //试题回顾
        
        cell.testNumLabel.textColor = [UIColor whiteColor];
        if (model.ownAnswer.length > 0 && [model.ownAnswer isEqualToString:model.answer]) {
            //正确答案
            cell.testNumLabel.backgroundColor = [UIColor colorWithHexString:@"#00c356"];
            cell.testNumLabel.layer.borderColor = [UIColor colorWithHexString:@"#00c356"].CGColor;
        }else {
            //错题
            cell.testNumLabel.backgroundColor = kOrangeColor;
            cell.testNumLabel.layer.borderColor = kOrangeColor.CGColor;
        }
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.ClickItemNum) {
        self.ClickItemNum(indexPath.row);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    if (self.testQuestionsEnum == TestQuestionsReview) {
//        //试题回顾
//        AnswerListViewController *answerList = [[AnswerListViewController alloc]init];
//        answerList.testQuestionsEnum = self.testQuestionsEnum;
//        answerList.examDataArr = self.examDataArr;
//        answerList.chooseExamIndex = indexPath.item;
//        [self.navigationController pushViewController:answerList animated:YES];
//    }else{
//
//    }
    
}

# pragma mark -- 交卷并查看结果
- (void)submitTestAndGetResult {
    if (self.submitBlock) {
        self.submitBlock();
    }
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
