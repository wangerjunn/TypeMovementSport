//
//  AnswerCollectionViewCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "AnswerCollectionViewCell.h"
#import "ParamFile.h"
#import "AnswerTableViewCell.h"

#import "AnswerTableViewHeader.h"

@interface AnswerCollectionViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *confirmBtn;


@end

@implementation AnswerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
            [self createView];
    }
    return self;
    
}

- (void)createView {
    self.optionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) style:UITableViewStylePlain];
    self.optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.optionTableView.delegate = self;
    self.optionTableView.dataSource = self;
    self.optionTableView.bounces = NO;
    if (@available(iOS 11.0,*)) {
        _optionTableView.estimatedRowHeight = 0;
        _optionTableView.estimatedSectionHeaderHeight = 0;
        _optionTableView.estimatedSectionFooterHeight = 0;
        _optionTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.optionTableView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    [self.optionTableView registerClass:AnswerTableViewHeader.class forHeaderFooterViewReuseIdentifier:@"header"];
    [self.optionTableView registerClass:AnswerTableViewCell.class forCellReuseIdentifier:@"cell"];
    [self.contentView addSubview:_optionTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if ([_model.type isEqualToString:@"JUDGE"]) {
        return 2;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.testQuestionEnum != TestQuestionsBrowse && section == 1) {
        return 100;
    }
    
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1 && self.testQuestionEnum != TestQuestionsBrowse) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        if (self.testQuestionEnum == TestQuestionsExam) {
            //考试显示确定按钮,已存在答案时隐藏确定按钮
            UIImageView *confirmIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_confirm"]];
            [footerView addSubview:confirmIcon];
            
            
            CGFloat hgtIcon = 170/2.0;
            CGFloat wdtIcon = 524/2.0;
            confirmIcon.frame = CGRectMake(footerView.width/2.0-wdtIcon/2.0,
                                           footerView.height/2.0-hgtIcon/2.0+10,
                                           wdtIcon, hgtIcon);
            confirmIcon.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(confirmBtnAction)];
            [confirmIcon addGestureRecognizer:tap];
        }else if (self.testQuestionEnum == TestQuestionsReview) {
            //试题回顾时展示答案是否正确
            //用户选的答案
            UILabel *userAnswerLabel = [LabelTool createLableWithTextColor:k75Color font:Font(13)];
            userAnswerLabel.frame = CGRectMake(28, 0, footerView.width-28, footerView.height);
            
//            userAnswerLabel.text = @"回答正确";
            [footerView addSubview:userAnswerLabel];
            
            
            if (_model.ownAnswer.length > 0 && [_model.ownAnswer isEqualToString:_model.answer]) {
                NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回答正确"]];
                userAnswerLabel.attributedText = result;
                
            } else if (_model.ownAnswer.length < 1) {
                NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正确答案%@, 本题您未作答", _model.answer]];
                [result addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00c356"] range:NSMakeRange(4, _model.answer.length)];
                userAnswerLabel.attributedText = result;
                
            } else {
                NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正确答案%@, 您的答案%@", _model.answer, _model.ownAnswer]];
                [result addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00c356"] range:NSMakeRange(4, _model.answer.length)];
                
                [result addAttribute:NSForegroundColorAttributeName value:kOrangeColor range:NSMakeRange(result.string.length - _model.ownAnswer.length, _model.ownAnswer.length)];
                userAnswerLabel.attributedText = result;
                
            }
        }
        
        return footerView;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 30;
    }
    
    if (self.testQuestionEnum != TestQuestionsBrowse) {
        return FIT_SCREEN_HEIGHT(27.5*2+16.5) + 45 + _model.contentHeight - 30;
    }
    
    //试题浏览
    return FIT_SCREEN_HEIGHT(27.5*2+16.5) + 45 + _model.contentHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [UIView new];
    }
    AnswerTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    header.contentView.backgroundColor = [UIColor whiteColor];
    
    header.typeLabel.text = @"单选题";
    if ([_model.type isEqualToString:@"JUDGE"]) {
        header.typeLabel.text = @"判断题";
    }else if ([_model.type isEqualToString:@"MULTIPLE"]) {
        header.typeLabel.text = @"多选题";
    }
    
    NSString *content = [NSString stringWithFormat:@"%ld %@",(long)self.serialNumber,_model.content];
    header.themeLabel.text = content;
    
    [UITool label:header.themeLabel andLineSpacing:10 andColor:k46Color];
    header.themeLabel.frame = CGRectMake(header.themeLabel.left,
                                         header.themeLabel.top,
                                         header.themeLabel.width,
                                         _model.contentHeight+FIT_SCREEN_HEIGHT(27.5));
    
    if (self.testQuestionEnum == TestQuestionsBrowse) {
        //试题浏览
        header.actionView.hidden = NO;
        header.actionView.top = FIT_SCREEN_HEIGHT(27.5*2+16.5) + 45 + _model.contentHeight - 30;
        header.model = _model;
        
        TO_WEAK(self, weakSelf);
        header.ClickBottomActionBlock = ^(NSInteger index) {
            
            if (weakSelf.questionOperationBlcok) {
                weakSelf.questionOperationBlcok(index);
            }
        };
    }else{
        header.actionView.hidden = YES;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSString *chooseItem =  [NSString stringWithFormat:@"%c",(65+indexPath.row)]; // A
    
    if (([_model.ownAnswer containsString:chooseItem] && self.testQuestionEnum == TestQuestionsExam) || (self.testQuestionEnum != TestQuestionsExam && [_model.answer containsString:chooseItem])) {
        cell.mainView.backgroundColor = kOrangeColor;
        cell.titleLabel.textColor = [UIColor whiteColor];
    } else{
        cell.titleLabel.textColor = k75Color;
        cell.mainView.backgroundColor = [UIColor whiteColor];
    }
    
    
    CGFloat mainViewHeight = 0;
    switch (indexPath.item) {
        case 0:
            cell.titleLabel.text = [NSString stringWithFormat:@"%@.%@",chooseItem,_model.a];
            mainViewHeight = _model.aHeight+20;
            break;
        case 1:
            cell.titleLabel.text = [NSString stringWithFormat:@"%@.%@",chooseItem,_model.b];
            mainViewHeight = _model.bHeight+20;
            break;
        case 2:
            cell.titleLabel.text = [NSString stringWithFormat:@"%@.%@",chooseItem,_model.c];
            mainViewHeight = _model.cHeight+20;
            break;
        case 3:
            cell.titleLabel.text = [NSString stringWithFormat:@"%@.%@",chooseItem,_model.d];
            mainViewHeight = _model.dHeight+20;
            break;
            
        default:
            break;
    }
    
    cell.mainView.height = mainViewHeight;
    cell.titleLabel.height = mainViewHeight;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.item) {
        case 0:
            return _model.aHeight+30;
        case 1:
            return _model.bHeight+30;
        case 2:
            return _model.cHeight+30;
        case 3:
            return _model.dHeight+30;
            
        default:
            break;
    }
    
    
    return 45;
    
