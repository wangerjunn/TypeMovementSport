//
//  PublishPositionViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

static NSString *kTitle = @"title";
static NSString *kIsEnableEdit = @"isEnableEdit";
static NSString *kType = @"type";
static NSString *kContent = @"content";
static NSString *kTitles = @"titles";
static NSString *kElements = @"element";
static NSString *kIsMultiple = @"isMultiple";

#import "PublishPositionViewController.h"

//view
#import "ChooseItemView.h"
#import "View_PickerView.h"

@interface PublishPositionViewController ()<
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource>
{
    UITapGestureRecognizer *tap;
    NSMutableArray *conArr;
    
}

@end

@implementation PublishPositionViewController

#pragma mark -- 保存
- (void)enterpriseAuth {
    
    for (int i = 0; i < conArr.count; i++) {
        NSMutableDictionary *tmp = conArr[i];
        if (i < conArr.count-3) {
            if (tmp[kContent] && [tmp[kContent] length] < 1) {
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:kPerfectInfoTip buttonTitle:nil block:nil];
                return;
            }
        }else {
            break;
        }
    }
    
    [self publishNewPositionInterface];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"职位发布"];
    [self setNavItemWithTitle:@"完成"
                       isLeft:NO
                       target:self
                       action:@selector(enterpriseAuth)];
    
    [self initTableViewWithFrame:CGRectMake( 0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) cellNibName:nil identifier:@"cell" style:UITableViewStyleGrouped];
    
    self.tableView.separatorColor = LaneCOLOR;
    self.tableView.userInteractionEnabled = YES;
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    [self.tableView openAdjustLayoutWithKeyboard];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PopDataConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *titles = @[  @{
                              kTitle:@"职位名称",
                              kIsEnableEdit:@"1",
                              kContent:_positionModel.name?_positionModel.name:@""
                              },@{
                              kTitle:@"工作城市",
                              kIsEnableEdit:@"0",
                              kContent:_positionModel.city?_positionModel.city:@""
                              },@{
                              kTitle:@"工作地点",
                              kIsEnableEdit:@"1",
                              kContent:_positionModel.addr?_positionModel.addr:@""
                              },@{
                              kTitle:@"工作性质",
                              kIsEnableEdit:@"0",
                              kElements:@[@"实习",@"兼职",@"全职"],
                              kContent:_positionModel.property?_positionModel.property:@""
                              },@{
                              kTitle:@"工作经验",
                              kIsEnableEdit:@"0",
                              kElements:dic[kWorkExpYears],
                              kContent:_positionModel.exp?_positionModel.exp:@""
                              },@{
                              kTitle:@"工作职责",
                              kIsEnableEdit:@"1",
                              kContent:_positionModel.duty?_positionModel.duty:@""
                              },@{
                              kTitle:@"任职要求",
                              kIsEnableEdit:@"1",
                              kContent:_positionModel.demand?_positionModel.demand:@""
                              },@{
                              kTitle:@"薪资要求",
                              kIsEnableEdit:@"0",
                              kElements:dic[kHopeSalary],
                              kContent:_positionModel.hopealary?_positionModel.hopealary:@""
                              },@{
                              kTitle:@"学历要求",
                              kIsEnableEdit:@"0",
                              kElements:dic[kEducation],
                              kContent:_positionModel.education?_positionModel.education:@""
                              },@{
                              kTitle:@"性别要求",
                              kIsEnableEdit:@"0",
                              kElements:@[@"不限",@"男",@"女"],
                              kContent:_positionModel.sex?_positionModel.sex:@""
                              },@{
                              kTitle:@"年龄要求",
                              kIsEnableEdit:@"0",
                              kElements:@[@"不限",@"20岁以内",@"20-25岁",@"25-30岁",@"30-40岁",@"40岁以上"],
                              kContent:_positionModel.age?_positionModel.age:@""
                              },@{
                              kTitle:@"身高要求",
                              kIsEnableEdit:@"0",
                              kElements:@[@"不限",@"160cm以内",@"160-170cm",@"170-180cm",@"180-190cm",@"190cm以上"],
                              kContent:_positionModel.height?_positionModel.height:@""
                              }
//                          ,@{
//                              kTitle:@"体重要求",
//                              kIsEnableEdit:@"0",
//                              kElements:@[@"不限",@"50kg以内",@"50-60kg",@"60-70kg",@"70-80kg",@"80kg以上"]
//                              }
                          ];

    conArr = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSDictionary *dic = titles[i];
        [mDic setObject:dic[kTitle] forKey:kTitle];
        [mDic setObject:dic[kIsEnableEdit] forKey:kIsEnableEdit];
        [mDic setObject:dic[kContent] forKey:kContent];
        if (dic[kElements]) {
            [mDic setObject:dic[kElements] forKey:kElements];
        }
        
        [conArr addObject:mDic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return conArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
        label.tag = 100;
        [cell.contentView addSubview:label];
        CGFloat coorX = FIT_SCREEN_WIDTH(26);
        label.frame = CGRectMake(coorX, 0, coorX*2+5, 55);
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(label.right, label.top, kScreenWidth - label.right - coorX, label.height)];
        field.tag = 101;
        field.textAlignment = NSTextAlignmentRight;
        field.delegate = self;
        field.textColor = k75Color;
        field.font = Font(K_TEXT_FONT_12);
        [cell.contentView addSubview:field];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = @"";
    
    UITextField *field = (UITextField *)[cell.contentView viewWithTag:101];
    field.text = @"";
    NSMutableDictionary *mDic = conArr[indexPath.row];
    label.text = mDic[kTitle];
    field.text = mDic[kContent];
    if ([mDic[kIsEnableEdit] integerValue] == 0) {
        field.enabled = NO;
        field.placeholder = @"请选择";
        if (indexPath.row >= conArr.count-3) {
            field.placeholder = @"请选择(选填)";
        }
    }else{
        field.enabled = YES;
        field.placeholder = @"请填写";
    }
    
    if (indexPath.row == 1) {
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.maxCharLength = 11;
    }else {
        field.keyboardType = UIKeyboardTypeDefault;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *mDic = conArr[indexPath.row];

    if ([mDic[kIsEnableEdit] integerValue] == 1) {
        return;
    }
    
    if (indexPath.row == 1) {
        NSString *str_path = [[NSBundle mainBundle] pathForResource:@"address_data_new2" ofType:@"plist"];
        NSArray *dataArr = [NSArray arrayWithContentsOfFile:str_path];
        
        TO_WEAK(self, weakSelf);
        View_PickerView *picker = [[View_PickerView alloc] initPickerViewByArr:dataArr title:mDic[kTitle] block:^(NSString *content) {
            NSArray *conArr = [content componentsSeparatedByString:@","];
            [mDic setObject:conArr.lastObject forKey:kContent];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        } numberOfComponent:2];
        
        [picker show];
        return;
    }
    NSString *title = [NSString stringWithFormat:@"请选择%@",mDic[kTitle]];
    if (mDic[kElements]) {
        NSArray *elements = mDic[kElements];
        NSString *content = mDic[kContent];
        BOOL isMultiple = NO;
        if ([mDic[kIsMultiple] integerValue] == 1) {
            isMultiple = YES;
        }
        TO_WEAK(self, weakSelf);
        ChooseItemView *resumeItemView = [[ChooseItemView alloc] initCityMenuViewByViewTitle:title
                                                                                         arr:elements
                                                                                 seleContent:content
                                                                                  isMultiple:isMultiple
                                                                                   seleBlock:^(NSString *seleCon) {

                                                                                       [mDic setObject:seleCon forKey:kContent];

                                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                                           [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                       });
                                                                                   }];

        [resumeItemView show];
    }
    
}

