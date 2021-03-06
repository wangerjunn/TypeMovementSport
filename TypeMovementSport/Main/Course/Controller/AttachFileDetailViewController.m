//
//  AttachFileDetailViewController.m
//  SLAPP
//
//  Created by 小二郎 on 2019/3/14.
//  Copyright © 2019年 wangxitan. All rights reserved.
//

#import "AttachFileDetailViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface AttachFileDetailViewController () <UIWebViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *attachFileUrlString;
@property (nonatomic, strong) UIWebView *previewWebView;
@property (nonatomic, strong) NSURL *fileURL;

@end

@implementation AttachFileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"附件详情"];
    [self.view addSubview:self.previewWebView];
    
    [self startLoadingAnimation];
    
    NSURL *url = [NSURL URLWithString:self.attachFileUrlString];
    
    NSString *documentPath = [self documentsDirectoryPath];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentPath,[url lastPathComponent]];
    
    NSLog(@"filePath = %@",filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取数据
    if ([fileManager fileExistsAtPath:filePath]) {
        
        //先判断是 TXT 文件
        if ([[url lastPathComponent] containsString:@".txt"]) {
            
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            // 加载二进制文件
            [self.previewWebView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
//            [self.previewWebView loadData:data MIMEType:@"text/html" characterEncodingName:@"GBK" baseURL:nil];
        }else {
            NSURL *fileURL = [NSURL URLWithString:filePath];
            [self.previewWebView loadRequest:[NSURLRequest requestWithURL:fileURL]];
        }
        
    }else {
        //下载数据
        [self downloadData];
    }
    
}

- (void)setAttachFileUrlString:(NSString *)attachFileUrlString {
    _attachFileUrlString = attachFileUrlString;
}

- (UIWebView *)previewWebView {
    
    if (!_previewWebView) {
        _previewWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
    }
    
    _previewWebView.delegate = self;
    _previewWebView.scalesPageToFit = YES;
    return _previewWebView;
    
}

#pragma mark -- 下载数据
- (void)downloadData {
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //下载地址
    NSURL *url = [NSURL URLWithString:self.attachFileUrlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *documentPath = [self documentsDirectoryPath];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentPath,response.suggestedFilename];
        
        return [NSURL fileURLWithPath:filePath];
        
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
        if (!error) {
            //先判断是 TXT 文件
            if ([[filePath.absoluteString lastPathComponent] containsString:@".txt"]) {
                
                NSData *data = [NSData dataWithContentsOfFile:filePath.absoluteString];
                // 加载二进制文件
                [self.previewWebView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
                //            [self.previewWebView loadData:data MIMEType:@"text/html" characterEncodingName:@"GBK" baseURL:nil];
            }else {
                
                [self.previewWebView loadRequest:[NSURLRequest requestWithURL:filePath]];
            }
        }else {
            [self stopLoadingAnimation];
            
        }
        
        
    }];
    
    //4.执行Task
    [downloadTask resume];
}

- (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopLoadingAnimation];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self stopLoadingAnimation];
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
