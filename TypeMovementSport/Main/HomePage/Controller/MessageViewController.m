//
//  MessageViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/5.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "MessageViewController.h"

//view
#import "EmptyPlaceholderTipsView.h"
#import "MessageTableViewCell.h"
#import "SystemTableViewCell.h"

@interface MessageViewController () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *messageTable;
        NSMutableArray *sysMsgArr;//系统消息
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) EmptyPlaceholderTipsView *tipsView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"消息"];
    
    sysMsgArr = [NSMutableArray array];
    
    [self createUI];
    
}

- (void)createUI {
    
//    NSArray *titles = @[@"系统消息",@"我的消息"];
//    CGFloat coorX = FIT_SCREEN_WIDTH(16);
//    CGFloat btnWdt = (kScreenWidth-coorX*2)/2.0;
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(coorX, 41, kScreenWidth - coorX*2, 1)];
//    line.backgroundColor = UIColorFromRGB(0xff4d24);
//    [self.view addSubview:line];
//    for (int i = 0; i < titles.count; i++) {
//        UIButton *btn = [ButtonTool createButtonWithTitle:titles[i]
//                                               titleColor:k46Color
//                                                titleFont:Font(K_TEXT_FONT_16)
//                                                addTarget:self
//                                                   action:@selector(showMessageType:)];
//
//        btn.tag = 100+i;
//        btn.frame = CGRectMake(coorX, 0, btnWdt, 40);
//        [btn setCornerOnTop:5];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        btn.backgroundColor = kViewBgColor;
//
//        [self.view addSubview:btn];
//
//        if (i == 0) {
//            btn.selected = YES;
//            btn.backgroundColor = kOrangeColor;
//        }
//
//        coorX += btn.width;
//    }
    
    
    messageTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    
    messageTable.delegate = self;
    messageTable.dataSource = self;
    messageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        messageTable.estimatedRowHeight = 0;
        messageTable.estimatedSectionHeaderHeight = 0;
        messageTable.estimatedSectionFooterHeight = 0;
        messageTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:messageTable];
    
    [self startLoadingAnimation];
     [self getPushMessageData];
}