#pragma mark -- 线偏移
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(26), 0, FIT_SCREEN_WIDTH(26))];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(26), 0, FIT_SCREEN_WIDTH(26))];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(26), 0, FIT_SCREEN_WIDTH(26))];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(26), 0, FIT_SCREEN_WIDTH(26))];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.tableView addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.tableView removeGestureRecognizer:tap];
    
    UITableViewCell *cell = textField.tableviewCell;
    
    if (cell != nil) {
        NSIndexPath *index = [self.tableView indexPathForCell:cell];
        NSMutableDictionary *mDic = conArr[index.row];
        [mDic setObject:textField.text forKey:kContent];
    }
}

- (void)getCityList {
    
}

#pragma mark -- 发布新职位接口
- (void)publishNewPositionInterface {
    
    NSArray *keys = @[@"name",@"city",@"addr",@"property",@"exp",@"duty",@"demand",@"hopealary",@"education",@"sex",@"age",@"height"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (int i = 0; i < conArr.count; i++) {
        
        NSMutableDictionary *tmp = conArr[i];
        [para setObject:tmp[kContent] forKey:keys[i]];
    }
    
    NSString *url = kPositionCreate;
    if (self.positionModel) {
        url = kPositionUpdate;
        [para setObject:@(_positionModel.id?_positionModel.id:0) forKey:@"id"];
        [para setObject:_positionModel.state?_positionModel.state:@"OPEN" forKey:@"state"];
    }else {
        [para setObject:@"OPEN" forKey:@"state"];
    }
    
    [WebRequest PostWithUrlString:url parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            if (self.RightBarItemBlock) {
                self.RightBarItemBlock(dict[@"detail"]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
    } failed:^(NSError *error) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:kRequestFailTip buttonTitle:nil block:nil];
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
