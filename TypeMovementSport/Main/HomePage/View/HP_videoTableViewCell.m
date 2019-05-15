//
//  HP_videoTableViewCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/9.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "HP_videoTableViewCell.h"
#import "HP_videoCollectionViewCell.h"

//model
#import "QuestionModel.h"

@interface HP_videoTableViewCell () <
    UICollectionViewDelegate,
UICollectionViewDataSource> {
    UICollectionView *videoCollectionView;
    NSInteger _type;
}

@end

@implementation HP_videoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI {    
    UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];

    lay.scrollDirection =  UICollectionViewScrollDirectionHorizontal;

    CGFloat itemHeight = FIT_SCREEN_HEIGHT(118+22);
    lay.itemSize = CGSizeMake(FIT_SCREEN_WIDTH(210), itemHeight);
    lay.minimumLineSpacing = FIT_SCREEN_WIDTH(12);
    lay.minimumInteritemSpacing = 0;
    lay.headerReferenceSize = CGSizeZero;
    lay.footerReferenceSize = CGSizeZero;
    videoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, itemHeight) collectionViewLayout:lay];
    videoCollectionView.delegate = self;
    videoCollectionView.dataSource = self;
    videoCollectionView.contentInset = UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(10), 0, FIT_SCREEN_HEIGHT(10));
    videoCollectionView.showsVerticalScrollIndicator = NO;
    videoCollectionView.showsHorizontalScrollIndicator = NO;
    videoCollectionView.backgroundColor = [UIColor whiteColor];
    videoCollectionView.tag = 101;

    [videoCollectionView registerClass:HP_videoCollectionViewCell.class forCellWithReuseIdentifier:@"videoCell"];

    [self.contentView addSubview:videoCollectionView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(10), videoCollectionView.bottom, kScreenWidth-FIT_SCREEN_WIDTH(10), 0.5)];
    line.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:line];
    
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
//    NSInteger random = rand() % 5;
//    return section+1 + random;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HP_videoCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    if (!videoCell) {
        videoCell = [[HP_videoCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, FIT_SCREEN_WIDTH(210), FIT_SCREEN_HEIGHT(118+23))];
    }
    //1:模拟练习，2：国职实操，3：增值视频
    if (_type == 1) {
        
        QuestionModel *model = _dataArr[indexPath.item];
        [videoCell.videoImg sd_setImageWithURL:[NSURL URLWithString:model.img?model.img:@""] placeholderImage:[UIImage imageNamed:holdImage]];
        //    NSString *title = @"从雅加达亚运会看亚洲体坛新秩序：中日体育对决开";
        NSString *title = [NSString stringWithFormat:@"%@",model.name?model.name:@""];
        videoCell.titleLabel.text = title;
    }else {
        NSDictionary *dict = _dataArr[indexPath.row];
        /*
         {
             "id": 1,
             "url": "http://v.sport-osta.cn/75e175eada4f429c818618ba39f322e4/d9563ed5c6c543f2af0e2ef6fe609818-1a3ecb63ef4bbe4c94a51c65730cf704.mp4",
             "name": "公共理论  第1章",
             "isAttempt": true,
             "attemptSecond": -1,
             "classes": {
                "id": 49
             },
             "isDelete": false
         }
         */
        
//        NSInteger randomNum = rand() % 100 + indexPath.item + 1;
        videoCell.titleLabel.text = dict[@"name"];
        [videoCell.videoImg sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]?dict[@"img"]:@""]
                              placeholderImage:[UIImage imageNamed:holdImage]];
    }
    
    
    return videoCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (self.ClickHomeVideoBlock) {
        self.ClickHomeVideoBlock(indexPath.item);
    }
}


- (void)updateData:(NSArray *)dataArr type:(NSInteger)type {
    _dataArr = dataArr;
    _type = type;
    [videoCollectionView reloadData];
}


@end
