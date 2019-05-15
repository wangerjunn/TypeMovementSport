//
//  Course_thirdDataView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "Course_thirdDataView.h"

@interface Course_thirdDataView () <
UITableViewDelegate,
UITableViewDataSource> {
    UIView *bgView;
    UIView *conView;
    UITableView *listTable;
    NSArray *dataArr;
}

@end


@implementation Course_thirdDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initViewByViewTitle:(NSString *)viewTitle
                                        arr:(NSArray  *)conArr
                                  seleBlock:(void (^)(NSInteger seleIndex))block {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        
        //初始化数据
        dataArr = conArr;
        self.seleBlock = block;
        [self createUI:viewTitle];
    }
    
    return self;
}

- (void)createUI:(NSString *)viewTitle {
    
    self.backgroundColor = [UIColor clearColor];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    [bgView addGestureRecognizer:tap];
    [self addSubview:bgView];
    
    CGFloat wdt = kScreenWidth;
    CGFloat hgt = FIT_SCREEN_HEIGHT(350);
    
    conView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                      self.height,
                                                      wdt, hgt)];

    conView.backgroundColor = [UIColor whiteColor];
    
    [conView setCornerOnTop:15];
    [self addSubview:conView];
    
    UILabel *titleLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(18)];
    titleLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(50),
                                  0,
                                  conView.width-FIT_SCREEN_WIDTH(50)*2, 50);
    titleLabel.text = viewTitle;
    [conView addSubview:titleLabel];
    //+ (UIButton *)createButtonWithImageName:(NSString *)imageName
//addTarget:(id)target
//action:(SEL)action
    UIButton *btn_cancel = [ButtonTool createButtonWithImageName:@"general_cancel" addTarget:self action:@selector(dismissView)];
    
    btn_cancel.frame = CGRectMake(conView.width-50-15, listTable.bottom, 50, 50);
    [btn_cancel setContentEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [conView addSubview:btn_cancel];
    
    listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom,
                                                              conView.width,
                                                              conView.height-4-titleLabel.bottom)
                                             style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.rowHeight = 56;
    [conView addSubview:listTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat wdt = 18;
        
        UIImageView *videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 ,56/2.0-wdt/2.0,
                                                                              wdt, wdt)];
        videoIcon.image = [UIImage imageNamed:@"course_videoIcon"];
        [cell.contentView addSubview:videoIcon];
        
        UILabel *shareWatchLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_10)];
        shareWatchLabel.frame = CGRectMake(conView.width-100, 0, 100, 56);
        shareWatchLabel.tag = 99;
        shareWatchLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareVideo:)];
        [shareWatchLabel addGestureRecognizer:tap];
        [cell.contentView addSubview:shareWatchLabel];
        
        UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
        label.frame = CGRectMake(videoIcon.right+16, 0, shareWatchLabel.left - videoIcon.right - 16-5, shareWatchLabel.height);
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *shareWatchLabel = (UILabel *)[cell.contentView viewWithTag:99];
    
    label.text = @"";
    /*
     {
         attemptSecond = 300;
         id = 1;
         isAttempt = 1;
         name = "公共理论  第1章";
         tips =                         {
             attemptSecond = "允许试看时间(如果不允许试看,不需要再判断此字段)";
             isAttempt = "是否允许试看";
             name = "视频名称";
             url = "路径";
         };
         url = "http://v.sport-osta.cn/75e175eada4f429c818618ba39f322e4/d9563ed5c6c543f2af0e2ef6fe609818-1a3ecb63ef4bbe4c94a51c65730cf704.mp4";
     },
     */
    VideoModel *model = dataArr[indexPath.row];
    label.text = model.name;
    
    
//    label.text = @"视频视频运动";
    if (model.isAttempt && !model.isPurchase) {
        shareWatchLabel.hidden = NO;
        NSInteger attemptSecond  = [model.attemptSecond integerValue];
        if (attemptSecond == -1) {
            shareWatchLabel.text = [NSString stringWithFormat:@"免费试看"];
        }else {
            shareWatchLabel.text = [NSString stringWithFormat:@"分享试看%ld分钟",attemptSecond/60];
        }
        
    }else {
        shareWatchLabel.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.seleBlock) {
        self.seleBlock(indexPath.row);
    }
    
}

#pragma mark -- 分享试看
- (void)shareVideo:(UITapGestureRecognizer *)tap {
    UITableViewCell *cell = [tap.view tableviewCell];
    
    if (cell != nil) {
        NSIndexPath *index = [listTable indexPathForCell:cell];
        if (self.shareVideoBlock) {
            self.shareVideoBlock(index.row);
        }
    }
}

#pragma mark -- 移除视图
- (void)dismissView {
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        strongSelf->conView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        
        strongSelf->conView.transform = CGAffineTransformMakeTranslation
        (0, -strongSelf->conView.height);
    }];
}

@end
