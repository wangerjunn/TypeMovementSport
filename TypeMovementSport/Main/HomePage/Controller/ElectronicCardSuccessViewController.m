//
//  ElectronicCardSuccessViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/21.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "ElectronicCardSuccessViewController.h"
#import "ElectronicCardViewController.h"

//view
#import "ShowCardTemplateMenuView.h"
#import "ChooseCardTemplateView.h"
#import "ShareView.h"

@interface ElectronicCardSuccessViewController ()

@property (nonatomic, strong) UIImageView *electronicCardImg;
@property (nonatomic, strong) ChooseCardTemplateView *cardTemplateView;
@property (nonatomic, strong) ShowCardTemplateMenuView *menuView;

@end

@implementation ElectronicCardSuccessViewController

- (void)goBack {
     [self.cardTemplateView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 显示菜单view
- (void)showMenuView {
    
    TO_WEAK(self, weakSelf);
    [_menuView removeFromSuperview];
    _menuView = nil;
    
    [self.cardTemplateView removeFromSuperview];
    if (!_menuView) {
        _menuView = [[ShowCardTemplateMenuView alloc]initMenuViewByFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) block:^(NSInteger index) {
            
            TO_STRONG(weakSelf, strongSelf);
            switch (index) {
                case 1:{
                    //分享
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showWithStatus:@"加载中..."];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strongSelf->_generalTemplateImgUrl]];
                        ShareView *shareView = [[ShareView alloc] initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:nil shareTitle:@"分享好友" shareDesp:kShareDefaultText shareLogo:kShareDefaultLogo shareUrl:data];
                        [shareView show];
                        [SVProgressHUD dismiss];
                    });
                    
                }
                    break;
                case 2:{
                    //展示设置，显示模块view
                    if (strongSelf->_templateArr.count > 0) {
                        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.cardTemplateView];
                    }else {
                        [weakSelf getTemplateData];
                    }
                }
                    break;
                case 3:{
                    //修改展示信息
                    ElectronicCardViewController *electronicCard = [[ElectronicCardViewController alloc] init];
                    electronicCard.templateArr = strongSelf->_templateArr;
                    electronicCard.templateId = self.templateId;
                    [weakSelf.navigationController pushViewController:electronicCard animated:YES];
                }
                    break;
                default:
                    break;
            }
        }];
        _menuView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_menuView];
    }
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"专属名片"];
    [self setNavItemWithImage:@"HP_card_menu"
                  imageHightLight:@"HP_card_menu"
                           isLeft:NO
                           target:self
                           action:@selector(showMenuView)];
    
    [self.view addSubview:self.electronicCardImg];
    
    if (self.templateArr.count < 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getTemplateData];
        });
    }
}

#pragma mark -- 已经生成的电子名片
- (UIImageView *)electronicCardImg {
    if (!_electronicCardImg) {
        CGFloat coorX = FIT_SCREEN_WIDTH(5);
        _electronicCardImg = [[UIImageView alloc] initWithFrame:CGRectMake(coorX, FIT_SCREEN_HEIGHT(25), kScreenWidth-coorX*2, kScreenHeight - kNavigationBarHeight - FIT_SCREEN_HEIGHT(30))];
        _electronicCardImg.contentMode = UIViewContentModeScaleAspectFit;
        [_electronicCardImg sd_setImageWithURL:[NSURL URLWithString:self.generalTemplateImgUrl] placeholderImage:[UIImage imageNamed:holdImage]];
    }
    
    
    return _electronicCardImg;
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
            [weakSelf saveMyCard:index];
        }];
        
        _cardTemplateView.clickBgViewBlock = ^{
            [weakSelf removeCardTemplateView];
        };
        _cardTemplateView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    
    return _cardTemplateView;
}

- (void)removeCardTemplateView {
    [_cardTemplateView removeFromSuperview];
    _cardTemplateView = nil;
}

#pragma mark -- 保存模板信息
- (void)saveMyCard:(NSInteger)index {
    
    if (_templateArr.count < index) {
        return;
    }
    NSDictionary *dict = _templateArr[index];
    
    if (self.templateId && [dict[@"id"] isEqual:self.templateId]) {
        return;
    }
    NSDictionary *para = @{
                           @"backgroundTemplateId":dict[@"id"]
                           };
    
    [WebRequest PostWithUrlString:kMyCardSave parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_WEAK(self, weakSelf);
        if ([remindMsg integerValue] == 999) {
            
            NSDictionary *detailDic = dict[@"detail"];
            TO_STRONG(weakSelf, strongSelf);
            //更新图片
            weakSelf.templateId = detailDic[@"backgroundTemplate"][@"id"];
            weakSelf.generalTemplateImgUrl = detailDic[@"myCardUrl"];
            [strongSelf->_electronicCardImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.generalTemplateImgUrl] placeholderImage:[UIImage imageNamed:holdImage]];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
    } failed:^(NSError *error) {
    }];
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
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        [weakSelf stopLoadingAnimation];
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
