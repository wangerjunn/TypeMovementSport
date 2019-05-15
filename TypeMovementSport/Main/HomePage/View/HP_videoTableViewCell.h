//
//  HP_videoTableViewCell.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/9.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HP_videoTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^ClickHomeVideoBlock)(NSInteger index);

@property (nonatomic, strong) NSArray *dataArr;


/**
 展示数据

 @param dataArr 数据数组
 @param type 1:模拟练习，2：国职实操，3：增值视频
 */
- (void)updateData:(NSArray*)dataArr type:(NSInteger)type;
@end
