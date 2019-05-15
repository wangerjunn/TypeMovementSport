//
//  OrderPayViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "OrderPayViewController.h"
#import "DiscountCouponViewController.h"
#import "BaseNavigationViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "PayFinishedViewController.h"
#import "CourseHeaderCommonView.h"

//model
#import "UserModel.h"
#import "CouponModel.h"

@interface OrderPayViewController () {
    NSInteger payType;//默认-1，支付方式 2:支付宝，1：微信
    UITextField *teleField;//手机号
    UITextField *promotionCodeField;//优惠码
    UILabel *totalPriceLabel;//底部总支付金额
    CouponModel *_couponModel;
    NSString *_orderId;
}

@end

@implementation OrderPayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavBarColor:kViewBgColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenBackBtn];
//    [self setMyTitle:_navTitle?_navTitle:@"订单支付"];
    self.view.backgroundColor = kViewBgColor;
    payType = 1;
    [self orderCreate];
    [self createUI];
}

- (void)createUI {
    
    TO_WEAK(self, weakSelf);
    CourseHeaderCommonView *headerView = [[CourseHeaderCommonView alloc] initHeaderCommonViewByFrame:CGRectMake(0, 0, kScreenWidth, 60) EnglishTitle:@"Order" conTitle:_navTitle?_navTitle:@"订单支付" block:^{
        [weakSelf goBack];
    }];
    [self.view addSubview:headerView];
    
    UIImageView *topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5+headerView.bottom, kScreenWidth, FIT_SCREEN_HEIGHT(175))];
    topBg.userInteractionEnabled = YES;
    topBg.image = [UIImage imageNamed:@"mine_rect"];
    [self.view addSubview:topBg];
    
    CGFloat coorX_label = FIT_SCREEN_WIDTH(40);
    UILabel *label = [LabelTool createLableWithTextColor:k75Color font:BoldFont(K_TEXT_FONT_16)];
    label.numberOfLines = 0;
    label.frame = CGRectMake(coorX_label, FIT_SCREEN_HEIGHT(54)-10, kScreenWidth - coorX_label - 150, 45);
    label.text = _orderName?_orderName:@"";
    [topBg addSubview:label];
    
    UILabel *priceLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(18)];
    priceLabel.frame = CGRectMake(label.right, label.top, topBg.width-label.right-coorX_label, label.height);
    priceLabel.textAlignment = NSTextAlignmentRight;
    [topBg addSubview:priceLabel];
    
    priceLabel.text = [NSString stringWithFormat:@"%.2f元",_orderAmount];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:priceLabel.text];
    [attr addAttribute:NSFontAttributeName value:Font(15) range:NSMakeRange(priceLabel.text.length-1, 1)];
    [attr addAttribute:NSForegroundColorAttributeName value:k75Color range:NSMakeRange(priceLabel.text.length-1, 1)];
    
    priceLabel.attributedText = attr;
    
    UILabel *teleTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    teleTitleLabel.text = @"手机号";
    //label.bottom+10
    teleTitleLabel.frame = CGRectMake(label.left, topBg.height - coorX_label-34, 60, 34);
    [topBg addSubview:teleTitleLabel];
    
    teleField = [[UITextField alloc] initWithFrame:CGRectMake(teleTitleLabel.right, teleTitleLabel.top, topBg.width-teleTitleLabel.right-coorX_label, teleTitleLabel.height)];
    teleField.textColor = kOrangeColor;
    teleField.font = Font(K_TEXT_FONT_14);
    teleField.placeholder = @"请输入手机号";
    teleField.maxCharLength = 11;
    
    NSData *data = UserDefaultsGet(kUserModel);
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    teleField.text = model.phone;
    teleField.textAlignment = NSTextAlignmentRight;
    teleField.keyboardType = UIKeyboardTypePhonePad;
    [topBg addSubview:teleField];
    
    //支付view
    UIImageView *payBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(topBg.left, topBg.bottom+10, topBg.width, FIT_SCREEN_HEIGHT(160))];
    payBgImg.image = [UIImage imageNamed:@"mine_rect"];
    payBgImg.userInteractionEnabled = YES;
    [self.view addSubview:payBgImg];
    
    UILabel *checkLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(K_TEXT_FONT_12)];
    checkLabel.backgroundColor = kOrangeColor;
    checkLabel.text = @"优惠券";
    checkLabel.textAlignment = NSTextAlignmentCenter;
    checkLabel.layer.masksToBounds = YES;
    checkLabel.layer.cornerRadius = 12.5;
    checkLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(checkPromotionCodeAction)];
    
    [checkLabel addGestureRecognizer:tap];
    
    CGFloat wdt_checkLabel = FIT_SCREEN_WIDTH(80);
    checkLabel.frame = CGRectMake(payBgImg.width-coorX_label-wdt_checkLabel, coorX_label, wdt_checkLabel, 28);
    [payBgImg addSubview:checkLabel];
    
    //优惠码
     promotionCodeField = [[UITextField alloc]initWithFrame:CGRectMake(coorX_label, checkLabel.top, checkLabel.left-coorX_label, checkLabel.height)];
    promotionCodeField.textColor = kOrangeColor;
    promotionCodeField.font = Font(K_TEXT_FONT_14);
    promotionCodeField.placeholder = @"";
