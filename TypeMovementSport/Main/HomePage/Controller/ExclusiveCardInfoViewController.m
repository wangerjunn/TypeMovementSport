//
//  ExclusiveCardInfoViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/25.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "ExclusiveCardInfoViewController.h"
#import "ElectronicCardSuccessViewController.h"

//view
#import "ExclusiveCardCell.h"

//model
#import "ECardInfoModel.h"

@interface ExclusiveCardInfoViewController ( )<
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate>{
    UITableView *mainTable;
    UIImageView *faceImg;
    UIImageView *qrCodeImg;
    UITapGestureRecognizer *tap_keyboard;
}

@end

@implementation ExclusiveCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"专属名片"];
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn_createCard = [ButtonTool createButtonWithTitle:@"生成名片" titleColor:[UIColor whiteColor] titleFont:Font(K_TEXT_FONT_16) addTarget:self action:@selector(createNewCard)];
    btn_createCard.frame = CGRectMake(0, kScreenHeight - kNavigationBarHeight - 50, kScreenWidth, 45);
    btn_createCard.backgroundColor = kOrangeColor;
    [self.view addSubview:btn_createCard];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, btn_createCard.top) style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTable.estimatedRowHeight = 0;
        mainTable.estimatedSectionHeaderHeight = 0;
        mainTable.estimatedSectionFooterHeight = 0;
    }
    mainTable.backgroundColor  = [UIColor clearColor];
    mainTable.tableHeaderView = [self createTableHeaderVIew];
    mainTable.userInteractionEnabled = YES;
    [self.view addSubview:mainTable];
    
    [mainTable openAdjustLayoutWithKeyboard];
    
    tap_keyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
}

