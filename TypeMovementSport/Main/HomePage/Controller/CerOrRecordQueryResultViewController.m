//
//  CerOrRecordQueryResultViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/17.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "CerOrRecordQueryResultViewController.h"

//view
#import "CertificateQuerySearchTableView.h"
#import "QueryCerSearchTableView.h"
#import "CerSearchTitleView.h"
#import "CerSearchHeaderView.h"
#import "CerSearchScrollView.h"
#define NNHeadViewHeight 200

@interface CerOrRecordQueryResultViewController () <UIScrollViewDelegate,UITableViewDelegate>{
    UITableView *mainTableView;
    UILabel *NameLab;
    UILabel *SexLab;
    UILabel *BirthdayLab;
    UIImageView *tgImg;
    NSArray *daArr;
    CerSearchHeaderView *headerView;
}

@property (nonatomic, weak) UIView *headerssView;
@property (nonatomic, weak) UIView *tableViewHeadView;
@property (nonatomic, weak) CerSearchScrollView *scrollView;
@property (nonatomic, weak) CerSearchTitleView *titleView;
@property (nonatomic, weak) QueryCerSearchTableView *QueryCerTableView;
@property (nonatomic, weak) CertificateQuerySearchTableView *CertificateTableView;

@end

@implementation CerOrRecordQueryResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createUI];
    [self setupContentView];
    [self setupHeaderView];
    
}

- (void)setupContentView{
    CerSearchScrollView *scrollView           = [[CerSearchScrollView alloc] init];
    scrollView.delaysContentTouches           = NO;
    [self.view addSubview:scrollView];
    self.scrollView                           = scrollView;
    scrollView.pagingEnabled                  = YES;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate                       = self;
    scrollView.contentSize                    = CGSizeMake(kScreenWidth * 2, 0);
    UIView *headView                          = [[UIView alloc] init];
    headView.frame                            = CGRectMake(0, 0, 0, NNHeadViewHeight);
    self.tableViewHeadView = headView;
    
    //成绩tableview
    QueryCerSearchTableView *scoreTableView = [[QueryCerSearchTableView alloc] init];
    
    scoreTableView.delegate = self;
    scoreTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.QueryCerTableView                = scoreTableView;
    scoreTableView.tableHeaderView     = headView;
    [scrollView addSubview:scoreTableView];
    [scoreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    //证书查询
    CertificateQuerySearchTableView *cerTableView = [[CertificateQuerySearchTableView alloc] init];
    cerTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.CertificateTableView                = cerTableView;
    cerTableView.delegate = self;
    cerTableView.tableHeaderView     = headView;
    [scrollView addSubview:cerTableView];
    [cerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(kScreenWidth);
        make.width.equalTo(scoreTableView);
        make.top.bottom.equalTo(scoreTableView);
    }];
    
    if (self.scoreList.count > 0) {
        scoreTableView.dataArr = self.scoreList;
        scoreTableView.name = self.name;
    }
    
    if (self.certList.count > 0) {
        cerTableView.dataArr = self.certList;
        cerTableView.name = self.name;
    }
}

/// tableView 的头部视图
- (void)setupHeaderView {
    [self.view addSubview:headerView];
    self.headerssView                        = headerView;
    CerSearchTitleView *titleView = [[CerSearchTitleView alloc] init];
    [headerView addSubview:titleView];
    self.titleView                         = titleView;
    titleView.backgroundColor              = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self->headerView);
        make.bottom.equalTo(self->headerView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self->headerView.top);
    }];
    __weak typeof(self) weakSelf = self;
    titleView.titles             = @[@"成绩查询", @"证书查询"];
    if ([self.From isEqualToString:@"证书"]) {
        titleView.selectedIndex      = 1;
        [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth * 1, 0) animated:YES];
    }else {
        titleView.selectedIndex      = 0;
        [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth * 0, 0) animated:YES];
    }
    
    titleView.buttonSelected     = ^(NSInteger index){
        
        [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
        
    };
}

- (void)createUI {
    
    headerView = [[CerSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    tgImg = [[UIImageView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(35), 10, 62, 62)];
    tgImg.layer.masksToBounds = YES;
    tgImg.layer.cornerRadius = 10;
    
    UIView *HeaderBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SexLab.y+SexLab.height + FIT_SCREEN_HEIGHT(43))];
    HeaderBgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:HeaderBgView];
    
    
