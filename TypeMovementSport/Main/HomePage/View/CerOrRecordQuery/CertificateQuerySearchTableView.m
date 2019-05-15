//
//  CertificateQuerySearchTableView.m
//  HRMP
//
//  Created by Mac on 2018/5/17.
//  Copyright © 2018年 Mac－Cx. All rights reserved.
//

#import "CertificateQuerySearchTableView.h"
#import "CertificateQuerySearchCell.h"
#import "ShareView.h"

@interface CertificateQuerySearchTableView ()<UITableViewDataSource>{
    NSMutableDictionary *shareBean;
}
@property (nonatomic, strong) ShareView *shareView;
@end
static NSString *CertificateQuerySearchTableViewCellID = @"CertificateQuerySearchTableView";
@implementation CertificateQuerySearchTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.rowHeight = FIT_SCREEN_HEIGHT(224);
       
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
    
    if (self.dataArr.count > 0) {
         return [self.dataArr count];
    }else {
        return 1;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CertificateQuerySearchCell* cell = [tableView dequeueReusableCellWithIdentifier:CertificateQuerySearchTableViewCellID];
    if (!cell) {
        cell = [[CertificateQuerySearchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CertificateQuerySearchTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
   
    if (self.dataArr.count > 0) {
        /*
         birthdate = "1953-02-08";
         cardNo = "<null>";
         certdate = "2006-11-28";
         certno = 0664003001500265;
         gender = "男";
         llscore = 60;
         name = "王立石";
         result = "合格";
         scscore = 70;
         zhiyedengji = "社会体育指导员（游泳）五级";
         */
        cell.professionLevelLab.text = self.dataArr[indexPath.row][@"zhiyedengji"];
        cell.NameLab.text = self.dataArr[indexPath.row][@"name"];
        cell.NumberLab.text =[NSString stringWithFormat:@"证书编号：%@",self.dataArr[indexPath.row][@"certno"]];
        cell.ShareView.tag = indexPath.row + 100;
        cell.ShareView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareBtn:)];
        [ cell.ShareView addGestureRecognizer:tap];
        cell.PlaceView.hidden = YES;
    }else {
        cell.PlaceView.hidden = NO;
    }
    
//    cell.professionLevelLab.text = @"社会体育指导员（游泳）五级";
//    cell.NameLab.text = @"XDH";
//    cell.NumberLab.text =[NSString stringWithFormat:@"证书编号：11003324234"];
    
    return cell;
}

- (void)shareBtn:(UITapGestureRecognizer *)tap{
    
    NSDictionary *dictCon = self.dataArr[tap.view.tag-100];
    
    NSDictionary *para = @{
                               @"name":_name?_name:@"",
                               @"zhiyedengji":dictCon[@"zhiyedengji"],
                               @"result":dictCon[@"result"]
                           
                        };
    [WebRequest PostWithUrlString:kOutsideConnectShareCerImg parms:para viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            //图片链接
            NSString *imgUrl = dict[@"detail"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            
            ShareView *shareView = [[ShareView alloc]initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:nil shareTitle:@"型动汇" shareDesp:kShareDefaultText shareLogo:kShareDefaultLogo shareUrl:data];
            [shareView show];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
    
//    UIView *btn = tap.view;
//    NSString *identifierStr = [LZKeychain getDeviceIDInKeychain];
//    NSString *certno = [NSString stringWithFormat:@"%@", self.dataArr[0][@"certs"][btn.tag - 100][@"certno"]];
//    
//    NSString *results = [NSString stringWithFormat:@"%@", self.dataArr[0][@"certs"][btn.tag - 100][@"result"]];
//    NSString *zhiyedengji = [NSString stringWithFormat:@"%@", self.dataArr[0][@"certs"][btn.tag - 100][@"zhiyedengji"]];
//    [SVProgressHUD showWithStatus:@"正在创建分享图片" maskType:SVProgressHUDMaskTypeClear];
//    [Apply getCertificateQueryShareWithname:self.name user_id:[NSString stringWithFormat:@"%@",[User LoginUserId]] equipment_type:identifierStr certNo:certno zhiyedengji:zhiyedengji results:results result:^(NSArray *records, NSError *error) {
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
}

@end
