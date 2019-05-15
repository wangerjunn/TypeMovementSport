//
//  DiscountCouponViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/2.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "DiscountCouponViewController.h"

//view
#import "DiscountCouponCell.h"
#import "EmptyView.h"
#import "CourseHeaderCommonView.h"

@interface DiscountCouponViewController () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *couponTable;
        NSMutableArray *dataArr;
        NSMutableArray *notAvailableArr;//不可用数组
        NSMutableArray *usedArr;//已使用数组
        UIView *_topBtnLine;
        NSArray *btnTitles;//按钮数组
        NSInteger curBtnIndex;//当前按钮下标，默认0
}

@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation DiscountCouponViewController

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hiddenBackBtn];
    [self setNavBarColor:kViewBgColor];
    [self createUI];
}

- (void)createUI {
    
    dataArr = [NSMutableArray array];
    notAvailableArr = [NSMutableArray array];
    usedArr = [NSMutableArray array];
    curBtnIndex = 0;
    
    //topView
    UIView *topView = [self tableViewHeaderView];
    [self.view addSubview:topView];
    couponTable = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.bottom, kScreenWidth, kScreenHeight-kNavigationBarHeight - topView.bottom) style:UITableViewStyleGrouped];
    couponTable.delegate = self;
    couponTable.dataSource = self;
    if (@available(iOS 11.0,*)) {
        couponTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        couponTable.estimatedRowHeight = 0;
        couponTable.estimatedSectionHeaderHeight = 0;
        couponTable.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:couponTable];
    couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    couponTable.backgroundColor = kViewBgColor;
    couponTable.sectionFooterHeight = 0.001;
    couponTable.sectionHeaderHeight = 10;
    
    [self startLoadingAnimation];
    [self getCouponData];
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:CGRectMake(0, 60, couponTable.width, couponTable.height-60) placeholderImage:nil placeholderText:nil];
        [couponTable addSubview:_emptyView];
    }
    
    return _emptyView;
}


- (UIView *)tableViewHeaderView {
    
    UIView *headerView = [[UIView alloc] init];
    
    TO_WEAK(self, weakSelf);
    CourseHeaderCommonView *couponHeadView = [[CourseHeaderCommonView alloc] initHeaderCommonViewByFrame:CGRectMake(0, 0, kScreenWidth, 60) EnglishTitle:@"Coupon" conTitle:@"优惠券" block:^{
        [weakSelf cancel];
    }];
    
    [headerView addSubview:couponHeadView];
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, couponHeadView.bottom);
    
    UIView *btnView = [self createBtnView];
    btnView.origin = CGPointMake(0, couponHeadView.bottom);
    [headerView addSubview:btnView];
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, btnView.bottom);
    headerView.backgroundColor = kViewBgColor;
    return headerView;
}

- (UIView *)createBtnView {
   
    UIView *btnView = [[UIView alloc] init];
    
    btnTitles = @[@"可用优惠券",@"不可用优惠券"];
    if (![_orderID isNotEmpty]) {
        btnTitles = @[@"可用的",@"已使用",@"已过期"];
    }
    CGFloat wdtBtn = [UITool sizeOfStr:btnTitles.lastObject andFont:Font(13) andMaxSize:CGSizeMake(kScreenWidth, 100) andLineBreakMode:NSLineBreakByCharWrapping].width;
    CGFloat coorX_btn = 20;
    for (int i = 0; i < btnTitles.count; i++) {
        UIButton *btn = [ButtonTool createButtonWithTitle:btnTitles[i]
                                               titleColor:k46Color
                                                titleFont:Font(13)
                                                addTarget:self
                                                   action:@selector(chooseCouponType:)];
        
        btn.tag = 100+i;
        [btn setTitleColor:kOrangeColor forState:UIControlStateSelected];
        if (i == curBtnIndex) {
            btn.selected = YES;
        }
        
        btn.frame = CGRectMake(coorX_btn, 10, wdtBtn, 20);
        [btnView addSubview:btn];
        
        coorX_btn += wdtBtn + 25;
    }
    
    _topBtnLine = [[UIView alloc] initWithFrame:CGRectMake(20+4, 20+15, wdtBtn-8, 3)];
    _topBtnLine.backgroundColor = kOrangeColor;
    [btnView addSubview:_topBtnLine];
    
    btnView.size = CGSizeMake(kScreenWidth, 45);
    return btnView;
}

