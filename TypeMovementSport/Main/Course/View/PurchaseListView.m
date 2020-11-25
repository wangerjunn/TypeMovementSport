//
//  PurchaseListView.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PurchaseListView.h"
#import "PurchaseListCell.h"

#import "QuestionModel.h"

@interface PurchaseListView () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *mainTable;
        UIView *bgView;
        UIView *conView;
        UILabel *totalPriceLabel;//总金额
        NSString *_viewTitle;
        NSArray *_conArr;
        
        NSMutableArray *seleArr;//选择购买的课程
        
        CGFloat totalMoney;//总金额
}

@property (nonatomic, strong) UIView *attachView;//提示下载附件view


@end


@implementation PurchaseListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initPurchaseViewByTitle:(NSString *)viewTitle
                                dataArr:(NSArray *)dataArr
                          purchaseBlock:(void (^)(NSArray *seleCon, CGFloat totalMoney))block {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        self.purchaseClickBlock = block;
        _viewTitle = viewTitle;
        _conArr = dataArr;
        totalMoney = 0;
        for (QuestionModel *model in dataArr) {
            if (model.isPurchase) {
                totalMoney += model.price/100;
            }
        }
        self.backgroundColor = [UIColor clearColor];
        seleArr = [NSMutableArray array];
        
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    bgView = [[UIView alloc]initWithFrame:self.frame];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tap_removeView = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(closeView)];
    [bgView addGestureRecognizer:tap_removeView];
    [self addSubview:bgView];
    
    CGFloat wdt_conView = 300;
    CGFloat hgt_conView = FIT_SCREEN_HEIGHT(500);
    conView = [[UIView alloc]initWithFrame:CGRectMake((self.width - wdt_conView)/2.0,
                                                      (self.height - hgt_conView)/2.0,
                                                      wdt_conView,
                                                      hgt_conView)];
    conView.backgroundColor = [UIColor whiteColor];
    conView.layer.masksToBounds = YES;
    conView.layer.cornerRadius = 10;
    [self addSubview:conView];
    
    CGFloat coorX = 20;
    UILabel *titleLab = [LabelTool createLableWithTextColor:k46Color font:BoldFont(18)];
    titleLab.frame = CGRectMake(coorX ,FIT_SCREEN_HEIGHT(34), conView.width - coorX, 19);
    titleLab.text = @"购买列表";
    [conView addSubview:titleLab];
    
    UIImageView *topPurchaseBgImg = [[UIImageView alloc] init];
    topPurchaseBgImg.image = [UIImage imageNamed:@"course_pay_bg"];
    [conView addSubview:topPurchaseBgImg];
    CGFloat bgWdt = 262;
    topPurchaseBgImg.frame = CGRectMake((conView.width - bgWdt)/2.0,
                                        titleLab.bottom + FIT_SCREEN_HEIGHT(26),
                                        bgWdt,  62);
    topPurchaseBgImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                          action:@selector(topPurchaseBgImgAction)];
    [topPurchaseBgImg addGestureRecognizer:tap1];
    
    
    UILabel *goodsTitleLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:BoldFont(15)];
    goodsTitleLabel.text = _viewTitle;
    goodsTitleLabel.frame = CGRectMake(coorX/2.0 ,(topPurchaseBgImg.height - 32.5)/2.0 - coorX/2.0 , topPurchaseBgImg.width - FIT_SCREEN_WIDTH(55), 32.5);
    [topPurchaseBgImg addSubview:goodsTitleLabel];
    
    
    UIImageView *buyImg = [[UIImageView alloc] init];
    buyImg.image = [UIImage imageNamed:@"course_pay_buy"];
    [topPurchaseBgImg addSubview:buyImg];
    
    
    
    buyImg.frame = CGRectMake(topPurchaseBgImg.width - 32.5 - goodsTitleLabel.left,
                              goodsTitleLabel.top,
                              32.5, goodsTitleLabel.height);
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(24),
                                                              topPurchaseBgImg.bottom + FIT_SCREEN_HEIGHT(20),
                                                              conView.width - FIT_SCREEN_WIDTH(24) - FIT_SCREEN_WIDTH(20),
                                                              conView.height - topPurchaseBgImg.bottom - FIT_SCREEN_HEIGHT(20) - FIT_SCREEN_HEIGHT(40) - 12)
                                             style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0,*)) {
        mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTable.estimatedRowHeight = 0;
        mainTable.estimatedSectionHeaderHeight = 0;
        mainTable.estimatedSectionFooterHeight = 0;
    }
    [conView addSubview:mainTable];
   
    UILabel *totalPriceTitleLabel =  [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    totalPriceTitleLabel.text = @"总价:";
    totalPriceTitleLabel.frame = CGRectMake(mainTable.left, conView.height - FIT_SCREEN_HEIGHT(20) - 17, 40, 18);
    [conView addSubview:totalPriceTitleLabel];
    
    //结算
    UIImageView *clearingImg = [[UIImageView alloc] init];
    clearingImg.image = [UIImage imageNamed:@"course_pay_clearing"];
    CGFloat wdt_clearing = 81;
    clearingImg.frame = CGRectMake(conView.width - 17 - wdt_clearing,
                                   conView.height - 13 - 31,
                                   wdt_clearing, 31);
    
    [conView addSubview:clearingImg];
    clearingImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(clearingAction)];
    [clearingImg addGestureRecognizer:tap];
    
    //总价
    totalPriceLabel =  [LabelTool createLableWithTextColor:kOrangeColor font:Font(18)];
    totalPriceLabel.frame = CGRectMake(totalPriceTitleLabel.right,
                                       totalPriceTitleLabel.top,
                                       clearingImg.left - totalPriceTitleLabel.right,
                                       totalPriceTitleLabel.height);
    totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney];
    [conView addSubview:totalPriceLabel];
    
    //关闭
    UIButton *closeBtn = [ButtonTool createButtonWithImageName:@"course_pay_close" addTarget:self action:@selector(closeView)];
    CGFloat wdt_btn = 26;
    closeBtn.frame = CGRectMake(conView.width - wdt_btn - 5, 5, wdt_btn, wdt_btn);
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [conView addSubview:closeBtn];
    
    [conView addSubview:self.attachView];
    
}

