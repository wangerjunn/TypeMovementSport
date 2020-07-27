//
//  ShareView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ShareView.h"
#import "WXApi.h"

#import <UMengUShare/WeiboSDK.h>

@interface ShareView () {
    NSArray *sharePlatformsArray;//分享到的平台
}

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *shareBackGroundView;
@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, copy) NSString *share_title;//分享标题
@property (nonatomic, copy) id share_url;//分享：图片 | 跳转链接
@property (nonatomic, copy) NSString *share_desp;//分享描述
@property (nonatomic, copy) NSString *share_logo;//分享的logo

@end
@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
分享视图

@param platforms 分享平台数组
@param viewTitle 分享view标题
@param shareTitle 分享标题
@param shareDesp 分享内容
@param shareLogo 分享logo
@param shareUrl 分享跳转链接
@return self
*/
- (instancetype)initShareViewBySharePlaform:(NSArray<NSNumber *> *)platforms
                                  viewTitle:(NSString *)viewTitle
                                 shareTitle:(NSString *)shareTitle
                                  shareDesp:(NSString *)shareDesp
                                  shareLogo:(NSString *)shareLogo
                                   shareUrl:(id)shareUrl {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        _share_title = shareTitle;
        _share_desp = shareDesp;
        _share_url = shareUrl;
        _share_logo = shareLogo;
        sharePlatformsArray = platforms;
        
        self.backgroundColor = [UIColor clearColor];
        [self createUI:viewTitle];
    }
    
    return self;
}

- (void)createUI:(NSString *)viewTitle {

    self.shareBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self.shareBackGroundView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.shareBackGroundView];
    
    
    UITapGestureRecognizer *singerTap=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(hideShareBackView)];
    singerTap.numberOfTapsRequired=1;
    [self.shareBackGroundView addGestureRecognizer:singerTap];
    
    self.shareView = [[UIView alloc]init];
    [self.shareView setFrame:CGRectMake( 0, kScreenHeight , kScreenWidth, 180)];
    [self.shareView setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0]];
    self.shareView.alpha = 1;
    [self.shareBackGroundView addSubview:self.shareView];
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSNumber *num in sharePlatformsArray) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        switch ([num integerValue]) {
            case 0:{
                //分享到微信
                [dic setObject:@"微信好友" forKey:@"title"];
                [dic setObject:@"share_wx" forKey:@"icon"];
                [dic setObject:@0 forKey:@"num"];
            }
                break;
            case 1:{
                //分享到微信朋友
                [dic setObject:@"微信朋友圈" forKey:@"title"];
                [dic setObject:@"share_pyq" forKey:@"icon"];
                [dic setObject:@1 forKey:@"num"];
            }
                break;
            case 2:{
                //分享到微博
                [dic setObject:@"新浪微博" forKey:@"title"];
                [dic setObject:@"share_wb" forKey:@"icon"];
                [dic setObject:@2 forKey:@"num"];
            }
                break;
                
            default:
                break;
        }
        if (dic.allKeys.count > 0) {
            [tmpArr addObject:dic];
        }
        
    }
    
    int index = 0;
    
    for (int j = 0; j < tmpArr.count; j++) {
        
        index = j;
        NSDictionary *item = tmpArr[j];
        
        if (index < sharePlatformsArray.count) {
            UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareButton setFrame:CGRectMake(kScreenWidth / tmpArr.count * j + (kScreenWidth / tmpArr.count - 45) / 2.0, 50, 45, 50)];
            [shareButton setImage:[UIImage imageNamed:item[@"icon"]] forState:UIControlStateNormal];
            [shareButton setTag:1000+[item[@"num"] intValue]];
            [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.shareView addSubview:shareButton];
            
            UILabel *shareTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / tmpArr.count * j + (kScreenWidth / tmpArr.count - 60) / 2.0, 100, 60, 20)];
            [shareTitleLabel setTextColor:[UIColor colorWithRed:119.0/255 green:124.0/255 blue:131.0/255 alpha:1.0]];
            shareTitleLabel.font = [UIFont systemFontOfSize:10];
            shareTitleLabel.textAlignment = NSTextAlignmentCenter;
            shareTitleLabel.text = item[@"title"];
            [self.shareView addSubview:shareTitleLabel];
        }
    }
    
    UILabel *lbShareTitle = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    lbShareTitle.frame = CGRectMake(0, 0, kScreenWidth, 40);
    
    lbShareTitle.text = viewTitle;
    [lbShareTitle setTextAlignment:NSTextAlignmentCenter];
    [self.shareView addSubview:lbShareTitle];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0 , self.shareView.height - 46, self.width, 46);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:119.0/255 green:124.0/255 blue:131.0/255 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelButton.tag = 100;
    [self.shareView addSubview:cancelButton];
    
    [cancelButton addTarget:self
                     action:@selector(removeShareView)
           forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.shareBackGroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.shareView.transform = CGAffineTransformMakeTranslation(0, -self.shareView.height);
    }];
    
}

