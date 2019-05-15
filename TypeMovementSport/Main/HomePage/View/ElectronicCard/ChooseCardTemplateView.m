//
//  ChooseCardTemplateView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/26.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ChooseCardTemplateView.h"
#import "UIColor+Hex.h"
#import "HW3DBannerView.h"

@implementation ChooseCardTemplateView {
    HW3DBannerView *bannerView;
    NSArray *imgUrlsArray;
    UIView *bgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initTemplateViewByFrame:(CGRect)frame
                                 conArr:(NSArray *)conArr
                                  block:(void (^)(NSInteger))block {
    if (self = [super initWithFrame:frame]) {
        self.seleTemplateBlock = block;
        imgUrlsArray = conArr;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    UITapGestureRecognizer *tap_bg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBgView)];
    [bgView addGestureRecognizer:tap_bg];
    
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(20, 40, self.width - 40, self.height - 80)];
    mainview.backgroundColor = [UIColor whiteColor];
    mainview.layer.masksToBounds = YES;
    mainview.layer.cornerRadius = 5;
    [self addSubview:mainview];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainview.width, 50)];
    lab.text = @"请选择您要生成的版式";
    
    [lab.layer addSublayer:[UIColor setPayGradualChangingColor:lab fromColor:@"FF6B00" toColor:@"F98617"]];
    lab.textColor = [UIColor whiteColor];
    lab.font = Font(15);
    lab.textAlignment = NSTextAlignmentCenter;
    [mainview addSubview:lab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_confirm"]];
    
    CGFloat wdt_img =   85 / imgView.height * imgView.width;
    imgView.frame = CGRectMake((mainview.width - wdt_img)/2.0, mainview.height - 90, wdt_img, 85);
    [mainview addSubview:imgView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView)];
    [  imgView addGestureRecognizer:tap1];
    imgView.userInteractionEnabled = YES;
    
    CGFloat wdt_banner = mainview.width - 20;
    bannerView = [HW3DBannerView initWithFrame:CGRectMake(0, lab.bottom+20, mainview.width, imgView.top-lab.bottom-30-15) imageSpacing:40 imageWidth:wdt_banner];
    bannerView.imageRadius = 5; // 设置卡片圆角
    bannerView.imageHeightPoor = 10; // 设置中间卡片与两边卡片的高度差
    bannerView.showPageControl = NO;
    bannerView.autoScroll = NO;
    bannerView.placeHolderImage = [UIImage imageNamed:holdImage];
    
    bannerView.data = imgUrlsArray;
    
    [mainview addSubview:bannerView];
}

#pragma mark -- 选择模板样式
- (void)changeView {
    if (self.seleTemplateBlock) {
        self.seleTemplateBlock(bannerView.currentImageIndex);
    }
    [self removeFromSuperview];
}

#pragma mark -- 点击空白处
- (void)clickBgView {
    if (self.clickBgViewBlock) {
        self.clickBgViewBlock();
    }
}

@end
