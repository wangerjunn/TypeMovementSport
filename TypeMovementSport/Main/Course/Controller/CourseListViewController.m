//
//  CourseListViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "CourseListViewController.h"
#import "PlayerVideoViewController.h"
#import "OrderPayViewController.h"

//view
#import "Course_SecondLevelCell.h"
#import "Course_thirdDataView.h"
#import "AppDelegate.h"
#import "ShareView.h"
#import "CourseHeaderCommonView.h"
#import "EmptyView.h"
#import "PurchaseListView.h"

//model
#import "QuestionModel.h"
#import "VideoModel.h"
#import "UserModel.h"

@interface CourseListViewController () <UICollectionViewDelegate,
    UICollectionViewDataSource> {
        UICollectionView *courseCollection;
        NSMutableArray *_dataArr;
        Course_thirdDataView *videoListView;
//        BOOL isPurchase;//是否购买，支付订单之后回调
}

@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) QuestionModel *questionModel;
@end

@implementation CourseListViewController

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavBarColor:kViewBgColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenBackBtn];
    
    _dataArr = [NSMutableArray array];
    
    [self createUI];
    
    [self startLoadingAnimation];
    [self getVideoList];
}

- (void)setModel:(QuestionModel *)model {
    _questionModel = model;
}

- (void)createUI {
    
    TO_WEAK(self, weakSelf);
    CourseHeaderCommonView *headerView = [[CourseHeaderCommonView alloc] initHeaderCommonViewByFrame:CGRectMake(0, 0, kScreenWidth, 60) EnglishTitle:_EnglishTitle conTitle:_viewTitle block:^{
        [weakSelf cancel];
    }];
    [self.view addSubview:headerView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 15;
//    layout.minimumInteritemSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(10, FIT_SCREEN_WIDTH(20), 10, FIT_SCREEN_WIDTH(20));
//    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 60);
    layout.itemSize = CGSizeMake((kScreenWidth - FIT_SCREEN_WIDTH(55))/2.0, FIT_SCREEN_HEIGHT(130));
    courseCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headerView.bottom, kScreenWidth, kScreenHeight - kNavigationBarHeight - headerView.height) collectionViewLayout:layout];
    courseCollection.backgroundColor = kViewBgColor;
    courseCollection.dataSource = self;
    courseCollection.delegate = self;
    
    [self.view addSubview:courseCollection];
    
    [courseCollection registerClass:[Course_SecondLevelCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    UIImageView *img_purchase = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, kScreenHeight - 100 - kNavigationBarHeight, 90, 90)];
    img_purchase.image = [UIImage imageNamed:@"general_purchase"];
    img_purchase.userInteractionEnabled = YES;
    img_purchase.tag = 1111;
    [self.view addSubview:img_purchase];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPurchase)];
    [img_purchase addGestureRecognizer:tap];
    if (_questionModel.price == 0 || _questionModel.expireTime > 0) {
        img_purchase.hidden = YES;
    }
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:courseCollection.bounds placeholderImage:nil placeholderText:nil];
        [courseCollection addSubview:_emptyView];
    }
    
    return _emptyView;
}