# pragma mark -- 隐藏视图
- (void)hideShareBackView {
//    if (_forceShare) {
//        return;
//    }
    [self removeShareView];
}

# pragma mark -- 移除视图
- (void)removeShareView {
    [UIView animateWithDuration:0.25 animations:^{
        self.shareView.transform = CGAffineTransformIdentity;
        self.shareBackGroundView.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


# pragma mark -- 点击分享按钮
- (void)shareButtonAction:(UIButton *)btn {
    switch (btn.tag) {
        case 1000:
        {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未下载微信客户端，无法分享到微信！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 103;
                [alert show];
                return;
            }
            
            [self shareToWx];
        }
            break;
        case 1001:
        {
            if(![WXApi isWXAppInstalled]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未下载微信客户端，无法分享到微信！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 103;
                [alert show];
                return;
            }
            [self shareToPyq];
        }
            break;
        case 1002:
        {

            if(![WeiboSDK isWeiboAppInstalled]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未下载新浪微博客户端，无法分享到微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 101;
                [alert show];
                return;
            }

            [self shareToWb];

        }
            break;

        default:
            break;
    }
    [self removeShareView];
}

- (void)shareToWx {
    [self shareScene:WXSceneSession];
}

- (void)shareToPyq {
    [self shareScene:WXSceneTimeline];
}

- (void)shareScene:(int)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    
    NSData *dateImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:_share_logo]];
    UIImage * shareImage = [UIImage imageWithData:dateImg];
    shareImage = [ImageTool resizeImageToSize:CGSizeMake(160, shareImage.size.height*160/shareImage.size.width) image:shareImage];
    //    shareImage = [image resizeToWidth:160 height:shareImage.size.height*160/shareImage.size.width];
    NSData *data = UIImageJPEGRepresentation(shareImage,0.05);
    
    [message setThumbData:data];
    message.title = [NSString stringWithFormat:@"%@",_share_title];
    
    if ([_share_url isKindOfClass:[NSData class]]) {
        //分享图片
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = _share_url;
        message.mediaObject = imageObject;
    }else {
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = _share_url?_share_url:@"http://img.xingdongsport.com/share/img.png";
        message.mediaObject = ext;
    }
    
    message.description = _share_desp;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    
    req.message = message;
    req.scene = scene;

    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

- (void)shareToWb {
    NSString *wbtoken =  [[NSUserDefaults standardUserDefaults] objectForKey:@"wbtoken"];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://www.sina.com";
    authRequest.scope = @"all";
    
    
    NSData *dateImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:_share_logo]];
    UIImage * imageLogo = [UIImage imageWithData:dateImg];
    imageLogo = [ImageTool resizeImageToSize:CGSizeMake(160, imageLogo.size.height*160/imageLogo.size.width) image:imageLogo];
//    imageLogo = [ImageTool resizeToWidth:160 height:imageLogo.size.height*160/imageLogo.size.width];
    NSData *data = UIImageJPEGRepresentation(imageLogo,0.2);
    
    WBMessageObject *message = [WBMessageObject message];
    
    if ([_share_url isMemberOfClass:[NSData class]]) {
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = _share_url;
        message.imageObject = imageObject;
    }else {
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        
        webpage.title = [NSString stringWithFormat:@"%@",_share_title];
        
        webpage.thumbnailData = data;
        webpage.webpageUrl = _share_url?_share_url:@"http://img.xingdongsport.com/share/img.png";
        
        NSLog(@"%@",webpage.webpageUrl);
        
        message.mediaObject = webpage;
    }
    
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:wbtoken];
    
    [WeiboSDK sendRequest:request];
}

#pragma mark -- 强制分享
- (void)setForceShare:(BOOL)forceShare {
    _forceShare = forceShare;
    UIButton *cancel = (UIButton *)[self.shareView viewWithTag:100];
    cancel.userInteractionEnabled = NO;
    [cancel setTitle:@"选择分享平台" forState:UIControlStateNormal];
}

@end