//    NSData *decodedImgData;
//    if (self.dataArr.count > 0 && [self.dataArr[0][@"examResults"][0][@"userMap"][@"photo"] length] > 0) {
//        decodedImgData= [[NSData alloc] initWithBase64EncodedString:self.dataArr[0][@"examResults"][0][@"userMap"][@"photo"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        tgImg.image = [UIImage imageWithData:decodedImgData] ;
//    }
    tgImg.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [HeaderBgView addSubview:tgImg];
    
    NameLab = [[UILabel alloc] initWithFrame:CGRectMake(tgImg.right + FIT_SCREEN_WIDTH(34), 25 , 150, 15)];
    
    [HeaderBgView addSubview:NameLab];
    SexLab = [[UILabel alloc] initWithFrame:CGRectMake(NameLab.left, NameLab.bottom +FIT_SCREEN_HEIGHT(9), 50, 12)];
    [HeaderBgView addSubview:SexLab];
    BirthdayLab = [[UILabel alloc] initWithFrame:CGRectMake(SexLab.right + FIT_SCREEN_WIDTH(10), SexLab.top, 250, 12)];
    [HeaderBgView addSubview:BirthdayLab];
    
    NameLab.font = BoldFont(15);
    NameLab.textColor = k46Color;
    SexLab.font = Font(K_TEXT_FONT_12);
    SexLab.textColor =k46Color;
    
    BirthdayLab.font = Font(K_TEXT_FONT_12);
    BirthdayLab.textColor = k46Color;
    HeaderBgView.height =SexLab.y+SexLab.height + FIT_SCREEN_HEIGHT(43);
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, HeaderBgView.height, kScreenWidth, FIT_SCREEN_HEIGHT(9))];
    img.image = [UIImage imageNamed:@"general_shadow"];
    [headerView addSubview:img];
    
    if (self.certList.count > 0 || self.scoreList.count > 0) {
        
        if (self.certList.count > 0) {
            NameLab.text =[NSString stringWithFormat:@"姓名：%@",self.certList[0][@"name"]];
            SexLab.text = [NSString stringWithFormat:@"性别：%@",self.certList[0][@"gender"]];
            BirthdayLab.text =[NSString stringWithFormat:@"出生日期：%@",self.certList[0][@"birthdate"]];
        }else if (self.scoreList.count > 0) {
            NameLab.text =[NSString stringWithFormat:@"姓名：%@",self.scoreList[0][@"name"]];
            SexLab.text = [NSString stringWithFormat:@"性别：%@",self.scoreList[0][@"gender"]];
            BirthdayLab.text =[NSString stringWithFormat:@"出生日期：%@",self.scoreList[0][@"birthdate"]];
        }
       
    }
    
    UILabel *FromeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, HeaderBgView.height, kScreenWidth, FIT_SCREEN_HEIGHT(43))];
    FromeLab.textColor = k210Color;
    FromeLab.textAlignment = NSTextAlignmentCenter;
    FromeLab.font = Font(11);
    FromeLab.text = @"数据来源：国家体育总局职业技能鉴定网络管理平台";
    [headerView addSubview:FromeLab];
    
    headerView.backgroundColor = RGBACOLOR(241, 243, 246, 1);
    headerView.height =NNHeadViewHeight;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, FromeLab.y+FromeLab.height-FIT_SCREEN_HEIGHT(9), kScreenWidth, 40)];
    imgView.image = [UIImage imageNamed:@"HP_query_bg"];
    [headerView addSubview:imgView];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat contentOffsetX       = scrollView.contentOffset.x;
        NSInteger pageNum            = contentOffsetX / kScreenWidth + 0.5;
        self.titleView.selectedIndex = pageNum;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView || !scrollView.window) {
        return;
    }
    CGFloat offsetY      = scrollView.contentOffset.y;
    CGFloat originY      = 0;
    CGFloat otherOffsetY = 0;
    if (offsetY <= NNHeadViewHeight - 40) {
        originY              = -offsetY;
        if (offsetY < 0) {
            otherOffsetY         = 0;
        } else {
            otherOffsetY         = offsetY;
        }
    } else {
        originY              = -NNHeadViewHeight + 40;
        otherOffsetY         = NNHeadViewHeight;
    }
    NSLog(@"%f",originY);
    headerView.y = originY;
    headerView.height =NNHeadViewHeight;
    for ( int i = 0; i < self.titleView.titles.count; i++ ) {
        if (i != self.titleView.selectedIndex) {
            UITableView *contentView = self.scrollView.subviews[i];
            CGPoint offset = CGPointMake(0, otherOffsetY);
            if ([contentView isKindOfClass:[UITableView class]]) {
                if (contentView.contentOffset.y < NNHeadViewHeight || offset.y < NNHeadViewHeight) {
                    [contentView setContentOffset:offset animated:NO];
                    self.scrollView.offset = offset;
                }
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.CertificateTableView) {
        return FIT_SCREEN_HEIGHT(224);
    }else {
        return FIT_SCREEN_HEIGHT(160);
    }
    
    
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
