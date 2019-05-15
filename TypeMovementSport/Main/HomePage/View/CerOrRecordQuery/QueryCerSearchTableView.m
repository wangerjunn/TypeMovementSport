//
//  QueryCerSearchTableView.m
//  HRMP
//
//  Created by Mac on 2018/5/17.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import "QueryCerSearchTableView.h"
#import "QueryCerSearchCell.h"
#import "ShareView.h"

@interface QueryCerSearchTableView ()<UITableViewDataSource>{
    NSMutableDictionary *shareBean;
}
@property (nonatomic, strong) ShareView *shareView;
@end
static NSString *QueryCerSearchTableViewCellID = @"QueryCerSearchTableView";
@implementation QueryCerSearchTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.rowHeight = FIT_SCREEN_HEIGHT(160);
       
    }
    return self;
}
- (void)didMoveToWindow {
    [super didMoveToWindow];
}
- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.window) {
        [super setContentOffset:contentOffset];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QueryCerSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:QueryCerSearchTableViewCellID];
    if (!cell) {
        cell = [[QueryCerSearchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:QueryCerSearchTableViewCellID];
    }
    cell.selectionStyle = UITableViewScrollPositionNone;
   /*
    birthdate = "1953-02-08";
    cardNo = "<null>";
    gender = "男";
    llscore = 63;
    name = "<null>";
    result = "合格";
    scscore = 74;
    zhiyedengji = "游泳救生员四级";
    */
    
    cell.examResultLab.text =self.dataArr[indexPath.row][@"result"];
    cell.theoryScoreLab.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"llscore"]];
    cell.opeScoreLab.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"scscore"]];
    cell.professionLevelLab.text =self.dataArr[indexPath.row][@"zhiyedengji"];
    
    cell.ShareView.tag = indexPath.row + 100;
    cell.ShareView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PurchaseAction:)];
    [ cell.ShareView addGestureRecognizer:tap];
    return cell;
}

- (void)PurchaseAction:(UITapGestureRecognizer *)tap{
    
    NSDictionary *dictCon = self.dataArr[tap.view.tag - 100];
    NSDictionary *para = @{
                           @"name":_name?_name:@"",
                           @"zhiyedengji":dictCon[@"zhiyedengji"]?dictCon[@"zhiyedengji"]:@"",
                           @"llscore":dictCon[@"llscore"]?dictCon[@"llscore"]:@"",
                           @"scscore":dictCon[@"scscore"]?dictCon[@"scscore"]:@""
                           };
    [WebRequest PostWithUrlString:kOutsideConnectNationalResultImg parms:para viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            //图片链接
            NSString *imgUrl = dict[@"detail"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            
            ShareView *shareView = [[ShareView alloc]initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:nil shareTitle:@"分享标题" shareDesp:@"分享内容" shareLogo:kTestHoldImgUrl shareUrl:data];
            [shareView show];
            NSLog(@"%@",imgUrl);
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
    
    
    
//    UIView *btn = tap.view;
//    NSLog(@"%ld",btn.tag - 100);
//    NSString *identifierStr =[LZKeychain getDeviceIDInKeychain];
//    NSString *llscore = [NSString stringWithFormat:@"%@", self.dataArr[0][@"certs"][btn.tag - 100][@"llscore"]];
//    NSString *scscore = [NSString stringWithFormat:@"%@", self.dataArr[0][@"certs"][btn.tag - 100][@"scscore"]];
//    NSString *results = [NSString stringWithFormat:@"%@", self.dataArr[0][@"certs"][btn.tag - 100][@"result"]];
//    NSString *zhiyedengji = [NSString stringWithFormat:@"%@", self.dataArr[0][@"certs"][btn.tag - 100][@"zhiyedengji"]];
//    [SVProgressHUD showWithStatus:@"正在创建分享图片" maskType:SVProgressHUDMaskTypeClear];
//    [Apply getApplyInfoShareWithname:self.name user_id:[NSString stringWithFormat:@"%@",[User LoginUserId]] equipment_type:identifierStr llscore:llscore zhiyedengji:zhiyedengji results:results scscore:scscore result:^(NSArray *records, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (records.count > 0) {
//            NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:records[0][@"cert_base64_pic_str"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//            shareBean  = [[NSMutableDictionary alloc] init];
//
//            [shareBean setValue:decodedImgData forKey:@"share_pic"];
//            [shareBean setValue:@"我在使用型动汇APP，快来下载型动汇抽奖有机会获取礼品吧" forKey:@"share_title"];
//            [shareBean setValue:@"http://www.xingdongsport.com/down/index.html" forKey:@"share_url"];
//            _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
//            _shareView.shareBen = shareBean;
//            _shareView.videoId = @"";
//            _shareView.FROME = @"查询";
//            [_shareView shareBtnAction];
//        }
//    }];
//
}


@end
