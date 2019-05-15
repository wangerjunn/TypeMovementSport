//
//  ElectronicCardViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ElectronicCardViewController.h"
//vc
#import "ExclusiveCardInfoViewController.h"//专属名片信息


//view
#import "ElectronicElementCardCell.h"
#import "UIColor+Hex.h"
#import "HW3DBannerView.h"
#import "ChooseCardTemplateView.h"
#import "ShowCardTemplateMenuView.h"
#import "ShareView.h"

//model
#import "ECardInfoModel.h"

@interface ElectronicCardViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource> {
        
        UIView *conView;
        UICollectionView *mainCollection;
        NSInteger curSele;//选择的模板样式
        
        NSMutableArray *conDataArr;
        
        NSString *generalTemplateImgUrl;//生成的模板图片链接
}


@property (nonatomic, strong) ChooseCardTemplateView *cardTemplateView;

@end

@implementation ElectronicCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"专属名片"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

#pragma mark -- 创建模板view
- (ChooseCardTemplateView *)cardTemplateView {
    if (!_cardTemplateView) {
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *tmp in _templateArr) {
            [arr addObject:tmp[@"url"]];
        }
        
        TO_WEAK(self, weakSelf);
        _cardTemplateView = [[ChooseCardTemplateView alloc]initTemplateViewByFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) conArr:arr block:^(NSInteger index) {
            TO_STRONG(weakSelf, strongSelf);
            strongSelf->curSele = index;
            
            [weakSelf saveMyCard];
        }];
        _cardTemplateView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    
    return _cardTemplateView;
}

- (void)createUI{
   
    [self startLoadingAnimation];
    
    if (self.templateId) {
        //已存在模板id
        [self infoItemTemplateFindAll];
    }else {
        //不存在模板,先获取模板显示模板
         [self getTemplateData];
    }
    
    conView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
    [self.view addSubview:conView];
    
    UILabel *titLab = [LabelTool createLableWithTextColor:k46Color font:Font(17)];
    titLab.frame = CGRectMake(0, 35, kScreenWidth, 20);
    titLab.text = @"选择呈现模块";
    titLab.textAlignment = NSTextAlignmentCenter;
    [conView addSubview:titLab];
    
    UILabel *titLab1 = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    titLab1.frame = CGRectMake(titLab.left, titLab.bottom+10, titLab.width, titLab.height);
    titLab1.text = @"点击选择您想显示的内容";
    titLab1.textAlignment = NSTextAlignmentCenter;
    [conView addSubview:titLab1];
    
    UILabel *titLab2 = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    titLab2.frame = CGRectMake(titLab.left, titLab1.bottom, titLab.width, titLab.height);
    titLab2.text = @"基本信息为必选项";
    titLab2.textAlignment = NSTextAlignmentCenter;
    [conView addSubview:titLab2];
    
    UIButton *btn_confirm = [ButtonTool createButtonWithTitle:@"确定" titleColor:[UIColor whiteColor] titleFont:Font(K_TEXT_FONT_16) addTarget:self action:@selector(confirmShowContent)];
    
    btn_confirm.frame = CGRectMake(10, conView.height - 45  - 40, kScreenWidth - 20, 45);
    btn_confirm.backgroundColor = kOrangeColor;
    btn_confirm.layer.masksToBounds = YES;
    btn_confirm.layer.cornerRadius = 5;
    [conView addSubview:btn_confirm];
    
    UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
    lay.scrollDirection =  UICollectionViewScrollDirectionVertical;
    lay.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    lay.minimumLineSpacing = 10;
    lay.minimumInteritemSpacing = 10;
    
    mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, titLab2.bottom+10 , kScreenWidth, btn_confirm.top - titLab2.bottom - 10) collectionViewLayout:lay];
    mainCollection.delegate = self;
    mainCollection.dataSource = self;
    mainCollection.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0,*)) {
        mainCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //注册Cell，必须要有
    [conView addSubview:mainCollection];
    //注册Cell，必须要有
    [mainCollection registerClass:[ElectronicElementCardCell class] forCellWithReuseIdentifier:@"cardCell"];
    
    conDataArr = [NSMutableArray array];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (conDataArr.count > 6) {
        return conDataArr.count - 5;
    }
    return conDataArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier=@"cardCell";
    
    ElectronicElementCardCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    [cell setCornerRadius:5];
    
    ECardInfoModel *model;
    
    cell.priceLab.text = @"";

    if (indexPath.item == 0) {
        model = [[ECardInfoModel alloc]init];
        model.name = @"基本信息";
        model.isMust = YES;
        model.isSelect = YES;
        cell.priceLab.text = @"(必选)";
    }else {
        if (conDataArr.count > 6) {
            model = conDataArr[indexPath.item+5];
        }else {
            model = conDataArr[indexPath.item];
        }
        
    }
    
    cell.titLab.text = model.name;
    
    if (!model.isSelect) {
        cell.bgView.hidden = YES;
        cell.titLab.textColor = k75Color;
        cell.priceLab.textColor = k75Color;
    }else {
        cell.bgView.hidden = NO;
        cell.titLab.textColor = [UIColor whiteColor];
        cell.priceLab.textColor = [UIColor whiteColor];
    }

    return cell;
}
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 30) / 2.0, (kScreenWidth/2.0 ) / 2.0 );
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 != indexPath.item) {
        ECardInfoModel *model;
        if (conDataArr.count > 6) {
            model = conDataArr[indexPath.item+5];
        }else {
            model = conDataArr[indexPath.item];
        }
        
        model.isSelect = !model.isSelect;
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->mainCollection reloadItemsAtIndexPaths:@[indexPath]];
        });
        
    }
    
}

