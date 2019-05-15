//
//  PersonalResumeIntrViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PersonalResumeIntrViewController.h"

@interface PersonalResumeIntrViewController () <UITextViewDelegate>
{
    UITextView *introTextView;
    
    UIView *line;
}
@end

@implementation PersonalResumeIntrViewController

#pragma mark -- 更新简介信息
- (void)updateIntroduceInfo {
    [self.view endEditing:YES];
    
    if (introTextView.text.length < 1) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:kPerfectInfoTip buttonTitle:nil block:nil];
        return;
    }
    NSDictionary *para = @{
                           @"introduction":introTextView.text?introTextView.text:@""
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kResumeCreateOrUpdate parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (strongSelf.RightBarItemBlock) {
                strongSelf.RightBarItemBlock(strongSelf->introTextView.text);
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavItemWithTitle:@"保存" isLeft:NO target:self action:@selector(updateIntroduceInfo)];
    
    CGFloat coorX = FIT_SCREEN_WIDTH(26);
    introTextView = [[UITextView alloc] initWithFrame:CGRectMake(coorX, 20, kScreenWidth-coorX*2, 20)];
    introTextView.backgroundColor = [UIColor whiteColor];
    introTextView.textColor = k75Color;
    introTextView.font = Font(K_TEXT_FONT_12);
    [self.view addSubview:introTextView];
    
    if (self.resumeModel) {
        introTextView.text = self.resumeModel.introduction;
        
        CGSize size = [UITool sizeOfStr:introTextView.text andFont:introTextView.font andMaxSize:CGSizeMake(introTextView.width, MAXFLOAT)
                       andLineBreakMode:NSLineBreakByCharWrapping];
        
        introTextView.height = size.height + 5;
    }
    
    introTextView.delegate = self;
    
    line = [[UIView alloc] initWithFrame:CGRectMake(introTextView.left, introTextView.bottom+10, introTextView.width, 0.5)];
    line.backgroundColor = LaneCOLOR;
    [self.view addSubview:line];
    [self.view openAdjustLayoutWithKeyboard];
}

- (void)textViewDidChange:(UITextView *)textView {
    
//        [textView flashScrollIndicators];   // 闪动滚动条
    
//        static CGFloat maxHeight = 130.0f;
    CGRect frame = introTextView.frame;
    
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    
    CGSize size = [introTextView sizeThatFits:constraintSize];
    
    introTextView.height = size.height + 5;
    
    line.top = introTextView.bottom+10;
//        if (size.height >= maxHeight){
//
//                size.height = maxHeight;
//
//                textView.scrollEnabled = YES;   // 允许滚动
//
//            }else{
//
//                    textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
//
//                }
//
//        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
