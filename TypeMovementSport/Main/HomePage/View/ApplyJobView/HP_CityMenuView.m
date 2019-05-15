//
//  HP_CityMenuView.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//
#define kTitle @"title"
#define kData @"data"

#import "HP_CityMenuView.h"
#import "ParamFile.h"

@interface HP_CityMenuView () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UIView *bgView;
        UIView *conView;
        UITableView *leftMenuTable;
        UITableView *rightMenuTable;
        NSInteger leftSeleIndex;
        NSInteger rightSeleIndex;//选择下标
        NSArray *dataArr;
}

@end

@implementation HP_CityMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) initCityMenuViewByFrame:(CGRect)frame seleIndex:(NSIndexPath *)seleIndex seleBlock:(void (^)(NSString *, NSIndexPath *))block {
    if (self = [super initWithFrame:frame]) {
        
        //初始化数据
        leftSeleIndex = 0;
        rightSeleIndex = -1;
        if (seleIndex) {
            leftSeleIndex = seleIndex.section;
            rightSeleIndex = seleIndex.row;
        }
        
        self.seleBlock = block;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    NSString *str_path = [[NSBundle mainBundle] pathForResource:@"address_data_new2" ofType:@"plist"];
    dataArr = [NSArray arrayWithContentsOfFile:str_path];
    
    self.backgroundColor = [UIColor clearColor];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
    [bgView addGestureRecognizer:tap];
    [self addSubview:bgView];
    
//    CGFloat conView_hgt = self.height-kNavigationBarHeight-40;
    conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    conView.backgroundColor = [UIColor whiteColor];
    [self addSubview:conView];
    
    leftMenuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FIT_SCREEN_WIDTH(120),
                                                                 conView.height)
                                                style:UITableViewStylePlain];
    leftMenuTable.delegate = self;
    leftMenuTable.dataSource = self;
    leftMenuTable.tag = 100;
    leftMenuTable.backgroundColor = [UIColor whiteColor];
    leftMenuTable.showsVerticalScrollIndicator = NO;
    leftMenuTable.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0,*)) {
        leftMenuTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        leftMenuTable.estimatedRowHeight = 0;
        leftMenuTable.estimatedSectionHeaderHeight = 0;
        leftMenuTable.estimatedSectionFooterHeight = 0;
    }
    
    [conView addSubview:leftMenuTable];
    
    rightMenuTable = [[UITableView alloc]initWithFrame:CGRectMake(leftMenuTable.right,
                                                                  leftMenuTable.top,
                                                                  self.height-leftMenuTable.right,
                                                                  leftMenuTable.height)
                                                 style:UITableViewStylePlain];
    rightMenuTable.delegate = self;
    rightMenuTable.dataSource = self;
    rightMenuTable.tag = 101;
    rightMenuTable.backgroundColor = [UIColor whiteColor];
    rightMenuTable.showsVerticalScrollIndicator = NO;
    rightMenuTable.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0,*)) {
        rightMenuTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        rightMenuTable.estimatedRowHeight = 0;
        rightMenuTable.estimatedSectionHeaderHeight = 0;
        rightMenuTable.estimatedSectionFooterHeight = 0;
    }
    
    [conView addSubview:rightMenuTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        //左侧菜单
        return dataArr.count;
    }
    
    if (dataArr.count < 1) {
        return 0;
    }
    
    NSDictionary *dict;
    
    if (leftSeleIndex == -1) {
        dict = dataArr[0];
    }else {
        dict = dataArr[leftSeleIndex];
    }
    
    NSArray *arr = dict[kData];
    
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.textLabel.font = Font(14);
        }
        
        if (indexPath.row == leftSeleIndex) {
            cell.contentView.backgroundColor = UIColorFromRGB(0xF7F7F7);
            cell.textLabel.textColor = kOrangeColor;
        }else{
            cell.textLabel.textColor = k46Color;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.frame = CGRectMake(15, 0, leftMenuTable.width-15, 45);
        
        NSDictionary *dict = dataArr[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[kTitle]];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(14)];
        label.frame = CGRectMake(15, 0, rightMenuTable.width-15, 45);
        label.tag = 99;
        [cell.contentView addSubview:label];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        CGFloat wdt = 15;
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 45/2.0-wdt/2.0, wdt, wdt)];
        icon.image = [UIImage imageNamed:@"general_list_selected"];
        icon.tag = 100;
        icon.hidden = YES;
        [cell.contentView addSubview:icon];
        cell.contentView.backgroundColor = UIColorFromRGB(0xF7F7F7);
    }
    
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:99];
    icon.hidden = YES;
    if (indexPath.row == rightSeleIndex) {
        icon.hidden = NO;
        label.textColor = kOrangeColor;
        label.frame = CGRectMake(icon.right+15, 0, rightMenuTable.width-icon.right-15, 45);
        
    }else{
        label.textColor = k46Color;
        label.frame = CGRectMake(15, 0, rightMenuTable.width-15, 45);
    }
    
    NSDictionary *dict;
    if (leftSeleIndex == -1) {
        dict = dataArr[0];
    }else {
        dict = dataArr[leftSeleIndex];
    }
    
    NSArray *arr = dict[kData];
    
    NSDictionary *tmp = arr[indexPath.row];
    label.text = [NSString stringWithFormat:@"%@",tmp[kTitle]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        //点击左侧菜单，刷新右侧数据
        if (leftSeleIndex == indexPath.row) {
            return;
        }
        
        leftSeleIndex = indexPath.row;
        
        [leftMenuTable reloadData];
        rightSeleIndex = -1;
        [rightMenuTable reloadData];
    }else {
        //点击右侧菜单内容
        if (rightSeleIndex == indexPath.row) {
            return;
        }
        
        rightSeleIndex = indexPath.row;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:99];
        icon.hidden = NO;
        label.textColor = kOrangeColor;
        label.left = icon.right + 15;
        NSArray *arr = dataArr[leftSeleIndex][kData];
        
        NSDictionary *cityDic = arr[indexPath.row];
        NSString *city = cityDic[kTitle];
        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        if (self.seleBlock) {
            self.seleBlock(city,[NSIndexPath indexPathForRow:rightSeleIndex inSection:leftSeleIndex]);
        }
        
        [self removeSelf];
    }
}

- (void)removeSelf {
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        strongSelf->conView.height = 0;
        strongSelf->leftMenuTable.height =strongSelf-> conView.height;
        strongSelf->rightMenuTable.height = strongSelf->leftMenuTable.height;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [leftMenuTable reloadData];
    [rightMenuTable reloadData];
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        
        strongSelf->conView.height = self.height-kNavigationBarHeight-40;
        strongSelf->leftMenuTable.height =strongSelf-> conView.height;
        strongSelf->rightMenuTable.height = strongSelf->leftMenuTable.height;
    }];
}

@end


































