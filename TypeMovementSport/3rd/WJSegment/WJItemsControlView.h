//
//  WJItemsControlView.h
//  SliderSegment
//
//  Created by silver on 15/11/3.
//  Copyright (c) 2015年 Fsilver. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WJItemsConfig : NSObject

@property(nonatomic,assign)float itemWidth;        //default is 0
@property(nonatomic,strong)UIFont *itemFont;       //default is 16
@property(nonatomic,strong)UIColor *textColor;     //default is COLOR_Gray_Dark
@property(nonatomic,strong)UIColor *selectedColor; //default is COLOR_Green

@property(nonatomic,assign)float linePercent;  //default is 0.8
@property(nonatomic,assign)float lineHieght;   //default is 2.5


@end


typedef void (^WJItemsControlViewTapBlock)(NSInteger index,BOOL animation);

@interface WJItemsControlView : UIScrollView

@property(nonatomic,strong)WJItemsConfig *config;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)BOOL tapAnimation;//default is YES;
@property(nonatomic,readonly)NSInteger currentIndex;
@property(nonatomic,copy)WJItemsControlViewTapBlock tapItemWithIndex;

- (void)hidenBottomLine;//隐藏底部线条

-(void)moveToIndex:(float)index; //called in scrollViewDidScroll
/*
 首次出现，需要高亮显示第二个元素,scroll: 是外部关联的scroll
 [self endMoveToIndex:2];
 [scroll scrollRectToVisible:CGRectMake(2*w, 0.0, w,h) animated:NO];
 */
-(void)endMoveToIndex:(float)index;  //called in scrollViewDidEndDecelerating

/*
 为了满足当左右两边有个向左或向右的按钮，
 把点击按钮的事件操作封装起来，
 通过按钮的tag值进行区分点击事件
 */
- (void)transferBtnClickEventByTag:(NSInteger)tag;

@end
