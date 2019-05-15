//
//  HP_RequireMenuView.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#define kTitle  @"title"
#define kIsSele @"isSele"
#define kTitles @"titles"

#import "HP_RequireMenuView.h"
#import "ParamFile.h"
#import "RequireMenuHeaderView.h"
#import "RequireMenuCollectionViewCell.h"

@interface HP_RequireMenuView () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout> {
    UIView *bgView;
    UIView *conView;
    UICollectionView *menuCollection;
    NSMutableArray *dataArr;
    UIButton *btn_confirm;//确认按钮
    UIButton *cancelBtn;//取消按钮
}

@end

@implementation HP_RequireMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initCityMenuViewByFrame:(CGRect)frame
                                    arr:(NSMutableArray <NSDictionary*> *)conArr
                              seleBlock:(void (^)(NSMutableArray *arr))block {
    
    if (self = [super initWithFrame:frame]) {
        //初始化数据
        dataArr = conArr;
        self.seleBlock = block;
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
    
    CGFloat conView_hgt = self.height-kNavigationBarHeight*2-40;
    
    conView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, conView_hgt)];
    conView.backgroundColor = [UIColor whiteColor];
    [self addSubview:conView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 35);
    menuCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, conView.width, conView.height-50) collectionViewLayout:layout];
    menuCollection.delegate = self;
    menuCollection.dataSource = self;
    menuCollection.backgroundColor = [UIColor whiteColor];
    [menuCollection registerClass:[RequireMenuCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [menuCollection registerClass:RequireMenuHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [conView addSubview:menuCollection];
    
    btn_confirm = [ButtonTool createButtonWithTitle:@"确定"
                                                   titleColor:kOrangeColor
                                                    titleFont:Font(K_TEXT_FONT_14)
                                                    addTarget:self
                                                       action:@selector(confirmAction)];
    btn_confirm.frame = CGRectMake(kScreenWidth-50, menuCollection.bottom, 50, 50);
    
    [conView addSubview:btn_confirm];
    
    cancelBtn = [ButtonTool createButtonWithTitle:@"取消"
                                                 titleColor:k210Color
                                                  titleFont:Font(K_TEXT_FONT_14)
                                                  addTarget:self
                                                     action:@selector(removeSelf)];
    cancelBtn.frame = CGRectMake(btn_confirm.left-btn_confirm.width,
                                 btn_confirm.top,
                                 btn_confirm.width,
                                 btn_confirm.height);
    [conView addSubview:cancelBtn];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:dataArr[section][kTitles]];
    return itemArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RequireMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:dataArr[indexPath.section][kTitles]];
    
    NSMutableDictionary *itemDic = itemArr[indexPath.row];
    if ([itemDic[kIsSele] isEqualToString:@"0"]) {
        cell.label.textColor = k210Color;
        cell.label.layer.borderColor = k210Color.CGColor;
    }else{
        cell.label.textColor = kOrangeColor;
        cell.label.layer.borderColor = kOrangeColor.CGColor;
    }
    cell.label.text = itemDic[kTitle];
    [cell layoutIfNeeded];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:dataArr[indexPath.section][kTitles]];
    NSMutableDictionary *itemDic = itemArr[indexPath.row];
    NSString *title = itemDic[kTitle];
    CGSize size = [UITool sizeOfStr:title?title:@"" andFont:Font(K_TEXT_FONT_14) andMaxSize:CGSizeMake(kScreenWidth, 20) andLineBreakMode:NSLineBreakByCharWrapping];
    
    size = CGSizeMake(size.width+10, 30);
    return size;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RequireMenuHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        headerView.titleLabel.text = dataArr[indexPath.section][kTitle];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *itemArr = [NSMutableArray arrayWithArray:dataArr[indexPath.section][kTitles]];
    NSMutableDictionary *itemDic = itemArr[indexPath.item];
//    if (indexPath.item == 0) {
//        itemDic[kIsSele] = @"1";
//        if (itemArr.count > 1) {
//            for (int i = 1; i < itemArr.count; i++) {
//                NSMutableDictionary *tmpItem = itemArr[i];
//                tmpItem[kIsSele] = @"0";
//            }
//        }
//    }else{
//        NSMutableDictionary *tmpItem = itemArr[0];
//        tmpItem[kIsSele] = @"0";
//        if ([itemDic[kIsSele] isEqualToString:@"0"]) {
//            itemDic[kIsSele] = @"1";
//        }else{
//            itemDic[kIsSele] = @"0";
//        }
//    }
    
    if ([itemDic[kIsSele] isEqualToString:@"0"]) {
        itemDic[kIsSele] = @"1";
    }else{
        itemDic[kIsSele] = @"0";
    }
    TO_WEAK(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->menuCollection reloadItemsAtIndexPaths:@[indexPath]];
//        [strongSelf->menuCollection reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    });
}

# pragma mark -- 确定
- (void)confirmAction {
    if (self.seleBlock) {
        self.seleBlock(dataArr);
    }
    [self removeSelf];
}

- (void)removeSelf {
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [menuCollection reloadData];
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
//        strongSelf->conView.height = self.height-kNavigationBarHeight-40;
//        strongSelf->menuCollection.height =strongSelf-> conView.height;
//        strongSelf->btn_confirm.top = strongSelf->menuCollection.bottom;
//        strongSelf->cancelBtn.top = strongSelf->btn_confirm.top;
    }];
}

@end