#pragma mark -- 选择优惠券类型
- (void)chooseCouponType:(UIButton *)btn {
    
    if (curBtnIndex == (btn.tag - 100)) {
        return;
    }
    for (int i = 0; i < btnTitles.count; i++) {
        UIButton *tmpBtn = (UIButton *)[btn.superview viewWithTag:100+i];
        tmpBtn.selected = NO;
    }
    _topBtnLine.left = btn.left + 4;
    
    btn.selected = YES;
    
    curBtnIndex = (btn.tag - 100);
   
    if ([_orderID isNotEmpty]) {
        //订单优惠券
        if (curBtnIndex == 0) {
            self.emptyView.hidden = !(dataArr.count < 1);
        }else {
            self.emptyView.hidden = !(notAvailableArr.count < 1);
        }
    }else {//我的优惠券
        switch (curBtnIndex) {
            case 0:{
                //可用优惠券
                self.emptyView.hidden = !(dataArr.count < 1);
            }
                break;
            case 1:{
                //已使用优惠券
                self.emptyView.hidden = !(usedArr.count < 1);
            }
                break;
            case 2:{
                //已过期优惠券
                self.emptyView.hidden = !(notAvailableArr.count < 1);
            }
                break;
                
            default:
                break;
        }
    }
    
    [couponTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponModel *model;
    
    if ([_orderID isNotEmpty]) {
        //订单优惠券
        if (curBtnIndex == 0) {
            model = dataArr[indexPath.section];
        }else {
            model = notAvailableArr[indexPath.section];
        }
    }else {//我的优惠券
        switch (curBtnIndex) {
            case 0:{
                //可用优惠券
                model = dataArr[indexPath.section];
            }
                break;
            case 1:{
                //已使用优惠券
                model = usedArr[indexPath.section];
            }
                break;
            case 2:{
                //已过期优惠券
                model = notAvailableArr[indexPath.section];
            }
                break;
                
            default:
                break;
        }
    }
    
    return 90 + model.conditionsHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    if ([_orderID isNotEmpty]) {
        //订单优惠券
        if (curBtnIndex != 0) {
            return notAvailableArr.count;
        }
    }else {//我的优惠券
        switch (curBtnIndex) {
            case 1:{
                //已使用优惠券
                return usedArr.count;
            }case 2:{
                //已过期优惠券
                return notAvailableArr.count;
            }
                
            default:
                break;
        }
    }
    
    
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell";
    DiscountCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[DiscountCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    CouponModel *model;
    if ([_orderID isNotEmpty]) {
        //订单优惠券
        if (curBtnIndex == 0) {
            model = dataArr[indexPath.section];
        }else {
            model = notAvailableArr[indexPath.section];
        }
    }else {//我的优惠券
        switch (curBtnIndex) {
            case 0:{
                //可用优惠券
                model = dataArr[indexPath.section];
            }
                break;
            case 1:{
                //已使用优惠券
                model = usedArr[indexPath.section];
            }
                break;
            case 2:{
                //已过期优惠券
                model = notAvailableArr[indexPath.section];
            }
                break;
                
            default:
                break;
        }
    }
    
    cell.model  = model;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.orderID && self.orderID.length > 0 && curBtnIndex == 0) {
        if (dataArr.count > 0) {
            CouponModel *model = dataArr[indexPath.section];
            if (model.status != 0) {
                return;
            }
            if (self.SeleCouponBlock) {
                self.SeleCouponBlock(model);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -- 获取优惠券
- (void)getCouponData {
    
    TO_WEAK(self, weakSelf);
    
    NSString *url = kUserCouponFindAll;
    NSDictionary *para;
    if (self.orderID) {
        //根据订单获取可用和不可有优惠券列表
        url = kUserCouponFindAllByOrder;
        para = @{
                 @"orderId":_orderID
                 };
    }
    [WebRequest PostWithUrlString:url parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            /*
             "usedList": [],
             "availableList": [
                 {
                 "coupon": {
                     "id": 1,
                     "name": "10元优惠券",
                     "createTime": 1530374400000,
                     "startValidTime": 1530374400000,
                     "expireTime": 1561910400000,
                     "type": "CASH_COUPON",
                     "conditions": null,
                     "content": "1000",
                     "remark": "<p>1、每次服务限使用一张；</p>\n<p>2、红包可用于海福兔服务专区内容抵扣；</p>\n<p>3、最终解释权归海福兔健康所有</p>"
                 },
                 "userCoupon": {
                     "id": 1,
                     "useTime": null,
                     "receiveTime": null
                 }
                 }
             ],
             "expireList": []
             */
            NSDictionary *list = dict[@"list"];
            
            //获取订单优惠券
            //可用的优惠券
            NSArray *availableList = list[@"availableList"];
            
            //可用优惠券
            for (NSDictionary *tmp in availableList) {
                @autoreleasepool {
                    CouponModel *model = [[CouponModel alloc] initWithDictionary:tmp error:nil];
                    model.status = 0;
                    [strongSelf->dataArr addObject:model];
                }
                
            }
            
            //不可用的优惠券
            NSArray *notAvailable = list[@"notAvailableList"];
            
            //已使用
            NSArray *usedListArray = list[@"usedList"];
            
            if ([url isEqualToString:kUserCouponFindAll]) {
                //获取我的优惠券
                //已过期
                notAvailable = list[@"expireList"];
            }
            
            //已使用
            for (NSDictionary *tmp in usedListArray) {
                CouponModel *model = [[CouponModel alloc] initWithDictionary:tmp error:nil];
                model.status = 2;
                [strongSelf->usedArr addObject:model];
                
            }
            
            //已过期
            for (NSDictionary *tmp in notAvailable) {
                CouponModel *model = [[CouponModel alloc] initWithDictionary:tmp error:nil];
                model.status = 1;
                [strongSelf->notAvailableArr addObject:model];
            }
            
            weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);

            [strongSelf->couponTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
         [weakSelf stopLoadingAnimation];
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);

    }];
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
