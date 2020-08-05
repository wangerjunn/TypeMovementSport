//
//  PerfectInfoViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

#import "PerfectInfoViewController.h"

//view
#import "ChooseItemView.h"
#import "View_PickerView.h"

//model
#import "UserModel.h"

@interface PerfectInfoViewController () <
    UIActionSheetDelegate,
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate> {
        UITableView *infoTable;
        UITapGestureRecognizer *tap;
        
        NSString *nickName;//昵称
        NSString *headUrl;//头像URL
        NSString *gender;//性别
        NSString *location;//所在地
        NSString *infoDesp;//简介
        UIImageView *sexIcon;
        UIImageView *img_head;//头像
}
@end

@implementation PerfectInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    
    nickName = self.userModel.nickName;
    headUrl = self.userModel.headImg;
    gender = self.userModel.sex;
    location = self.userModel.city;
    infoDesp = self.userModel.remark;
    
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
    infoTable.tableHeaderView = [self createHeaderView];
    infoTable.tableFooterView = [self createTableFooterView];
    infoTable.backgroundColor = [UIColor whiteColor];
    infoTable.separatorColor = LaneCOLOR;
    infoTable.rowHeight = 50;
    infoTable.sectionHeaderHeight = 0.001;
    infoTable.sectionFooterHeight = 0.001;
    [self.view addSubview:infoTable];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    [infoTable openAdjustLayoutWithKeyboard];
}

- (UIView *)createHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(90))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat hgt_head = FIT_SCREEN_HEIGHT(73);
    img_head = [[UIImageView alloc]initWithFrame:CGRectMake(headerView.width/2.0-hgt_head/2.0, headerView.height/2.0-hgt_head/2.0, hgt_head, hgt_head)];
    img_head.layer.cornerRadius = hgt_head/2.0;
    img_head.layer.masksToBounds = YES;
    img_head.image = [UIImage imageNamed:@"mine_uploadHead"];
    img_head.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_head = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhoto)];
    [img_head addGestureRecognizer:tap_head];
    [headerView addSubview:img_head];
    
    if (headUrl) {
        [img_head sd_setImageWithURL:[NSURL URLWithString:headUrl]
                    placeholderImage:[UIImage imageNamed:holdFace]];
    }
    sexIcon = [[UIImageView alloc] initWithFrame:CGRectMake(img_head.right - FIT_SCREEN_WIDTH(16), img_head.bottom - FIT_SCREEN_HEIGHT(16), FIT_SCREEN_WIDTH(16), FIT_SCREEN_HEIGHT(16))];
    sexIcon.layer.cornerRadius = FIT_SCREEN_WIDTH(16)/2.0;
    sexIcon.layer.masksToBounds = YES;
    [headerView addSubview:sexIcon];
    
    if (gender.length > 0) {
        if ([gender isEqualToString:@"男"]) {
            sexIcon.image = [UIImage imageNamed:@"general_male"];
        } else {
            sexIcon.image = [UIImage imageNamed:@"general_female"];
        }
    }
    
    return headerView;
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
                                                          action:@selector(updateUserInfo)];
    
    confirmBtn.frame = CGRectMake((kScreenWidth - 262)/2.0, 80,
                                  262, 85);
    
    [footerView addSubview:confirmBtn];
    return footerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
        label.frame = CGRectMake(coorX, 0, (kScreenWidth-coorX*2-20)/2.0, 50);
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
    textField.enabled = NO;
    switch (indexPath.row) {
        case 0:{
            label.text = @"昵称";
            textField.placeholder = @"请填写昵称";
            textField.enabled = YES;
            textField.text = nickName;
            }
            break;
        case 1:{
            label.text = @"性别";
            textField.placeholder = @"请选择性别";
            if (gender.length > 0) {
                textField.text = gender;
//                if ([gender isEqualToString:@"1"]) {
//                    textField.text = @"男";
//                }else if ([gender isEqualToString:@"2"]) {
//                    textField.text = @"女";
//                }
                
            }
        }
            break;
        case 2:{
            label.text = @"所在地";
            textField.placeholder = @"请选择所在地";
            textField.text = location;
        }
            break;
        case 3:{
            label.text = @"简介";
            textField.placeholder = @"请填写简介";
            textField.enabled = YES;
            textField.text = infoDesp;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        //选择性别
        
        TO_WEAK(self, weakSelf);
        ChooseItemView *itemView = [[ChooseItemView alloc]initCityMenuViewByViewTitle:@"请选择性别"
                                                                                  arr:@[@"男",@"女"]
                                                                          seleContent:([gender isEqualToString:@"男"]?@"男":@"女")
                                                                           isMultiple:NO
                                                                            seleBlock:^(NSString *seleCon) {
            TO_STRONG(weakSelf, strongSelf);
            strongSelf->gender = seleCon;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([seleCon isEqualToString:@"男"]) {
                    strongSelf->gender = @"男";
                    strongSelf->sexIcon.image = [UIImage imageNamed:@"general_male"];
                } else {
                    strongSelf->gender = @"女";
                    strongSelf->sexIcon.image = [UIImage imageNamed:@"general_female"];
                }
                
                [strongSelf->infoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }];
        
        [itemView show];
    }else if (indexPath.row == 2) {
        //所在地
        NSString *str_path = [[NSBundle mainBundle] pathForResource:@"address_data_new2" ofType:@"plist"];
        NSArray *dataArr = [NSArray arrayWithContentsOfFile:str_path];
        
        TO_WEAK(self, weakSelf);
        View_PickerView *picker = [[View_PickerView alloc] initPickerViewByArr:dataArr title:@"所在地" block:^(NSString *content) {
            TO_STRONG(weakSelf, strongSelf);
            NSArray *conArr = [content componentsSeparatedByString:@","];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf->location = conArr.lastObject;
                [strongSelf->infoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        } numberOfComponent:2];
        
        [picker show];
        return;
    }
}

# pragma mark -- 选择头像
- (void)choosePhoto {
    UIActionSheet *iconActionSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册上传",@"拍照", nil];
    iconActionSheet.tag = 200;
    [iconActionSheet showInView:self.view];
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
                //昵称
                nickName = textField.text;
            }
                break;
            case 2:{
                //所在地
                location = textField.text;
            }
                break;
            case 3:{
                //简介
                infoDesp = textField.text;
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

//  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //判断相机是否能够使用
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (actionSheet.tag == 200)
    {
        //上传头像
        if (buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }else
            {
                [self showNotiInfo];
            }
            
        } else if (buttonIndex == 1){
            
            if(status == AVAuthorizationStatusAuthorized) {
                // authorized
                [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                
            } else if(status == AVAuthorizationStatusDenied){
                // denied
                [self showNotiInfo];
            } else if(status == AVAuthorizationStatusRestricted){
                // restricted
                [self showNotiInfo];
            } else if(status == AVAuthorizationStatusNotDetermined){
                // not determined
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                        
                        
                    } else {
                        [self showNotiInfo];
                    }
                }];
            }
            
        }
    }
    
}