#pragma mark item 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Course_SecondLevelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    QuestionModel *model = _dataArr[indexPath.item];
    
    cell.model = model;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionModel *model = _dataArr[indexPath.item];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:model.videoList.count];
    @autoreleasepool {
        for (NSDictionary *tmp in model.videoList) {
            VideoModel *videoModel = [[VideoModel alloc] initWithDictionary:tmp error:nil];
            if (model.expireTime != 0) {
                videoModel.isPurchase = YES;
            }
            
            [arr addObject:videoModel];
        }
    }
    TO_WEAK(self, weakSelf);
    
    videoListView = [[Course_thirdDataView alloc] initViewByViewTitle:model.name arr:arr seleBlock:^(NSInteger seleIndex) {
//        TO_STRONG(weakSelf, strongSelf);
        //点击播放视频下标
        VideoModel *videoModel = arr[seleIndex];
        
        NSString *share_url = [NSString stringWithFormat:@"%@%ld",kWebVideo,(long)videoModel.id];
        NSMutableDictionary *dic = @{
                                     @"share_describe":kShareDefaultText,
                                     @"share_pic":kShareDefaultLogo,
                                     @"share_title":videoModel.name?videoModel.name:@"",
                                     @"share_url":share_url
                                     }.mutableCopy;
        
        //已购买 | 免费试看
        if (videoModel.isPurchase || [videoModel.attemptSecond integerValue] == -1 || model.price == 0) {
            //已购买视频
            [weakSelf displayPlayView:videoModel shareInfo:dic index:indexPath.row];
        }else {
            //未购买视频
            NSString *con = @"您还未购买此套视频课件，请购买后再来观看吧！";
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:con leftButtonTitle:nil rightButtonTitle:@"去购买" block:^(NSInteger index) {
                if (index == 1) {
                    //去购买
//                    [weakSelf purchaseVideo:model];
                    [weakSelf clickPurchase];
                }
            }];
        }
        
    }];
    
    
    //分享试看
    videoListView.shareVideoBlock = ^(NSInteger seleIndex) {
        
        if (weakSelf.videoEnum != Course_theoryVideo) {
            return ;
        }
//        TO_STRONG(weakSelf, strongSelf);
        
        //视频下标
        VideoModel *videoModel = arr[seleIndex];
        //http://test.xingdongsport.com/web/video/videoId
        NSString *share_url = [NSString stringWithFormat:@"%@%ld",kWebVideo,(long)videoModel.id];
        NSMutableDictionary *dic = @{
                                     @"share_describe":kShareDefaultText,
                                     @"share_pic":kShareDefaultLogo,
                                     @"share_title":videoModel.name?videoModel.name:@"",
                                     @"share_url":share_url
                                     }.mutableCopy;
        
        //免费/已购买
        if (model.price == 0 || videoModel.isPurchase) {
            //已购买，可直接观看
            [weakSelf displayPlayView:videoModel shareInfo:dic index:indexPath.item];
            return;
        }
        //是否可以试看
        if (videoModel.isAttempt) {
            NSInteger attemptSecond  = [videoModel.attemptSecond integerValue];
            if (attemptSecond != -1) {
                //分享试看
                if (videoModel.isShare) {
                    //已经分享过
                    [weakSelf displayPlayView:videoModel shareInfo:dic index:indexPath.item];
                }else {
                    //未分享过，需要进行先分享
                    NSString *con = [NSString stringWithFormat:@"将此链接分享给微信好友、朋友圈、微博，可免费观看课件前%ld分钟",[videoModel.attemptSecond integerValue] / 60];
                    [[CustomAlertView shareCustomAlertView] showTitle:nil content:con leftButtonTitle:nil rightButtonTitle:@"分享" block:^(NSInteger index) {
                        if (index == 1) {
                            //去分享
                            [weakSelf shareVideo:dic index:seleIndex videoModel:videoModel];
                        }
                    }];
                }
            }else {
                if ([videoModel.attemptSecond integerValue] == -1) {
                    //免费视频
                    [weakSelf displayPlayView:videoModel shareInfo:dic index:indexPath.item];
                }
            }
            
        }
    };
    
    [videoListView show];
}

#pragma mark -- 分享视图
- (void)shareVideo:(NSMutableDictionary *)shareInfoDic  index:(NSInteger)index videoModel:(VideoModel *)videoModel {
    ShareView * shareView = [[ShareView alloc] initShareViewBySharePlaform:@[@0,@1,@2]
                                                                 viewTitle:nil
                                                                shareTitle:shareInfoDic[@"share_title"]
                                                                 shareDesp:shareInfoDic[@"share_describe"]
                                                                 shareLogo:shareInfoDic[@"share_pic"]
                                                                  shareUrl:shareInfoDic[@"share_url"]];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    TO_WEAK(self, weakSelf);
    appdelegate.WXCallBackResultBlock = ^(BaseResp *resp) {
        
        if ([resp isKindOfClass:SendMessageToWXResp.class]) {
            SendMessageToWXResp *res = (SendMessageToWXResp *)resp;
            if(res.errCode == 0){
                NSLog(@"用户分享成功");
                videoModel.isShare = YES;
                [weakSelf updateShareNumByVideoId:videoModel.id];
                [weakSelf displayPlayView:videoModel shareInfo:shareInfoDic index:index];
            } else if (res.errCode == -4) {
                NSLog(@"用户取消分享");
            }
        }
    };
    
    //分享到新浪微博
    appdelegate.SinaWBCallBackResultBlock = ^(WBBaseResponse *response) {
        if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
                NSLog(@"你做的微博分享");
                if (response.statusCode == 0) {
                    videoModel.isShare = YES;
                    [weakSelf updateShareNumByVideoId:videoModel.id];
                    [weakSelf displayPlayView:videoModel shareInfo:shareInfoDic index:index];
                }else{
                    NSLog(@"分享失败");
                }
            
        }
    };
    [shareView show];
}