//    promotionCodeField.keyboardType = UIKeyboardTypePhonePad;
    promotionCodeField.enabled = NO;
    [payBgImg addSubview:promotionCodeField];
    
    //微信支付按钮
    UIButton *wxPayBtn = [self createBtnByTitle:@"微信支付" tag:100 imageName:@"course_pay_wxSele"];//course_pay_wxNormal
    CGFloat wdt_btn = FIT_SCREEN_WIDTH(75);
    //promotionCodeField.bottom+10
    wxPayBtn.frame = CGRectMake(payBgImg.width - coorX_label - wdt_btn,
                                payBgImg.height - coorX_label - 34,
                                wdt_btn, 34);
    
    [payBgImg addSubview:wxPayBtn];
    
    //支付宝按钮
    UIButton *aliPayBtn = [self createBtnByTitle:@"支付宝" tag:101 imageName:@"course_pay_zfbNormal"];
    aliPayBtn.frame = CGRectMake(wxPayBtn.left-wxPayBtn.width-10, wxPayBtn.top, wxPayBtn.width, wxPayBtn.height);
//    [payBgImg addSubview:aliPayBtn];
    
    //支付方式
    UILabel *payTypeTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    payTypeTitleLabel.text = @"支付方式";
    payTypeTitleLabel.frame = CGRectMake(coorX_label,aliPayBtn.top, aliPayBtn.left - coorX_label, aliPayBtn.height);
    [payBgImg addSubview:payTypeTitleLabel];
    
    
    //底部支付view
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - kNavigationBarHeight - FIT_SCREEN_HEIGHT(55), kScreenWidth, FIT_SCREEN_HEIGHT(55))];
    bottomView.backgroundColor = k46Color;
    [self.view addSubview:bottomView];
    
    totalPriceLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:BoldFont(20)];
    totalPriceLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(18), 0, checkLabel.left - FIT_SCREEN_WIDTH(18)-5, bottomView.height);
    totalPriceLabel.adjustsFontSizeToFitWidth = YES;
    totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_orderAmount];
    [bottomView addSubview:totalPriceLabel];
    
    UIButton *payBtn = [ButtonTool createButtonWithTitle:@"支付"
                                              titleColor:[UIColor whiteColor]
                                               titleFont:Font(K_TEXT_FONT_12)
                                               addTarget:self
                                                  action:@selector(callPayPlatform)];
    
    payBtn.layer.masksToBounds = YES;
    payBtn.backgroundColor = kOrangeColor;
    payBtn.layer.cornerRadius = 12.5;
    payBtn.frame = CGRectMake(checkLabel.left, bottomView.height/2.0 - checkLabel.height/2.0, checkLabel.width, checkLabel.height);
    [bottomView addSubview:payBtn];
}

- (UIButton *)createBtnByTitle:(NSString *)title tag:(NSInteger)tag
                     imageName:(NSString *)imageName {
    
    UIButton *btn = [ButtonTool createButtonWithTitle:title
                                           titleColor:k46Color
                                            titleFont:Font(K_TEXT_FONT_12)
                                            addTarget:self
                                               action:@selector(choosePayType:)];
    btn.tag = tag;

    [btn setTitleColor:k210Color forState:UIControlStateNormal];
    [btn setTitleColor:k46Color forState:UIControlStateSelected];
    [btn setSize:CGSizeMake(FIT_SCREEN_WIDTH(75), 34)];
    CGSize size = [UITool sizeOfStr:title
                            andFont:Font(K_TEXT_FONT_12)
                         andMaxSize:CGSizeMake(100, 100)
                   andLineBreakMode:NSLineBreakByCharWrapping];
    CGFloat wdt_icon = 12;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:
                         CGRectMake(btn.width/2.0 - size.width/2.0 - wdt_icon - 4,
                                    btn.height/2.0 - wdt_icon/2.0,
                                    wdt_icon, wdt_icon)];
    icon.tag = 150;
    icon.image = [UIImage imageNamed:imageName];
    [btn addSubview:icon];
    
    return btn;
}

# pragma mark -- 支付方式 微信|支付宝
- (void)choosePayType:(UIButton *)btn {
    
    return;
    payType = btn.tag - 99;
    
    UIButton *wxBtn = (UIButton *)[btn.superview viewWithTag:100];
    UIButton *zfbBtn = (UIButton *)[btn.superview viewWithTag:101];
    
    
    UIImageView *wxIcon = (UIImageView *)[wxBtn viewWithTag:150];
    UIImageView *zfbIcon = (UIImageView *)[zfbBtn viewWithTag:150];
    
    wxBtn.selected = NO;
    zfbBtn.selected = NO;
    wxIcon.image = [UIImage imageNamed:@"course_pay_wxNormal"];
    zfbIcon.image = [UIImage imageNamed:@"course_pay_zfbNormal"];
    
    btn.selected = YES;
    UIImageView *icon = (UIImageView *)[btn viewWithTag:150];
    if (btn.tag == 100) {
        icon.image = [UIImage imageNamed:@"course_pay_wxSele"];
    }else{
        icon.image = [UIImage imageNamed:@"course_pay_zfbSele"];
    }
}

