//
//  HP_couponView.m
//  TypeMovementSport
//
//  Created by XDH on 2019/3/17.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "HP_couponView.h"
#import "HP_couponCell.h"

@interface HP_couponView () <
    UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, copy) NSArray *couponDataArr;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *couponTable;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HP_couponView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initCouponViewByData:(NSArray *)couponArr {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        self.couponDataArr = couponArr;
        self.backgroundColor = [UIColor clearColor];
        [self createViews];
    }
    
    return self;
}

- (void)createViews {
    _bgView = [[UIView alloc] initWithFrame:self.bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    UIImageView *couponBgView = [[UIImageView alloc]
                                 initWithImage:[UIImage imageNamed:@"HP_couponBg"]];
    
    CGFloat wdtBg = 300;
    CGFloat hgtBg = 440;
    couponBgView.userInteractionEnabled = YES;
    couponBgView.frame = CGRectMake(_bgView.width/2.0 - wdtBg/2.0,
                                    _bgView.height/2.0 - hgtBg/2.0, wdtBg, hgtBg);
    [_bgView addSubview:couponBgView];
    
    
    self.couponTable = [[UITableView alloc] initWithFrame:
                        CGRectMake(0, couponBgView.height - 200,
                                   couponBgView.width, 180)
                                                    style:UITableViewStyleGrouped];
    self.couponTable.delegate = self;
    self.couponTable.dataSource = self;
    self.couponTable.backgroundColor = [UIColor clearColor];
    self.couponTable.rowHeight = 80;
    self.couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponTable.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0,*)) {
        _couponTable.estimatedRowHeight = 0;
        _couponTable.estimatedSectionHeaderHeight = 0;
        _couponTable.estimatedSectionFooterHeight = 0;
        _couponTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [couponBgView addSubview:_couponTable];
    
    UIButton *cancelBtn = [ButtonTool createButtonWithImageName:@"HP_couponClose"
                                                      addTarget:self
                                                         action:@selector(removeSelf)];
    
    CGFloat cancelWdt = 55;
    cancelBtn.frame = CGRectMake(_bgView.width/2.0 - cancelWdt/2.0,
                                 couponBgView.bottom + 20, cancelWdt, cancelWdt);
    [_bgView addSubview:cancelBtn];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.couponDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    
    HP_couponCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[HP_couponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    /*
     "availableList": [
     {
         conditions = "{\"min\": 1000}";
         content = 300;
         createTime = 1530374400000;
         expireTime = 1866545976000;
         id = 31;
         name = "3\U5143\U4f18\U60e0\U5238";
         receiveTime = 1551433492765;
         remark = "\U56fd\U804c\U4e13\U4eab";
         startValidTime = 1530374400000;
         type = "CASH_COUPON";
         useTime = "<null>";
     }
     
     ]
     */
    
    NSDictionary *dic = self.couponDataArr[indexPath.section];
    cell.couponTitleLabel.text = [NSString stringWithFormat:@"%@",dic[@"remark"]?dic[@"remark"]:@""];
    cell.couponConLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]?dic[@"name"]:@""];
    
    NSString *createTime = [self switchTimeByTimeStamp:[NSString stringWithFormat:@"%@",dic[@"createTime"]]];
    NSString *expireTime = [self switchTimeByTimeStamp:[NSString stringWithFormat:@"%@",dic[@"expireTime"]]];
    cell.couponValidityLabel.text = [NSString stringWithFormat:@"有效期\n%@\n-\n%@",createTime,expireTime];
    
    return cell;
}

- (NSString *)switchTimeByTimeStamp:(NSString *)timeStamp {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
    }
   
    
    NSString *timeStr = @"";
    if ([timeStamp isNotEmpty]) {
        NSTimeInterval createInterval = [timeStamp floatValue] / 1000;
        NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:createInterval];
        timeStr =  [_dateFormatter stringFromDate:createDate];
        
        
    }
    
    return timeStr;
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:.8];
    }];
}

- (void)removeSelf {
    
    [self removeFromSuperview];
    
}

@end