- (void)showNotiInfo
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请到设置->隐私->照片->型动汇中打开相应权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

//  调用相机和相册库资源
- (void)loadImagePickerWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    
    picker.allowsEditing = YES;
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:^{
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //  kUTTypeImage 代表图片资源类型
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            [self uploadImageByImage:image];
            
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"访问相册的取消按钮");
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- 上传图片
- (void)uploadImageByImage:(UIImage *)image
{
    TO_WEAK(self, weakSelf);
    [Tools uploadImageByImage:image hudView:self.view path:@"teacher/avatar/head_" toTargetMb:@2 uploadCallback:^(BOOL isSuccess, NSError *error, NSString *url) {
        if (isSuccess) {
            
            TO_STRONG(weakSelf, strongSelf);
            strongSelf->headUrl = url;
            strongSelf->img_head.image = image;
        }else{
            
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"头像上传失败，请重新上传" buttonTitle:nil block:nil];
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"%.2f",progress);
    }];
    
}

#pragma mark -- 更新信息
- (void)updateUserInfo {
    [self.view endEditing:YES];
    
    NSDictionary *para = @{
                           @"nickName":nickName?nickName:@"",//昵称
                           @"headImg":headUrl?headUrl:@"",//头像
                           @"sex":gender?gender:@"女性",//性别
                           @"city":location?location:@"",//城市
                           @"remark":infoDesp?infoDesp:@""//简介
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserUpdate parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (strongSelf.updateInfoBlock) {
                strongSelf.updateInfoBlock();
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
