//
//  IncreaseVideoPayOrFreeView.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/3.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "IncreaseVideoPayOrFreeView.h"
#import "IncreaseVideoPayOrFreeCell.h"

@interface IncreaseVideoPayOrFreeView () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *listTable;
        NSArray *_dataArr;
        BOOL _isFree;//是否是免费视频
}

@end
@implementation IncreaseVideoPayOrFreeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initViewByFrame:(CGRect)frame dataArr:(NSArray *)dataArr isFreeTypeVideo:(BOOL)isFree {
    if (self = [super initWithFrame:frame]) {
        _dataArr = dataArr;
        _isFree = isFree;
        
        self.backgroundColor = kViewBgColor;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    listTable = [[UITableView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(20), FIT_SCREEN_WIDTH(20), self.width-FIT_SCREEN_WIDTH(40), self.height - FIT_SCREEN_WIDTH(20)) style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.backgroundColor = kViewBgColor;
    if (@available(iOS 11.0,*)) {
        listTable.estimatedRowHeight = 0;
        listTable.estimatedSectionHeaderHeight = 0;
        listTable.estimatedSectionFooterHeight = 0;
        listTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    listTable.rowHeight = FIT_SCREEN_HEIGHT(60);
    listTable.tableHeaderView = [self tableviewHeaderView];
    [self addSubview:listTable];
}

- (UIView *)tableviewHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, listTable.width, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setCornerOnTop:15];
    UIImageView *bgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, headerView.height)];
    
    bgIcon.backgroundColor = kOrangeColor;
    
    [headerView addSubview:bgIcon];
    
    
    CGFloat wdtBtn = 25;    
    UIButton *cancelBtn = [ButtonTool createButtonWithImageName:@"general_cancel" addTarget:self action:@selector(dismissView)];
    cancelBtn.frame = CGRectMake(headerView.width - wdtBtn - 10, headerView.height/2.0-wdtBtn/2.0, wdtBtn, wdtBtn);
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [headerView addSubview:cancelBtn];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    IncreaseVideoPayOrFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[IncreaseVideoPayOrFreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    return cell;
}

- (void)dismissView {
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view {
    if (!self.superview) {
        [view addSubview:self];
    }
}

@end
