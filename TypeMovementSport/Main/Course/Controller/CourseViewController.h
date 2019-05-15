//
//  CourseViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/5.
//  Copyright © 2018年 XDH. All rights reserved.
//

typedef enum : NSUInteger {
    Course_theoryVideo,//国职理论
    Course_actOpeVideo,//国职实操
    Course_increaseVideo//进阶课程
} CourseVideoEnum;

#import "BaseViewController.h"

@interface CourseViewController : BaseViewController


//@property (nonatomic, assign) BOOL isFromHomePageCountryProfession;//首页国职，隐藏增值视频
//@property (nonatomic, assign) BOOL isFromHomePageIncreaseCourse;//首页进阶课程，隐藏国职


/**
 显示指定类型
 */
- (void)selectIndex:(CourseVideoEnum)videoEnum;



@end