- (UIView *)createTableHeaderVIew {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 189)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    faceImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 92)/2.0, 35, 92, 92)];
    faceImg.image = [UIImage imageNamed:@"HP_ card_headAdd"];
    
    [faceImg setCornerRadius:faceImg.height/2.0];
    
    if (self.seleElementsArr.count > 0) {
        ECardInfoModel *model = self.seleElementsArr.firstObject;
        if ([model.name isEqualToString:@"头像"] && model.value.length > 0) {
            [faceImg sd_setImageWithURL:[NSURL URLWithString:model.value] placeholderImage:[UIImage imageNamed:holdImage]];
        }
    }
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseHead)];
    [faceImg addGestureRecognizer:tap4];
    faceImg.userInteractionEnabled = YES;
    [headerView addSubview:faceImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 92)/2.0, 145, faceImg.width, 12)];
    label.text = @"个人头像上传";
    label.textColor = k75Color;
    label.font = Font(11);
    label.textAlignment = NSTextAlignmentCenter;
    [headerView  addSubview:label];
    
    if (self.isQrCode) {
        faceImg.frame = CGRectMake(52, 35, 92, 92);
        qrCodeImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 152, 40, 92, 92)];
        qrCodeImg.image = [UIImage imageNamed:@"HP_ card_qrAdd"];
        
        label.frame = CGRectMake(52, 145, 92, 12);
     
        [headerView addSubview:qrCodeImg];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadQrCode)];
        [qrCodeImg addGestureRecognizer:tap3];
        qrCodeImg.userInteractionEnabled = YES;
        [qrCodeImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:holdImage]];
        UILabel *qrLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 152, 145, 92, 12)];
        qrLabel.text = @"个人二维码上传";
        qrLabel.font = Font(11);
        qrLabel.textColor = k75Color;
        qrLabel.textAlignment = NSTextAlignmentCenter;
        [headerView  addSubview:qrLabel];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, 5)];
    bgView.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
    [headerView addSubview:bgView];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        ECardInfoModel *model = self.mustSeleArr.firstObject;
        if ([model.name isEqualToString:@"头像"]) {
            return self.mustSeleArr.count-1;
        }
        return self.mustSeleArr.count;
    }
    
    return self.seleElementsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExclusiveCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell"];
    
    if (!cell) {
        cell = [[ExclusiveCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardCell"];
    }
    
    cell.priceLab.delegate = self;
    cell.priceLab.userInteractionEnabled =YES;
    cell.imgMore.hidden = YES;
    
    cell.priceLab.tag = indexPath.section *100 + indexPath.row+1;
    ECardInfoModel *model;
    if (indexPath.section == 0) {
        model = self.mustSeleArr.firstObject;
        if ([model.name isEqualToString:@"头像"]) {
            model = self.mustSeleArr[indexPath.row+1];
        }else {
            model = self.mustSeleArr[indexPath.row];
        }
        
    }else {
        model = self.seleElementsArr[indexPath.row];
    }
    
    cell.titLab.text =model.name;
    
    cell.priceLab.text = model.value;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 53)];
        views.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [LabelTool createLableWithTextColor:kOrangeColor font:Font(13)];
        lab.frame = CGRectMake(16, 0, kScreenWidth - 50, 52);
        lab.text = @"基本信息（必填项）";
        [views addSubview:lab];
        UIView *lane = [[UIView alloc] initWithFrame:CGRectMake(0, 53, kScreenWidth, 1)];
        lane.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
        [views addSubview:lane];
        return views;
    }else {
        UIView *viees = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
        viees.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
        return viees;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 53;
    }else {
        return 5;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
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

#pragma mark -- 上传头像
- (void)chooseHead {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callImagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark -- 上传二维码
- (void)uploadQrCode {
    [self chooseHead];
}

# pragma mark -- 回调相册
- (void)callImagePicker:(UIImagePickerControllerSourceType)sourceType {

    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else{
        NSLog(@"模拟机无法打开相机");
    }
}

#pragma mark -- 生成名片
- (void)createNewCard {
    [self.view endEditing:YES];
    [self createCardInfoItem];
}

#pragma mark -- 上传图片
- (void)uploadImageByImage:(UIImage *)image
{
    TO_WEAK(self, weakSelf);
    [Tools uploadImageByImage:image hudView:self.view path:@"teacher/avatar/head_" toTargetMb:@2 uploadCallback:^(BOOL isSuccess, NSError *error, NSString *url) {
        
        if (isSuccess) {
            TO_STRONG(weakSelf, strongSelf);
            
            if (!self.isQrCode) {
                strongSelf->faceImg.layer.masksToBounds = YES;
                strongSelf->faceImg.layer.cornerRadius = 46;
                
                strongSelf->faceImg.image = image;
                if (strongSelf->_mustSeleArr.count > 0) {
                    ECardInfoModel *model = strongSelf->_mustSeleArr.firstObject;
                    if ([model.name isEqualToString:@"头像"]) {
                        model.value = url;
                    }
                }
            }else {
                strongSelf->qrCodeImg.image = image;
            }
            
        }else{
            
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"上传失败，请重新上传" buttonTitle:nil block:nil];
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"%.2f",progress);
    }];
    
}

#pragma mark -- 创建卡片信息
- (void)createCardInfoItem {
    
    
    NSMutableArray *infoArr = [NSMutableArray array];
    for (ECardInfoModel *model in self.seleElementsArr) {
        if (model.value.length < 1) {
            
            NSString *tipsCon = [NSString stringWithFormat:@"请完善%@",model.name];
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:tipsCon buttonTitle:nil block:nil];
            return;
        }else {
            if (model.value.length > 0) {
                NSDictionary *para = @{
                                       @"id":@(model.id),
                                       @"value":model.value
                                       };
                [infoArr addObject:para];
            }
        }
    }
    
    
    NSString *jsonStr = [infoArr JSONString];
    
    NSDictionary *para = @{
                           @"jsonListStr":jsonStr?jsonStr:@""
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kMyCardInfoItemCreateAll parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            [weakSelf generateMyCard];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

#pragma mark -- 生成名片
- (void)generateMyCard {
    
    [WebRequest PostWithUrlString:kMyCardGenerate parms:nil viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_WEAK(self, weakSelf);
        if ([remindMsg integerValue] == 999) {
            
            NSString *myCardUrl = dict[@"detail"][@"myCardUrl"];
            
            ElectronicCardSuccessViewController *cardInfo = [[ElectronicCardSuccessViewController alloc] init];
            if (![Tools isBlankString:myCardUrl]) {
                cardInfo.generalTemplateImgUrl = myCardUrl;
            }
            [weakSelf.navigationController pushViewController:cardInfo animated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
    } failed:^(NSError *error) {
    }];
}

# pragma mark -- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [mainTable addGestureRecognizer:tap_keyboard];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [mainTable removeGestureRecognizer:tap_keyboard];
    
    UITableViewCell *cell = textField.tableviewCell;
    if (cell != nil) {
        NSIndexPath *indexPath = [mainTable indexPathForCell:cell];
        
        if (textField.tag > 100) {
            ECardInfoModel *model = self.seleElementsArr[indexPath.row];
            model.value = textField.text;
        }else {
            ECardInfoModel *model = self.mustSeleArr[indexPath.row];
            model.value = textField.text;
        }
    }
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
