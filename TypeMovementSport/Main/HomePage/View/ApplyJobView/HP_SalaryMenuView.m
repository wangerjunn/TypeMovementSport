//
//  HP_SalaryMenuView.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "HP_SalaryMenuView.h"
#import "ParamFile.h"

@interface HP_SalaryMenuView () <
UITableViewDelegate,
UITableViewDataSource> {
    UIView *bgView;
    UIView *conView;
    UITableView *menuTable;
    NSInteger seleIndex;
    NSArray *dataArr;
}

@end
@implementation HP_SalaryMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initCityMenuViewByFrame:(CGRect)frame
                                    arr:(NSArray <NSString*> *)conArr
                            seleContent:(NSString *)seleContent
                              seleBlock:(void (^)(NSString *seleCon))block {
    
    if (self = [super initWithFrame:frame]) {
        
        //初始化数据
        dataArr = conArr;
        seleIndex = -1;
        self.seleBlock = block;
        if (seleContent && [dataArr containsObject:seleContent]) {
            seleIndex = [dataArr indexOfObject:seleContent];
        }
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
    [bgView addGestureRecognizer:tap];
    [self addSubview:bgView];
    
//    CGFloat conView_hgt = self.height-kNavigationBarHeight-40;
//    if (dataArr.count * 45 < conView_hgt) {
//        conView_hgt = dataArr.count * 45;
//    }
    conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0)];
    conView.backgroundColor = [UIColor whiteColor];
    [self addSubview:conView];
    
    menuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, conView.width,
                                                                 conView.height)
                                                style:UITableViewStylePlain];
    menuTable.delegate = self;
    menuTable.dataSource = self;
    menuTable.tag = 100;
    menuTable.backgroundColor = [UIColor whiteColor];
    menuTable.showsVerticalScrollIndicator = NO;
    menuTable.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0,*)) {
        menuTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        menuTable.estimatedRowHeight = 0;
        menuTable.estimatedSectionHeaderHeight = 0;
        menuTable.estimatedSectionFooterHeight = 0;
    }
    
    [conView addSubview:menuTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(14)];
        label.frame = CGRectMake(15, 0, menuTable.width-15, 45);
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
    if (indexPath.row == seleIndex) {
        icon.hidden = NO;
        label.textColor = kOrangeColor;
        label.frame = CGRectMake(icon.right+15, 0, menuTable.width-icon.right-15, 45);
        
    }else{
        label.textColor = k46Color;
        label.frame = CGRectMake(15, 0, menuTable.width-15, 45);
    }
    
    label.text = dataArr[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        //点击右侧菜单内容
        if (seleIndex == indexPath.row) {
            return;
        }
        
        seleIndex = indexPath.row;
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:99];
        icon.hidden = NO;
        label.textColor = kOrangeColor;
        label.left = icon.right + 15;
    
        if (self.seleBlock) {
            self.seleBlock(dataArr[indexPath.row]);
        }
        
        [self removeSelf];
    
}

- (void)removeSelf {
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        strongSelf->conView.height = 0;
        strongSelf->menuTable.height =strongSelf-> conView.height;
//        strongSelf->conView.transform = CGAffineTransformMakeTranslation
//        (0, -(strongSelf->conView.height));
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [menuTable reloadData];
    TO_WEAK(self, weakSelf);
    CGFloat conView_hgt = self.height-kNavigationBarHeight-40;
    if (dataArr.count * 45 < conView_hgt) {
        conView_hgt = dataArr.count * 45;
    }
    [UIView animateWithDuration:0.5 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        strongSelf->conView.height = conView_hgt;
        strongSelf->menuTable.height = conView_hgt;
//        strongSelf->conView.transform = CGAffineTransformMakeTranslation
//        (0, strongSelf->conView.height);
    }];
}

@end
