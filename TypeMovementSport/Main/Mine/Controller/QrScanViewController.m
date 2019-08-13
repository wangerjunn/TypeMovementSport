//
//  QrScanViewController.m
//  SLAPP
//
//  Created by xslp on 2019/8/12.
//  Copyright © 2019 wangxitan. All rights reserved.
//

#import "QrScanViewController.h"
#import <CoreImage/CIDetector.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface QrScanViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) CIDetector *detector;

@end

@implementation QrScanViewController

- (void)scanAlbum {
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
    
    [self setMyTitle:@"二维码扫描"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setNavItemWithTitle:@"相册"
                       isLeft:NO
                       target:self
                       action:@selector(scanAlbum)];
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
            //播放扫描二维码的声音
            
            SystemSoundID soundID;
            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            NSString*strSoundFile = [[NSBundle mainBundle]pathForResource:@"qrcode_found"ofType:@"wav"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
            AudioServicesPlaySystemSound(soundID);
//            [self accordingQcode:scannedResult];
            
        }];
        
    }else{
        [picker
         dismissViewControllerAnimated:YES
         completion:^{
             [[UIApplication
               sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent
              animated:YES];
             UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"该图片没有包含一个二维码！"preferredStyle:UIAlertControllerStyleAlert];
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
    
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
