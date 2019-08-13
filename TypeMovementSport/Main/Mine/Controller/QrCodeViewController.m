//
//  QrCodeViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2019/2/27.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "QrCodeViewController.h"
#import <CoreImage/CIDetector.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>

//model
#import "UserModel.h"

@interface QrCodeViewController ()<
    AVCaptureMetadataOutputObjectsDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate>{
    
    AVCaptureSession * _session;
    UIImageView *_line;
    UILabel *textLabel;
    UIImageView *imageView;
    NSString *_str_lat;
    NSString *_str_lon;
    NSInteger index;
    BOOL animation;
}

@property (nonatomic, strong) CIDetector *detector;

@end

@implementation QrCodeViewController

- (void)scanCamera {
    self.detector= [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //判断设备是否支持相册
        
        UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"未开启访问相册权限，请在设置->隐私->照片中进行设置！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*_Nonnullaction) {}];
        UIAlertAction*confirm = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction*_Nonnullaction) {}];
        [alert addAction:cancel];[alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes= [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing=NO;
    mediaUI.delegate=self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(45 * proportation, 160 * proportation,285 *proportation, 5)];
    _line.image = [UIImage imageNamed:@"mine_qr_line"];
    [self setMyTitle:@"扫描二维码"];
    self.navigationController.navigationBar.translucent = YES;
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,  460 * proportation,kScreenWidth - 30, 20)];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"正在加载...";
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.backgroundColor = [UIColor colorWithWhite:0.076 alpha:1.000];
    imageView.image = [UIImage imageNamed:@"mine_qr_bg"];
    [imageView addSubview:_line];
    [self.view addSubview:imageView];
    [self.view addSubview:textLabel];
    
    [self setNavItemWithTitle:@"相册"
                       isLeft:NO
                       target:self
                       action:@selector(scanCamera)];
}

- (void)scanAnimatin:(NSTimer *)timer{
    
    [UIView animateWithDuration:3 animations:^{
        self->_line.transform = CGAffineTransformMakeTranslation(0,280 * proportation);
    } completion:^(BOOL finished) {
        self->_line.transform = CGAffineTransformIdentity;
        if (self->animation) {
            [self scanAnimatin:nil];
        }
        
    }];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    animation = YES;
    [self scanAnimatin:nil];
    [self captureSession];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    animation = NO;
    [_session stopRunning];
}
-(void)viewWillAppear:(BOOL)animated{
    animation = YES;
    [super viewWillAppear:animated];
    index = 0;
    [self closeSlideBack];
    
}
#pragma mark -- 二维码扫描
- (void)captureSession{
    
    if (!_session) {
        //获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 主线程刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:input]) {
            [_session addInput:input];
        }
        
        if ([_session canAddOutput:output]) {
             [_session addOutput:output];
        }
       
        
        
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        //    [ output setRectOfInterest : CGRectMake (( 124 )/ kScreenHeight ,(( kScreenWidth - 220 )/ 2 )/ kScreenWidth , 220 / kScreenHeight , 220 / kScreenWidth )];
        
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.view.layer.bounds;
        output.rectOfInterest = [self getScanCrop:CGRectMake(45 * proportation,160 *proportation, 285 * proportation, 285 * proportation) readerViewBounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [_session startRunning];
        textLabel.text = @"将二维码放入扫描框内，即可自动扫描";
        imageView.backgroundColor = [UIColor clearColor];
    }else{
        [_session startRunning];
    }
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串
        NSString *string = [NSMutableString stringWithString:metadataObject.stringValue];
        [self handleUrl:string];
    }
}

- (void)handleUrl:(NSString *)string {
    [_session stopRunning];
    
    //NSString *string = @"http://test.xingdongsport.com/xdty/api/userCouponBag/receive?id=8";
    //获取问号的位置，问号后是参数列表
    NSRange range = [string rangeOfString:@"?"];
    
    if (range.location == NSNotFound) {
        
        [self qrInvalid];
        [_session startRunning];
        
    }else{
        
        //获取参数列表
        NSString *propertys = [string substringFromIndex:(int)(range.location+1)];
        
        string = [string substringToIndex:range.location];
        NSArray *compents = [propertys componentsSeparatedByString:@"="];
        if (compents.count > 1) {
            //进行字符串的拆分，通过=来拆分，把每个参数分开
            if ([propertys rangeOfString:@"="].location != NSNotFound) {
                
                NSString *couponId = compents.lastObject;
                [self playSoundEffect:@"5383.mp3"];
                
                [_session stopRunning];
                
                TO_WEAK(self, weakSelf);
                [WebRequest PostWithUrlString:string parms:@{@"id":couponId?couponId:@""} viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
                    
                    TO_STRONG(weakSelf, strongSelf);
                    if ([remindMsg integerValue] == 999) {
                        if ([dict[@"bool"] integerValue] == 1) {
                            [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"领取成功，请前往'我的->优惠券'中查看" buttonTitle:nil block:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }else if ([remindMsg isEqualToString:@"440"]) {
                        [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
                        [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:^(NSInteger index) {
                            [strongSelf->_session startRunning];
                        }];
                        
                    }
                } failed:^(NSError *error) {
                    TO_STRONG(weakSelf, strongSelf);
                    [strongSelf->_session startRunning];
                }];
                
            }else{
                [self qrInvalid];
                [_session startRunning];
            }
        }
    }
    
}

- (void)qrInvalid{
    
    if ([CustomAlertView shareCustomAlertView].isHidden) {
        
        [[CustomAlertView shareCustomAlertView]showTitle:nil content:@"扫描无效"  buttonTitle:nil block:nil];
    }
    
    
}

- (void)requestMajorData:(NSString *)majorNo{
    
    [_session stopRunning];
    
    
}
- (void)requestMainPageData:(NSString *)schoolNo{
    [_session stopRunning];
    
}
#pragma mark -- 第三方扫码支付
- (void)requestMajorOnlineCode:(NSString *)string{
    [_session stopRunning];
}
#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    
    UIImage*image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSArray*features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if(features.count>=1) {
        [picker  dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            CIQRCodeFeature*feature = [features objectAtIndex:0];
            NSString*scannedResult = feature.messageString;
            [self handleUrl:scannedResult];
        }];
        
    }else{
        [picker
         dismissViewControllerAnimated:YES
         completion:^{
             [[UIApplication
               sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent
              animated:YES];
             UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"该图片没有包含二维码！"preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction*confirm = [UIAlertAction
                                      actionWithTitle:@"知道了"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction*_Nonnullaction) {
                                          
                                      }];
             [alert addAction:confirm];
             [self presentViewController:alert
                                animated:YES
                              completion:nil];
             
         }];
        
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]
         setStatusBarStyle:UIStatusBarStyleLightContent
         animated:YES];
        
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
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