#pragma mark -- 选择优惠券
- (void)checkPromotionCodeAction {
    [self.view endEditing:YES];
    
    DiscountCouponViewController *coupon = [[DiscountCouponViewController alloc] init];
    
    TO_WEAK(self, weakSelf);
    coupon.SeleCouponBlock = ^(CouponModel * _Nonnull model) {
        
        //选择折扣优惠券，进行金额抵扣
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->_couponModel = model;
        strongSelf->promotionCodeField.text = model.name;
        
        CGFloat totalMoney = strongSelf->_orderAmount;
        if ([model.type isEqualToString:@"CASH_COUPON"]) {
            //现金优惠
            strongSelf->totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney -
                                                [model.content floatValue]/100];
        }else if ([model.type isEqualToString:@"DISCOUNT_COUPON"]) {
            //折扣优惠
            strongSelf->totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney -
                                                (totalMoney - strongSelf->_orderAmount * [model.content floatValue] / 100)];
        }
        
    };
    coupon.orderID = _orderId;
    [self.navigationController pushViewController:coupon animated:YES];
}

# pragma mark -- 支付
- (void)callPayPlatform {
    
    [self.view endEditing:YES];
    
    if (payType == -1) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请选择支付方式" buttonTitle:nil block:nil];
        return;
    }
    
    if (payType == 1) {
        //微信支付
    }else {
        //支付宝支付
    }
    
    [self orderPay];
}

#pragma mark -- 创建订单
- (void)orderCreate {
    //订单类型(CLASSES:类别, TRAIN:增值培训)
    NSString *trainType = @"CLASSES";
    if (self.orderEnum == OrderTypeTrain) {
        trainType = @"TRAIN";
    }
    //content:订单内容(所购买类型的id的逗号间隔的字符串)
    
    NSDictionary *para = @{
                           @"type":trainType,
                           @"content":_goodsId?_goodsId:@""
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kApiOrderCreate parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            NSDictionary *detailDict = dict[@"detail"];
            
            strongSelf-> _orderId = [NSString stringWithFormat:@"%@",detailDict[@"id"]];
            
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 订单支付
- (void)orderPay {
    //remark:订单备注
    
    //body:微信支付使用的信息体(APP——需传入应用市场
    
    //paySource:实付类型 WECHAT:微信支付
    
    //userCouponId:优惠券id
    NSDictionary *para = @{
                           @"id":_orderId?_orderId:@"",
                           @"body":[NSString stringWithFormat:@"型动汇-%@",_orderName],
                           @"paySource":(payType==1?@"WECHAT":@"ZFB"),
                           @"userCouponId":@(_couponModel?_couponModel.id:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kOrderPay parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            /*
             //调起微信支付
             */
            
            NSDictionary *detailDic = dict[@"detail"];
            NSDictionary *payReqDic = detailDic[@"payReq"];
            PayReq* req = [[PayReq alloc] init];
            req.partnerId = [NSString stringWithFormat:@"%@",payReqDic[@"partnerid"]];
            req.prepayId  = [NSString stringWithFormat:@"%@",payReqDic[@"prepayid"]];
            req.nonceStr  = [NSString stringWithFormat:@"%@",payReqDic[@"noncestr"]];
            
            req.timeStamp = (uint32_t)[payReqDic[@"timestamp"] integerValue];
            req.package  = payReqDic[@"package"];
            req.sign = [NSString stringWithFormat:@"%@",payReqDic[@"sign"]];
            [WXApi sendReq:req];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.WXCallBackResultBlock = ^(BaseResp *resp) {
                [weakSelf onResp:resp];
            };
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark --微信回调
-(void)onResp:(BaseResp*)resp{
    
    TO_WEAK(self, weakSelf);
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess: {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                if (weakSelf.PaySuccessBlock) {
                    weakSelf.PaySuccessBlock();
                }
                
                PayFinishedViewController *payFinish = [[PayFinishedViewController alloc] init];
                payFinish.goodsName = self.orderName;
                payFinish.backViewController = weakSelf.backViewController;
                payFinish.goodsPrice = [NSString stringWithFormat:@"%.2f",self.orderAmount];
                payFinish.phone = teleField.text;
                [weakSelf.navigationController pushViewController:payFinish animated:YES];

            }
                break;
            case WXErrCodeUserCancel: {
                 [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"支付取消" buttonTitle:nil block:nil];
            }
                break;
            default:
                NSLog(@"用户点击取消并返回，retcode=%d",resp.errCode);
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"支付失败" buttonTitle:nil block:nil];
                break;
        }
    }
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