# pragma mark -- 确认
- (void)confirmShowContent {
    if (conDataArr.count < 1) {
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *mustArr = [NSMutableArray array];//必须项
    for (ECardInfoModel *model in conDataArr) {
        if (model.isSelect || model.isMust) {
            
            if (model.isMust) {
                [mustArr addObject:model];
            }else {
                [arr addObject:model];
            }
            
        }
    }
    ExclusiveCardInfoViewController *exclusiveCard = [[ExclusiveCardInfoViewController alloc]init];
    exclusiveCard.seleElementsArr = arr;
    exclusiveCard.mustSeleArr = mustArr;
    [self.navigationController pushViewController:exclusiveCard animated:YES];
}

#pragma mark -- 获取电子背景模板
- (void)getTemplateData {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kBackgroundTemplateFindAll parms:nil viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            /*
             {
                 id = 2;
                 isSelect = 0;
                 url = "https://xdh.xingdongsport.com/template/card_white.png";
             }
             */
            strongSelf->_templateArr = list;
            if (list.count > 0 && !weakSelf.templateId) {
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.cardTemplateView];
            }
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 获取模板下的所有item(不包含必填项,必填项请手动加入)
- (void)infoItemTemplateFindAll {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kInfoItemTemplateFindAll parms:nil viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            for (NSDictionary *tmp in list) {
                ECardInfoModel *model = [[ECardInfoModel alloc] initWithDictionary:tmp error:nil];
                
                if (![model.name isEqualToString:@"培训体系认证"]) {
                     [strongSelf->conDataArr addObject:model];
                }
               
            }
        
            [strongSelf->mainCollection reloadData];
            
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        [weakSelf stopLoadingAnimation];
    }];
    
}

#pragma mark -- 第一次选择模板时需要先保存模板信息
- (void)saveMyCard {
    
    NSDictionary *dict = _templateArr[curSele];
    
    NSDictionary *para = @{
                           @"backgroundTemplateId":dict[@"id"]
                           };
    
    [WebRequest PostWithUrlString:kMyCardSave parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_WEAK(self, weakSelf);
        if ([remindMsg integerValue] == 999) {
            [weakSelf infoItemTemplateFindAll];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
    } failed:^(NSError *error) {
    }];
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
