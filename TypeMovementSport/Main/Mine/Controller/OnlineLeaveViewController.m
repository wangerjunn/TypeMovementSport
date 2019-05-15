//
//  OnlineLeaveViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "OnlineLeaveViewController.h"

@interface OnlineLeaveViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate> {
    UITableView *infoTable;
    UITapGestureRecognizer *tap;
    
    NSString *nickName;
    NSString *tele;
    NSString *title;
    NSString *contentDesp;
}

@end

@implementation OnlineLeaveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setMyTitle:@"线上留言"];
    
    [self createUI];
}

- (void)createUI {
    infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
    infoTable.delegate = self;
    infoTable.dataSource = self;
    if (@available(iOS 11.0,*)) {
        infoTable.estimatedRowHeight = 0;
        infoTable.estimatedSectionHeaderHeight = 0;
        infoTable.estimatedSectionFooterHeight = 0;
        infoTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    infoTable.userInteractionEnabled = YES;
    infoTable.tableFooterView = [self createTableFooterView];
    infoTable.backgroundColor = [UIColor whiteColor];
    infoTable.rowHeight = 50;
    infoTable.separatorColor = LaneCOLOR;
    [self.view addSubview:infoTable];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    [infoTable openAdjustLayoutWithKeyboard];
}

- (UIView *)createTableFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(40), 0,
                                                           footerView.width-FIT_SCREEN_HEIGHT(40)*2, .5)];
    line.backgroundColor = LaneCOLOR;
    [footerView addSubview:line];
    
    UIButton *confirmBtn = [ButtonTool createButtonWithImageName:@"general_confirm"
                                                       addTarget:self
                                                          action:@selector(commitLeave)];
    confirmBtn.frame = CGRectMake((kScreenWidth - 262)/2.0, 80,
                                  262, 85);
    
    [footerView addSubview:confirmBtn];
    return footerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat coorX = FIT_SCREEN_WIDTH(40);
        UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
        label.tag = 100;
        label.frame = CGRectMake(coorX, 0, 60, 50);
        [cell.contentView addSubview:label];
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(label.right, label.top, kScreenWidth-label.right-coorX, label.height)];
        textField.font = Font(K_TEXT_FONT_14);
        textField.textColor = k46Color;
        textField.textAlignment = NSTextAlignmentRight;
        textField.tag = 101;
        textField.delegate = self;
        [cell.contentView addSubview:textField];
        
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    UITextField *textField = (UITextField*)[cell.contentView viewWithTag:101];
    
    label.text = @"";
    switch (indexPath.row) {
        case 0:{
            label.text = @"姓名";
            textField.placeholder = @"请填写您的姓名(选填)";
            textField.maxCharLength = 12;
            textField.text = nickName;
        }
            break;
        case 1:{
            label.text = @"手机";
            textField.placeholder = @"请填写您的手机号(选填)";
            textField.maxCharLength = 11;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 2:{
            label.text = @"主题";
            textField.placeholder = @"请填写您的主题(选填)";
            textField.text = title;
        }
            break;
        case 3:{
            label.text = @"意见反馈";
            textField.placeholder = @"请填写您的意见";
            textField.text = contentDesp;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

# pragma mark -- 提交用户留言
- (void)commitLeave {
    [self.view endEditing:YES];
    
    if (contentDesp.length < 1) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"内容不能为空" buttonTitle:nil block:nil];
        return;
    }
    
    [self leaveMessageInterface];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [infoTable addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [infoTable removeGestureRecognizer:tap];
    
    UITableViewCell *cell = textField.tableviewCell;
    if (cell) {
        NSIndexPath *indexPath = [infoTable indexPathForCell:cell];
        
        switch (indexPath.row) {
            case 0:{
                   //称呼
                    nickName = textField.text;
            }
                break;
            case 1:{
                //电话
                tele = textField.text;
            }
                break;
            case 2:{
                //标题
                title = textField.text;
            }
                break;
            case 3:{
                //内容
                contentDesp = textField.text;
            }
                break;
                
            default:
                break;
        }
        
        [infoTable reloadData];
    }
}

- (void)viewDidLayoutSubviews {
    if ([infoTable respondsToSelector:@selector(setSeparatorInset:)]) {
        infoTable.separatorInset = UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(40), 0, FIT_SCREEN_WIDTH(40));
    }
    
    if ([infoTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [infoTable setLayoutMargins:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(40), 0, FIT_SCREEN_WIDTH(40))];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(40), 0, FIT_SCREEN_WIDTH(40))];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(40), 0, FIT_SCREEN_WIDTH(40))];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -- 留言
- (void)leaveMessageInterface {
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:contentDesp forKey:@"content"];
    if (nickName.length > 0) {
        [para setObject:nickName forKey:@"name"];
    }
    
    if (tele.length > 0) {
        [para setObject:tele forKey:@"phone"];
    }
    
    if (title.length > 0) {
        [para setObject:title forKey:@"title"];
    }
    [WebRequest PostWithUrlString:kProposalCreate parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"留言成功！" buttonTitle:nil block:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
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
