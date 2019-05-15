//
//  TabbarViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "TabbarViewController.h"
#import "BaseNavigationViewController.h"
#import "AppDelegate.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kViewBgColor;
    [[UITabBar appearance] setTranslucent:NO];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.isRotation = NO;
    [self configTabBar];
}

- (void)configTabBar {
    NSString * path = [[NSBundle mainBundle]pathForResource:@"Controllers" ofType:@"plist"];
    NSArray * controllerArray = [[NSArray alloc]initWithContentsOfFile:path];
    NSUInteger controllerCount = controllerArray.count;
    self.tabBar.barTintColor = [UIColor whiteColor];
    NSMutableArray * controllers = [NSMutableArray array];
    for (NSUInteger i = 0; i < controllerCount; i++) {
        NSDictionary * dic = controllerArray[i];

        UIImage * normalImage = [[UIImage imageNamed:dic[@"iconNormal"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectImage = [[UIImage imageNamed:dic[@"iconSelect"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem * barItem = [[UITabBarItem alloc] initWithTitle:dic[@"title"] image:normalImage selectedImage:selectImage];
        
        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSForegroundColorAttributeName] = k75Color;
        [barItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        
        // 选中状态下的文字属性
        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
        selectedAttrs[NSForegroundColorAttributeName] = kOrangeColor;
        [barItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        
        id obj = NSClassFromString(dic[@"className"]);
        
        if ([dic[@"className"] isEqualToString:@"HomeViewController"]) {
            [barItem setImageInsets:UIEdgeInsetsMake(-6,0,6,0)];
            
        }
        UIViewController * root = [[obj alloc]init];
        [root view];
        root.tabBarItem = barItem;
        BaseNavigationViewController * nav = [[BaseNavigationViewController alloc]initWithRootViewController:root];
        [controllers addObject:nav];
    }
    self.viewControllers = controllers;
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