- (EmptyPlaceholderTipsView *)tipsView {
    if (_tipsView == nil) {
        
        NSString *info = @"您暂时没有任何消息~";
        _tipsView = [[EmptyPlaceholderTipsView alloc] initWithFrame:messageTable.frame title:nil info:info block:nil];
        [messageTable addSubview:_tipsView];
        _tipsView.hidden = YES;
    }
    
    return _tipsView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return sysMsgArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (curIndex == 1) {
    
    NSDictionary *dict = sysMsgArr[indexPath.row];
    NSString *con = dict[@"content"];
    CGSize size = [UITool sizeOfStr:con andFont:Font(K_TEXT_FONT_12) andMaxSize:CGSizeMake(kScreenWidth - 72, 1000) andLineBreakMode:NSLineBreakByCharWrapping];
  
    CGFloat f = size.height;
        
        
        return 68 + f+20 ;
        
        
//    } else {
//        NSString *con = @"阿斯顿发法兰卡司法所； 说反馈打死了；大三就理发店盛大的发售开发水电费拉对方卡死了； 发送到理发卡；发看的发生了的房间按时打卡了法律是否举案说法发哈访问已的我一肺腑地方 地方拉水电费";
//        CGSize size = [con sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreenWidth - 72, 1000) lineBreakMode:NSLineBreakByWordWrapping];
//        CGFloat f = size.height;
//
//        return 68 +f+20 ;
//
//    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (curIndex == 1) {
//        NSString *identifier = @"myMsgCell";
//
//
//        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//
//        }
//
//        if (indexPath.row % 2 == 0) {
//            cell.label.hidden = YES;
//        } else {
//            cell.label.hidden = NO;
//        }
//        cell.titleStr = @"这是我的标题";
//        cell.timeStr = @"2019-01-05";
//        cell.allOpen = @"123";
//        cell.myString = @"这是消息的b内容，大大方方的法律是否发送的落脚点福利卡发尽快立法看来是打飞机舒服多拉风的解释道的发送到发送到发送发链接； 爱的色放垃圾开发的垃圾发的";
//
//
////        if ([myMsgArr[indexPath.row][@"push_open_flag"] isEqual:@(1)]) {
////            cell.label.hidden = YES;
////        } else {
////            cell.label.hidden = NO;
////        }
//
//
////        cell.titleStr = myMsgArr[indexPath.row][@"push_message_title"];
////        cell.timeStr = myMsgArr[indexPath.row][@"push_message_date"];
////        cell.allOpen = myMsgArr[indexPath.row][@"push_message_id"];
////        cell.myString = myMsgArr[indexPath.row][@"push_message_content"];
////        [cell.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//
////        [cell.lookBtn addTarget:self action:@selector(lookAction:) forControlEvents:UIControlEventTouchUpInside];
//        return cell;
//    }
//
    NSString *identifier = [NSString stringWithFormat:@"Cell"];
    
    
    SystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SystemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.titleStr = @"系统消息标题";
    
    
    
    NSDictionary *dict = sysMsgArr[indexPath.row];
    NSString *time = [self switchTimeByTimeStamp:dict[@"dateCreated"]];
    cell.timeStr = time;
    NSString *con = dict[@"content"];
//    CGSize size = [UITool sizeOfStr:con andFont:Font(K_TEXT_FONT_12) andMaxSize:CGSizeMake(kScreenWidth - 72, 1000) andLineBreakMode:NSLineBreakByCharWrapping];
    
//    CGFloat f = size.height;
    cell.myString = con;
    
//    SystemMessageModel *model = systemArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.titleStr = model.push_all_message_title;
//
//    cell.timeStr = model.push_all_message_date;
//    cell.myString = model.push_all_message_content;
    return cell;
    
}


- (NSString *)switchTimeByTimeStamp:(NSString *)timeStamp {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
    }
    
    
    NSString *timeStr = @"";
    if ([timeStamp isNotEmpty]) {
        NSTimeInterval createInterval = [timeStamp floatValue] / 1000;
        NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:createInterval];
        timeStr =  [_dateFormatter stringFromDate:createDate];
        
        
    }
    
    return timeStr;
}

#pragma mark --  系统消息 | 我的消息
//- (void)showMessageType:(UIButton *)btn {
//
//    if (btn.tag - 100 == curIndex) {
//        return;
//    }
//
//    curIndex = btn.tag - 100;
//
//    for (int i = 0; i < 2; i++) {
//        UIButton *tmpBtn = (UIButton *)[self.view viewWithTag:100+i];
//        tmpBtn.selected = NO;
//        tmpBtn.backgroundColor = kViewBgColor;
//    }
//
//    btn.selected = YES;
//    btn.backgroundColor = kOrangeColor;
//
//    [messageTable reloadData];
//
//    if (btn.tag == 100) {
//        //系统消息
//    }else {
//        //我的消息
//    }
//}

#pragma mark -- 获取系统消息列表
- (void)getPushMessageData {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kMessageFindAllBySystem parms:nil viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            NSArray *detail = dict[@"list"];
            
            [strongSelf->sysMsgArr addObjectsFromArray:detail];
            
            weakSelf.tipsView.hidden = !(strongSelf->sysMsgArr.count < 1);
            [strongSelf->messageTable reloadData];
            
            /*
             detail =         (
                 {
                     content = "系统消息";
                     id = 17;
                     isRetract = 0;
                     tips =                 {
                     content = "消息内容";
                     isRetract = "消息是否撤回";
                     type = "消息类型";
                 };
                 type = SYSTEM;
                 }
             );
             */
            
            
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [strongSelf->messageTable reloadData];
        weakSelf.tipsView.hidden = (strongSelf->sysMsgArr.count > 0);
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [weakSelf stopLoadingAnimation];
        weakSelf.tipsView.hidden = (strongSelf->sysMsgArr.count > 0);
    }];
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