//    NSString *content = @"A.这是A选项的内容";
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil];
//
//    CGRect rect = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 76, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    return rect.size.height + 30;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (self.testQuestionEnum != TestQuestionsExam) {
        return;
    }
    
    //是否是多选题
    BOOL isMultiple = [_model.type isEqualToString:@"MULTIPLE"];
    
    
    NSString *chooseItem =  [NSString stringWithFormat:@"%c",(65+indexPath.row)]; // A
    
    
    //非多选题且当前选项已经选中
    if (!isMultiple && [_model.ownAnswer containsString:chooseItem]) {
        return;
    }
    
    
    if (isMultiple) {//多选题
        if ([_model.ownAnswer containsString:chooseItem]) {
            _model.ownAnswer = [_model.ownAnswer stringByReplacingOccurrencesOfString:chooseItem withString:@""];
        }else {
            NSString *seleCon = _model.ownAnswer;
            
            seleCon = [seleCon stringByAppendingString:chooseItem];
            
            _model.ownAnswer = [self sortAnswerByContent:seleCon];
        }
    }else {//单选题
        _model.ownAnswer = chooseItem;
    }
    
    if (self.chooseAnswerBlcok) {
        self.chooseAnswerBlcok(_model.ownAnswer);
    }
    
    TO_WEAK(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf.optionTableView reloadData];
    });
}

- (NSString *)sortAnswerByContent:(NSString *)content {
    
    NSMutableArray *letterConArr = [NSMutableArray array];
    for (int i =0; i < content.length; i++) {
        NSString *con = [content substringWithRange:NSMakeRange(i, 1)];
        
        [letterConArr addObject:con];
    }
    
    static  NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSComparator finderSortBlock = ^(id string1, id string2) {
        NSRange string1Range = NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    };
    NSArray *finderSortArray = [letterConArr sortedArrayUsingComparator:finderSortBlock];
    
    NSLog(@"finderSortArray: %@", finderSortArray);
    
    NSMutableString *mString = [NSMutableString string];
    for (NSString *tmp in finderSortArray) {
        [mString appendString:tmp];
    }
    
    return mString;
}
# pragma mark -- 考试场景下 确认答案按钮
- (void)confirmBtnAction {
    if (self.clickConfirmButtonBlcok) {
        self.clickConfirmButtonBlcok(self.serialNumber);
    }
}

- (void)setModel:(ExamModel *)model {
    _model = model;
    [self.optionTableView reloadData];
}

@end