#pragma mark -- 点击购买
- (void)clickPurchase {
    
    TO_WEAK(self, weakSelf);
    PurchaseListView *purchase = [[PurchaseListView alloc] initPurchaseViewByTitle:_viewTitle?_viewTitle:@"" dataArr:_dataArr purchaseBlock:^(NSArray *seleConArr, CGFloat totalMoney){
        
        NSMutableString *goodsId = [NSMutableString string];
       
        for (QuestionModel *model in seleConArr) {
            [goodsId appendString:[NSString stringWithFormat:@"%zi",model.id]];
            [goodsId appendString:@","];
            
        }
        
        goodsId =  (NSMutableString *)[goodsId substringToIndex:goodsId.length-1];
        
        QuestionModel *model = seleConArr.firstObject;
        NSString *orderName = model.name;
        if (seleConArr.count > 1) {
            orderName = [orderName stringByAppendingString:[NSString stringWithFormat:@"等%zi项",seleConArr.count]];
        }
        
        [weakSelf displayOrderInfoGoodsId:goodsId
                                orderName:orderName
                              orderAmount:totalMoney];
        
    }];
    
    purchase.PurchaseTotalVideoBlock = ^{
       //购买整套视频
        TO_STRONG(weakSelf, strongSelf);
        [weakSelf displayOrderInfoGoodsId:
         [NSString stringWithFormat:@"%zi",weakSelf.videoTypeId]
                                orderName:strongSelf->_viewTitle
                              orderAmount:strongSelf->_totalPrice];
    };
    [purchase show];
}

//展示订单信息
- (void)displayOrderInfoGoodsId:(NSString *)goodsId
               orderName:(NSString *)orderName
             orderAmount:(CGFloat)orderAmount {
    
    if (videoListView) {
        [videoListView dismissView];
    }
    OrderPayViewController *orderPay = [[OrderPayViewController alloc]init];
    orderPay.orderName = orderName;
    orderPay.goodsId = goodsId;
    orderPay.orderAmount = orderAmount;
    orderPay.orderEnum = OrderTypeClasses;
    orderPay.backViewController = self;
    
    TO_WEAK(self, weakSelf);
    orderPay.PaySuccessBlock = ^{
        //支付成功的回调
        
        UIImageView *imgPurchase = (UIImageView *)[weakSelf.view viewWithTag:1111];
        imgPurchase.hidden = YES;
        if (weakSelf.PaySuccessCallbackBlock) {
            weakSelf.PaySuccessCallbackBlock();
        }
        [weakSelf getVideoList];
    };
    [self.navigationController pushViewController:orderPay animated:YES];
}

#pragma mark -- 购买
- (void)purchaseVideo:(QuestionModel *)model {
    
    if (videoListView) {
        [videoListView dismissView];
    }
    OrderPayViewController *orderPay = [[OrderPayViewController alloc]init];
    orderPay.orderName = model.name;
    orderPay.goodsId = [NSString stringWithFormat:@"%ld",(long)self.videoTypeId];
    orderPay.orderAmount = model.price/100;
    orderPay.orderEnum = OrderTypeClasses;
    orderPay.backViewController = self;
    TO_WEAK(self, weakSelf);
    orderPay.PaySuccessBlock = ^{
       //支付成功的回调
        [weakSelf getVideoList];
    };
    [self.navigationController pushViewController:orderPay animated:YES];
}

#pragma mark -- 显示播放view
- (void)displayPlayView:(VideoModel *)videoModel shareInfo:(NSMutableDictionary *)shareInfoDic index:(NSInteger)index {
    if (videoListView) {
        [videoListView dismissView];
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isRotation = YES;
    PlayerVideoViewController *play = [[PlayerVideoViewController alloc] init];
    play.liveUrl = videoModel.url;
    play.fromWhere = @"No";
    play.shareInfoDic = shareInfoDic;
    if (!videoModel.isPurchase) {
        if (videoModel.isAttempt && ( [videoModel.attemptSecond integerValue] != -1)) {
            play.time_limit_flag = @"1";
            play.course_video_lock_flag = @"1";
            play.share_show_second = [NSString stringWithFormat:@"%@",videoModel.attemptSecond];
            play.videoPayFlag = @"1";
            play.share_show_after_text = @"您还未购买此套视频课件，请购买后再来观看吧！";
        }
    }
    
    play.VideoType = @"star";
    QuestionModel *model = _dataArr[index];
    play.videoId = [NSString stringWithFormat:@"%ld",(long)videoModel.id];
    play.model = model;
    play.backViewController = self;
    NSData *data = UserDefaultsGet(kUserModel);
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    play.user_tel =userModel.phone;
    TO_WEAK(self, weakSelf);
    play.showPurchaseViewBlock = ^{
       //显示购买页
        [weakSelf clickPurchase];
    };
    play.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:play animated:YES completion:nil];
}

#pragma mark -- 获取视频分类数据
- (void)getVideoList {
    NSDictionary *para = @{
                           @"id":@(_videoTypeId?_videoTypeId:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kApiClassFindAllByParent parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            [strongSelf->_dataArr removeAllObjects];
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                    [strongSelf->_dataArr addObject:model];
                }
            }
            weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
            [strongSelf->courseCollection reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
         [weakSelf stopLoadingAnimation];
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
    }];
}

- (void)updateShareNumByVideoId:(NSInteger )videoId {
    NSDictionary *para = @{
                           @"id":@(videoId?videoId:0)
                           };
    
    [WebRequest PostWithUrlString:kVideoShare parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            
            
        }
        
    } failed:^(NSError *error) {
        
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