- (UIView *)attachView {
    if (!_attachView) {
        
        CGFloat coorY = mainTable.top - FIT_SCREEN_HEIGHT(15);
        _attachView = [[UIView alloc] initWithFrame:CGRectMake(15, coorY, conView.width - 30, conView.height - coorY - 5)];
        
        _attachView.layer.cornerRadius = 15;
        _attachView.layer.masksToBounds = YES;
        _attachView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.5];
        
        UIImageView *tipsIcon = [[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"course_purchase_tips"]];
        CGFloat wdtTipsIcon = 80;
        tipsIcon.frame = CGRectMake(_attachView.width - wdtTipsIcon - 15, 5, wdtTipsIcon, wdtTipsIcon);
        [_attachView addSubview:tipsIcon];
        
        UILabel *tipsConLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(24)];
        tipsConLabel.numberOfLines = 0;
        tipsConLabel.lineBreakMode = NSLineBreakByCharWrapping;
        tipsConLabel.frame = CGRectMake(15, tipsIcon.bottom + 10, tipsIcon.right - 15,   60);
        tipsConLabel.textAlignment = NSTextAlignmentRight;
        tipsConLabel.text = @"购买整套课程\n赠送电子讲义";
        [_attachView addSubview:tipsConLabel];
        
        CGFloat wdtBtn = 40;
        UIButton *cancelBtn = [ButtonTool createButtonWithImageName:@"HP_card_close"
                                                          addTarget:self
                                                             action:@selector(removeTipsView)];
        cancelBtn.frame = CGRectMake(tipsConLabel.left, tipsConLabel.left, wdtBtn, wdtBtn);
        
        [_attachView addSubview:cancelBtn];
        
    }
    
    return _attachView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PurchaseListCell *cell = [mainTable dequeueReusableCellWithIdentifier:@"mainCell"];
    if (!cell) {
        cell = [[PurchaseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    
    QuestionModel *model = _conArr[indexPath.row];
    
    cell.titLab.text = [NSString stringWithFormat:@"%@",model.name?model.name:@""];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",model.price/100];
    
    if (!model.isPurchase && model.expireTime == 0) {
        cell.chooseImg.hidden = YES;
        cell.clickBtn.selected = NO;
    }else {
        cell.chooseImg.hidden = NO;
        cell.clickBtn.selected = YES;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FIT_SCREEN_HEIGHT(52);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionModel *model = _conArr[indexPath.row];
    
    if (model.expireTime == 0) {
        model.isPurchase = !model.isPurchase;
        if (model.isPurchase) {
            [seleArr addObject:model];
            
            totalMoney += model.price/100;
        }else {
            [seleArr removeObject:model];
            totalMoney -= model.price/100;
        }
        
        [mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",fabs(totalMoney)];
    }
    
}

# pragma mark -- 点击顶部购买所有课程
- (void)topPurchaseBgImgAction {
    
    if (self.PurchaseTotalVideoBlock) {
        self.PurchaseTotalVideoBlock();
    }
    [self closeView];
}

#pragma mark --  移除提示view
- (void)removeTipsView {
    [self.attachView removeFromSuperview];
}

# pragma mark -- 结算
- (void)clearingAction {
    
    if (seleArr.count < 1) {
        return;
    }
    if (self.purchaseClickBlock) {
        self.purchaseClickBlock(seleArr, totalMoney);
    }
    
    [self closeView];
}

# pragma mark -- 移除view
- (void)closeView {
    [self removeFromSuperview];
}

- (void)isShowPdfTips:(BOOL)isShow {
    if (!isShow) {
        self.attachView.hidden = YES;
        [self.attachView removeFromSuperview];
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
