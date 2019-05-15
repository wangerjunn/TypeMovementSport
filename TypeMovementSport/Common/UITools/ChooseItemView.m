//
//  ChooseResumeItemView.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/29.
//  Copyright © 2018年 XDH. All rights reserved.
//

#define kTitle  @"title"
#define kIsSele @"isSele"
#define kTitles @"titles"

#import "ChooseItemView.h"

@interface ChooseItemView () <
    UITableViewDelegate,
    UITableViewDataSource> {
    UIView *bgView;
    UIView *conView;
    UITableView *listTable;
    NSArray *dataArr;
    NSInteger curIndex;
        
    BOOL _isMultiple;//是否多选
    NSMutableArray *multipleContents;
}

@end


@implementation ChooseItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initCityMenuViewByViewTitle:(NSString *)viewTitle
                                        arr:(NSArray <NSString*> *)conArr
                                seleContent:(NSString *)seleContent
                                 isMultiple:(BOOL)isMutiple
                                  seleBlock:(void (^)(NSString *seleCon))block {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        //初始化数据
        dataArr = conArr;
        self.seleBlock = block;
        _isMultiple = isMutiple;
        if (isMutiple) {
            //多选
            if (!multipleContents) {
                multipleContents = [NSMutableArray array];
            }
            if (seleContent.length > 0) {
                NSArray *elements = [seleContent componentsSeparatedByString:@","];
                [multipleContents addObjectsFromArray:elements];
            }
            
        }else {
            //单选
            if (seleContent.length > 0) {
                curIndex = [dataArr indexOfObject:seleContent];
            }else{
                curIndex = 0;
            }
        }
        
        [self createUI:viewTitle];
    }
    
    return self;
}

- (void)createUI:(NSString *)viewTitle {
    
    self.backgroundColor = [UIColor clearColor];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
    [bgView addGestureRecognizer:tap];
    [self addSubview:bgView];
    
    CGFloat wdt = FIT_SCREEN_WIDTH(300);
    CGFloat hgt = FIT_SCREEN_HEIGHT(500);
    
    conView = [[UIView alloc]initWithFrame:CGRectMake((self.width - wdt)/2.0,
                                                      self.height,
                                                      wdt, hgt)];
    [conView setCornerRadius:5];
    conView.backgroundColor = [UIColor whiteColor];
    [self addSubview:conView];
    
    UILabel *titleLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(18)];
    titleLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(20),
                                  FIT_SCREEN_HEIGHT(34),
                                  conView.width-FIT_SCREEN_WIDTH(40), 19);
    titleLabel.text = viewTitle;
    [conView addSubview:titleLabel];
    
    
    listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom,
                                                              conView.width,
                                                              conView.height-50-titleLabel.bottom)
                                             style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [conView addSubview:listTable];
    
    UIButton *btn_confirm = [ButtonTool createButtonWithTitle:@"确定"
                                                   titleColor:kOrangeColor
                                                    titleFont:Font(K_TEXT_FONT_14)
                                                    addTarget:self
                                                       action:@selector(confirmAction)];
    btn_confirm.frame = CGRectMake(conView.width-50, listTable.bottom, 50, 50);
    
    [conView addSubview:btn_confirm];
    
    UIButton *cancelBtn = [ButtonTool createButtonWithTitle:@"取消"
                                                 titleColor:k210Color
                                                  titleFont:Font(K_TEXT_FONT_14)
                                                  addTarget:self
                                                     action:@selector(removeSelf)];
    cancelBtn.frame = CGRectMake(btn_confirm.left-btn_confirm.width,
                                 btn_confirm.top, btn_confirm.width,
                                 btn_confirm.height);
    [conView addSubview:cancelBtn];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat wdt = FIT_SCREEN_WIDTH(9);
        UIImageView *normalImg = [[UIImageView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(20),  (50 - wdt)/2.0, wdt, wdt)];
        normalImg.image =  [UIImage imageNamed:@"course_pay_normal"];
        [cell.contentView addSubview:normalImg];
        
        UIImageView *seleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(normalImg.left + FIT_SCREEN_WIDTH(1.5),
                                                                              normalImg.top + FIT_SCREEN_WIDTH(1.5),
                                                                              FIT_SCREEN_WIDTH(6), FIT_SCREEN_WIDTH(6))];
        seleIcon.image = [UIImage imageNamed:@"course_pay_sele"];
        seleIcon.tag = 99;
        [cell.contentView addSubview:seleIcon];
        
        
        UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
        label.frame = CGRectMake(normalImg.right+8, 0, conView.width - normalImg.right - 8, 50);
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
   
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    UIImageView *seleIcon = (UIImageView *)[cell.contentView viewWithTag:99];
    
    label.text = @"";
    
    label.text = dataArr[indexPath.row];
    
    if (_isMultiple) {
        //多选
        if ([multipleContents containsObject:label.text]) {
            seleIcon.hidden = NO;
        }else {
            seleIcon.hidden = YES;
        }
    }else{
        //单选
        if (curIndex == indexPath.row) {
            seleIcon.hidden = NO;
        }else {
            seleIcon.hidden = YES;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isMultiple) {
        //多选
        if ([multipleContents containsObject:dataArr[indexPath.row]]) {
            [multipleContents removeObject:dataArr[indexPath.row]];
        }else{
            [multipleContents addObject:dataArr[indexPath.row]];
        }
    }else {
        //单选
        if (curIndex == indexPath.row) {
            return;
        }
        
        curIndex = indexPath.row;
    }
    
    
    
    TO_WEAK(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->listTable reloadData];
    });
}

# pragma mark -- 确定
- (void)confirmAction {
    
    
    if (_isMultiple) {
        //多选
        
        NSMutableString *mString = [NSMutableString stringWithString:@""];
        
        for (int i = 0; i < multipleContents.count; i++) {
            
            [mString appendString:multipleContents[i]];
            if (i < multipleContents.count - 1 && multipleContents.count > 1) {
                [mString appendString:@","];
            }
        }
        
        if (self.seleBlock) {
            self.seleBlock(mString);
        }
    }else {
        //单选
        if (self.seleBlock) {
            if (dataArr.count > curIndex) {
                self.seleBlock(dataArr[curIndex]);
            }
        }
    }
    
    [self removeSelf];
}

- (void)removeSelf {
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        strongSelf->conView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        
        strongSelf->conView.transform = CGAffineTransformMakeTranslation
        (0, -(strongSelf->conView.height+self.height/2.0-strongSelf->conView.height/2.0));
    }];
}

@end
