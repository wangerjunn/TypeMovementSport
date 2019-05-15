//
//  ResumeBasicInfoViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/29.
//  Copyright © 2018年 XDH. All rights reserved.
//


static NSString *kTitle = @"title";
static NSString *kIsEnableEdit = @"isEnableEdit";
static NSString *kType = @"type";
static NSString *kContent = @"content";
static NSString *kTitles = @"titles";
static NSString *kElements = @"element";
static NSString *kIsMultiple = @"isMultiple";
static int countdown = 60;

#import <MobileCoreServices/MobileCoreServices.h>
#import "ResumeBasicInfoViewController.h"

//view
#import "ChooseItemView.h"
#import "View_PickerView.h"

@interface ResumeBasicInfoViewController () <
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate>
{
    UITableView *infoTable;
    UITapGestureRecognizer *tap;
    UIImageView *headImg;
}

//验证码
@property (nonatomic, strong) UILabel *getVerifiCodeLabel;//获取验证码
@property (nonatomic, strong) NSTimer *timer;

//EditEnterpriseCertificationInfo时字段
@property (nonatomic, assign) NSInteger curPhotoType;//0:头像，1：logo，2：营业执照

@end

@implementation ResumeBasicInfoViewController

# pragma mark -- 保存
- (void)updateResumeInfo {
    [self.view endEditing:YES];
    
    NSArray *titles = self.conDic[kTitles];
    for (NSMutableDictionary *tmp in titles) {
        if (self.showInfoEnum == EditResumeJobInfo && [tmp[kTitle] isEqualToString:@"任职时间"]) {
            NSString *time = tmp[kContent];
            NSArray *timeArr = [time componentsSeparatedByString:@"-"];
            
            if (time.length < 1 || timeArr.count < 2) {
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:kPerfectInfoTip buttonTitle:nil block:nil];
                return;
            }else {
                if ([timeArr[0] length] < 1 || [timeArr[1] length] < 1) {
                    [[CustomAlertView shareCustomAlertView] showTitle:nil content:kPerfectInfoTip buttonTitle:nil block:nil];
                    return;
                }
            }
        }else{
            if (tmp[kContent] && [tmp[kContent] length] < 1) {
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:kPerfectInfoTip buttonTitle:nil block:nil];
                return;
            }
        }
        
    }
    
    if (self.showInfoEnum == EditEnterpriseCertificationInfo) {
        //企业认证
        if (self.imgUrl.length < 1 || self.companyLogo.length < 1 || self.companyLicense.length < 1) {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:kPerfectInfoTip buttonTitle:nil block:nil];
            return;
        }
    }
    
    BOOL isUpdate = self.itemId > 0;
    switch (self.showInfoEnum) {
        case EditResumeHeadInfo:
            //更新头像栏信息
            [self createOrUpdateResumeInfo];
            break;
        case EditResumeJobIntentionInfo:
            [self updateOrCreateApplyJobIntention];
            break;
        case EditResumeJobInfo:
            [self workExpCreateOrUpdateWorkExp:isUpdate];
            break;
        case EditResumeTrainInfo:
            [self trainExpCreateOrUpdateTrainExp:isUpdate];
            break;
        case EditResumeGameInfo:
            [self matchExpCreateOrUpdateMatchExp:isUpdate];
            break;
        case EditEnterpriseCertificationInfo:
            [self enterprisAuth];
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavItemWithTitle:@"保存"
                       isLeft:NO
                       target:self
                       action:@selector(updateResumeInfo)];
    
    if (self.navTitle) {
        [self setMyTitle:self.navTitle];
    }
    
    [self createUI];
}


- (void)createUI {
    
    
    infoTable = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight)
                                               style:UITableViewStyleGrouped];
    infoTable.delegate = self;
    infoTable.dataSource = self;
    infoTable.backgroundColor = [UIColor whiteColor];
    infoTable.separatorColor = LaneCOLOR;
    infoTable.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0,*)) {
        infoTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        infoTable.estimatedRowHeight = 0;
        infoTable.estimatedSectionHeaderHeight = 0;
        infoTable.estimatedSectionFooterHeight = 0;
    }
    infoTable.userInteractionEnabled = YES;
    [self.view addSubview:infoTable];
    
    if (self.itemId > 0 && self.showInfoEnum > EditResumeJobIntentionInfo && self.showInfoEnum != EditEnterpriseCertificationInfo) {
        UIButton *delBtn = [ButtonTool createButtonWithTitle:@"删除"
                                                                                          titleColor:[UIColor whiteColor]
                                                                                            titleFont:Font(K_TEXT_FONT_16)
                                                                                         addTarget:self
                                                                                                action:@selector(deleteItemAction)];
        delBtn.frame = CGRectMake(0, kScreenHeight-kNavigationBarHeight-45, kScreenWidth, 45);
        delBtn.backgroundColor = kOrangeColor;
        [self.view addSubview:delBtn];
        
        infoTable.height = delBtn.top;
    }
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    [infoTable openAdjustLayoutWithKeyboard];
    
//    self.imgUrl = @"http://img3.imgtn.bdimg.com/it/u=1285622578,302277335&fm=26&gp=0.jpg";
//    self.companyLogo = @"http://img0.imgtn.bdimg.com/it/u=3909522151,317698799&fm=26&gp=0.jpg";
//    self.companyLicense = @"http://img0.imgtn.bdimg.com/it/u=4197245650,2880824424&fm=26&gp=0.jpg";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.showInfoEnum == EditEnterpriseCertificationInfo) {
        //认证企业
        return 3;
    }
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 0) {
        return 0;
    }
    NSArray *titles = self.conDic[kTitles];
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && (self.showInfoEnum == EditResumeHeadInfo || self.showInfoEnum == EditEnterpriseCertificationInfo)) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(100)+20)];
        
        CGFloat wdtHead = FIT_SCREEN_WIDTH(63);
        headImg = [[UIImageView alloc]initWithFrame:CGRectMake(headerView.width/2.0-wdtHead/2.0, FIT_SCREEN_HEIGHT(20), wdtHead, wdtHead)];
        headImg.layer.masksToBounds = YES;
        headImg.layer.cornerRadius = wdtHead/2.0;
        headImg.userInteractionEnabled = YES;
        
        if ( _imgUrl.length > 0) {
            [headImg sd_setImageWithURL:[NSURL URLWithString:_imgUrl]
                       placeholderImage:[UIImage imageNamed:holdFace]];
        }else {
            headImg.image = [UIImage imageNamed:@"HP_applyJob_head"];
        }
        
        UITapGestureRecognizer *tap_head = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                  action:@selector(chooseHead)];
        [headImg addGestureRecognizer:tap_head];
        [headerView addSubview:headImg];
        
        
        UILabel *label = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_12)];
        label.frame = CGRectMake(0, headImg.bottom+FIT_SCREEN_HEIGHT(15), headerView.width, 15);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"上传头像";
        [headerView addSubview:label];
        return headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //编辑简历上传头像，认证企业
    if (self.showInfoEnum == EditResumeHeadInfo || (self.showInfoEnum == EditEnterpriseCertificationInfo && section == 0)) {
        return FIT_SCREEN_HEIGHT(100)+20;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    //编辑简历培训证书照片，比赛证书照片，企业认证公司logo，营业执照照片
    if (self.showInfoEnum == EditResumeTrainInfo || self.showInfoEnum == EditResumeGameInfo || (self.showInfoEnum == EditEnterpriseCertificationInfo && section != 0)) {
        return FIT_SCREEN_HEIGHT(100);
    }
    return 0.001;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //编辑简历培训证书照片，比赛证书照片，企业认证公司logo，营业执照照片
    if (self.showInfoEnum == EditResumeTrainInfo || self.showInfoEnum == EditResumeGameInfo || (self.showInfoEnum == EditEnterpriseCertificationInfo && section != 0)) {
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(100))];
        
        UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
        
        if (section != 0 && self.showInfoEnum == EditEnterpriseCertificationInfo) {
            if (section == 1) {
                 label.text = @"公司logo";
            }else {
                 label.text = @"公司执照";
            }
        }else {
            if (self.showInfoEnum == EditResumeGameInfo) {
                label.text = @"比赛证书（选填）";
            }else {
                label.text = @"培训证书（选填）";
            }
        }
        
        [label sizeToFit];

        CGFloat coorX = FIT_SCREEN_WIDTH(26);
        
        label.frame = CGRectMake(coorX, FIT_SCREEN_HEIGHT(35), label.width+5, 15);
        [footerView addSubview:label];
        
        //添加照片
        CGFloat wdt_img = FIT_SCREEN_WIDTH(73);
        UIImageView *addImg = [[UIImageView alloc] initWithFrame:CGRectMake(label.right+FIT_SCREEN_WIDTH(30),
                                                                            label.top, wdt_img, wdt_img)];
        [footerView addSubview:addImg];
        addImg.tag = 1000+section;
        addImg.userInteractionEnabled = YES;
        
        addImg.image = [UIImage imageNamed:@"HP_applyJob_add"];
        
        if (section != 0 && self.showInfoEnum == EditEnterpriseCertificationInfo) {
           
            if (section == 1 && self.companyLogo.length > 0) {
                [addImg sd_setImageWithURL:[NSURL URLWithString:_companyLogo] placeholderImage:[UIImage imageNamed:@"HP_applyJob_add"]];
            }else  if (section == 2 && self.companyLicense.length > 0) {
                [addImg sd_setImageWithURL:[NSURL URLWithString:_companyLicense] placeholderImage:[UIImage imageNamed:@"HP_applyJob_add"]];
            }
        }else {
            if (_imgUrl.length > 0) {
                [addImg sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"HP_applyJob_add"]];
            }
            
        }
        
        UITapGestureRecognizer *tap_add = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(chooseCertificate:)];
        [addImg addGestureRecognizer:tap_add];
        return footerView;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showInfoEnum == EditResumeJobInfo && indexPath.row == 2) {
        //任职时间
        NSMutableDictionary *mDic = self.conDic[kTitles][indexPath.row];
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
        
        label.text = mDic[kTitle];
        [cell.contentView addSubview:label];
        CGFloat coorX = FIT_SCREEN_WIDTH(26);
        label.frame = CGRectMake(coorX, 0, coorX*2+5, 55);
        
//        CGFloat fieldWdt = (kScreenWidth - label.right - coorX - 30)/2.0;
        
        UITextField *leftField = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth - coorX - 140, label.top, 60, label.height)];
        leftField.tag = 10001;
        leftField.textAlignment = NSTextAlignmentRight;
        leftField.textColor = k75Color;
        leftField.font = Font(K_TEXT_FONT_12);
        leftField.placeholder = @"请选择";
        leftField.delegate = self;
        [cell.contentView addSubview:leftField];
        
        UILabel *toLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
        toLabel.frame = CGRectMake(leftField.right, leftField.top, 30, leftField.height);
        toLabel.text = @"至";
        toLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:toLabel];
        
        UITextField *rightField = [[UITextField alloc]initWithFrame:CGRectMake(toLabel.right, label.top, leftField.width-10, label.height)];
        rightField.tag = 10002;
        rightField.textAlignment = NSTextAlignmentRight;
        rightField.textColor = k75Color;
        rightField.placeholder = @"请选择";
         rightField.font = Font(K_TEXT_FONT_12);
        rightField.delegate = self;
        [cell.contentView addSubview:rightField];
        
        NSString *time = mDic[kContent];
        NSArray *timeArr = [time componentsSeparatedByString:@"-"];
        if (timeArr.count > 0) {
            leftField.text = timeArr.firstObject;
            if (timeArr.count >= 2) {
                rightField.text = timeArr[1];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    NSMutableDictionary *mDic = self.conDic[kTitles][indexPath.row];
    
    if ([mDic[kTitle] isEqualToString:@"验证码"]) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
        
        label.text = mDic[kTitle];
        [cell.contentView addSubview:label];
        CGFloat coorX = FIT_SCREEN_WIDTH(26);
        label.frame = CGRectMake(coorX, 0, coorX*2+5, 55);
        //验证码
        if (_getVerifiCodeLabel == nil) {
            _getVerifiCodeLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(K_TEXT_FONT_12*proportation)];
            _getVerifiCodeLabel.frame = CGRectMake(kScreenWidth - coorX -FIT_SCREEN_WIDTH(80),
                                                   (55 - FIT_SCREEN_HEIGHT(25))/2.0, FIT_SCREEN_WIDTH(80),
                                                   FIT_SCREEN_HEIGHT(25));
            _getVerifiCodeLabel.backgroundColor = kOrangeColor;
            _getVerifiCodeLabel.textAlignment = NSTextAlignmentCenter;
            _getVerifiCodeLabel.text = @"获取验证码";
            _getVerifiCodeLabel.layer.masksToBounds = YES;
            _getVerifiCodeLabel.layer.cornerRadius = 12.5;
            
            _getVerifiCodeLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap_getVertifiCode = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(getVertifiCode)];
            [_getVerifiCodeLabel addGestureRecognizer:tap_getVertifiCode];
        }
        
        [cell.contentView addSubview:_getVerifiCodeLabel];
        
        UITextField *leftField = [[UITextField alloc]initWithFrame:CGRectMake(label.right, label.top, _getVerifiCodeLabel.left - label.right - 10, label.height)];
        leftField.textAlignment = NSTextAlignmentRight;
        leftField.textColor = k75Color;
        leftField.font = Font(K_TEXT_FONT_12);
        leftField.placeholder = @"请输入";
        leftField.delegate = self;
        leftField.text = mDic[kContent];
        [cell.contentView addSubview:leftField];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
    
    label.text = mDic[kTitle];
    field.text = mDic[kContent];
    if ([mDic[kIsEnableEdit] integerValue] == 0) {
        field.enabled = NO;
        field.placeholder = @"请选择";
    }else{
        field.enabled = YES;
        field.placeholder = @"请填写";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *mDic = self.conDic[kTitles][indexPath.row];
    
    if ([mDic[kIsEnableEdit] integerValue] == 1) {
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
            
            TO_STRONG(weakSelf, strongSelf);
            [mDic setObject:seleCon forKey:kContent];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf->infoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }];
        
        [resumeItemView show];
    }else{
        
        TO_WEAK(self, weakSelf);
        if (self.showInfoEnum == EditResumeJobIntentionInfo && indexPath.row == 1) {
            //期望城市
            NSString *str_path = [[NSBundle mainBundle] pathForResource:@"address_data_new2" ofType:@"plist"];
            NSArray *dataArr = [NSArray arrayWithContentsOfFile:str_path];
            
            TO_WEAK(self, weakSelf);
            View_PickerView *picker = [[View_PickerView alloc] initPickerViewByArr:dataArr title:mDic[kTitle] block:^(NSString *content) {
                TO_STRONG(weakSelf, strongSelf);
                NSArray *conArr = [content componentsSeparatedByString:@","];
                [mDic setObject:conArr.lastObject forKey:kContent];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf->infoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            } numberOfComponent:2];
            
            [picker show];
            return;
        }else {
            View_PickerView *picker = [[View_PickerView alloc] initDatePickerViewByViewTitle:title minDate:nil maxDate:[NSDate date] UIDatePickerMode:UIDatePickerModeDate dateFormat:@"YYYY.MM" clickDoneBlock:^(NSString *content) {
                [mDic setObject:content forKey:kContent];
                TO_STRONG(weakSelf, strongSelf);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf->infoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }];
            [picker show];
        }
    }
    
}

#pragma mark -- 获取验证码
- (void)getVertifiCode {
    
    [self.view endEditing:YES];
    NSArray *titles = self.conDic[kTitles];
    for (NSMutableDictionary *mDic in titles) {
        if ([mDic[kTitle] isEqualToString:@"手机号"]) {
            
            [self requestVertifiCodeInterfaceByTele:mDic[kContent]];
            return;
        }
    }
    
}

- (void)requestVertifiCodeInterfaceByTele:(NSString *)tele {
    
    if (tele.length == 0) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请填写手机号码" buttonTitle:nil block:nil];
        return;
    }
    if (tele.length != 11) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"手机号码格式不正确" buttonTitle:nil block:nil];
        return;
    }
    
    TO_WEAK(self, weakSelf);
    
    [WebRequest PostWithUrlString:kSendCode parms:@{@"phone":tele}  viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (!strongSelf->_timer) {
                strongSelf->_timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                      target:self
                                                                    selector:@selector(updateCountdown)
                                                                    userInfo:nil
                                                                     repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:strongSelf->_timer forMode:NSDefaultRunLoopMode];
            }
            strongSelf->_getVerifiCodeLabel.userInteractionEnabled = NO;
            strongSelf->_getVerifiCodeLabel.backgroundColor = k210Color;
            [strongSelf->_timer fire];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 更新倒计时
- (void)updateCountdown {
    countdown -= 1;
    _getVerifiCodeLabel.text = [NSString stringWithFormat:@"%2d秒后获取",countdown];
    
    if (countdown == 0) {
        _getVerifiCodeLabel.userInteractionEnabled = YES;
        _getVerifiCodeLabel.backgroundColor = kOrangeColor;
        _getVerifiCodeLabel.text = [NSString stringWithFormat:@"获取验证码"];
        countdown = 60;
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark -- 选择任职开始 | 结束时间
- (void)chooseJobTime:(NSInteger )tag {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *mDic = self.conDic[kTitles][2];
//    NSDate *minDate;
//    NSDate *maxDate = [NSDate date];
    
    NSString *time = mDic[kContent];
//
    NSArray *tmpArr;
//
    if (time.length > 0) {
        tmpArr = [time componentsSeparatedByString:@"-"];
    }
    NSMutableArray *timeArr = [NSMutableArray arrayWithArray:tmpArr];
    
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"YYYY.MM"];
    
//    [df setLocale:[NSLocale currentLocale]];
    
//    if (tag == 10001) {
//        //开始时间
//        if (timeArr.count >= 2) {
//            NSString *endTime = timeArr[1];
//            if (endTime.length > 0) {
//                maxDate = [df dateFromString:timeArr[1]];
//            }
//
//        }
//    }else{
//        //结束时间
//        if (timeArr.count > 0) {
//            NSString *startTime = timeArr.firstObject;
//            if (startTime.length > 0) {
//
//                minDate = [df dateFromString:timeArr.firstObject];
//            }
//        }
    
//    }
    
    if (timeArr.count == 0) {
        [timeArr addObject:@""];
        [timeArr addObject:@""];
    }
    TO_WEAK(self, weakSelf);
    View_PickerView *picker = [[View_PickerView alloc] initDatePickerViewByViewTitle:mDic[kTitle] minDate:nil maxDate:[NSDate date] UIDatePickerMode:UIDatePickerModeDate dateFormat:@"YYYY.MM" clickDoneBlock:^(NSString *content) {
        
        
        if (tag == 10001) {
            //开始时间
            NSString *endTime = timeArr.lastObject;
            if (endTime.length < 1) {
                [timeArr replaceObjectAtIndex:0 withObject:content];
            }else{
                BOOL isLegal = [weakSelf endTimeIsMoreThanStartTime:content endTime:endTime];
                if (!isLegal) {
                    [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"任职结束时间必须大于任职开始时间!" buttonTitle:nil block:nil];
                    return;
                }
                [timeArr replaceObjectAtIndex:0 withObject:content];
            }
            
        }else{
            //结束时间
            NSString *startTime = timeArr.firstObject;
            if (startTime.length < 1) {
                [timeArr replaceObjectAtIndex:1 withObject:content];
            }else{
                BOOL isLegal = [weakSelf endTimeIsMoreThanStartTime:startTime endTime:content];
                if (!isLegal) {
                    [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"任职结束时间必须大于任职开始时间!" buttonTitle:nil block:nil];
                    return;
                }
                [timeArr replaceObjectAtIndex:1 withObject:content];
            }
            
        }
        
        NSString *newContnet = [NSString stringWithFormat:@"%@-%@",timeArr.firstObject,timeArr.lastObject];
        [mDic setObject:newContnet forKey:kContent];
        TO_STRONG(weakSelf, strongSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf->infoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
    [picker show];
}

- (BOOL)endTimeIsMoreThanStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSArray *startArr = [startTime componentsSeparatedByString:@"."];
    NSArray *endArr = [endTime componentsSeparatedByString:@"."];
    
    if ([startArr[0] integerValue] < [endArr[0] integerValue]) {
        return YES;
    }
    
    if ([startArr[0] integerValue] == [endArr[0] integerValue]) {
        if ([startArr[1] integerValue] <= [endArr[1] integerValue]) {
            return YES;
        }
    }
    
    return NO;
}

# pragma mark -- 选择头像
- (void)chooseHead {
    if (self.showInfoEnum == EditEnterpriseCertificationInfo) {
        _curPhotoType = 0;
    }
    [self showCamera];
}

# pragma mark -- 选择证书
- (void)chooseCertificate:(UITapGestureRecognizer *)tap {
    
    _curPhotoType = tap.view.tag - 1000;
    [self showCamera];
}

- (void)showCamera {
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


# pragma mark -- 回调相册
- (void)callImagePicker:(UIImagePickerControllerSourceType)sourceType {
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else{
        NSLog(@"模拟机无法打开相机");
    }
}

#pragma mark -- 删除item
- (void)deleteItemAction {
     [self deleteItem];
}

#pragma mark -- 用户创建或修改自己的简历
- (void)createOrUpdateResumeInfo {
     NSArray *titles = self.conDic[kTitles];
    NSArray *keys = @[@"name",@"sex",@"education",@"major",@"school",@"workExpYear",@"birthday",@"phone",@"code"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *tmp = titles[i];
        [para setObject:tmp[kContent] forKey:keys[i]];
    }
    
    [para setObject:_imgUrl?_imgUrl:@"" forKey:@"headImg"];
    if (self.itemId < 1) {
        [para setObject:@"OPEN" forKey:@"state"];
    }
    [self createOrUpdateResumeInfoCommonInterface:para];
}

#pragma mark -- 更新求职意向
- (void)updateOrCreateApplyJobIntention {
    NSArray *titles = self.conDic[kTitles];
    NSArray *keys = @[@"hopePosition",@"hopeCity",@"hopealary",@"hope"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *tmp = titles[i];
        [para setObject:tmp[kContent] forKey:keys[i]];
    }
    
    [self createOrUpdateResumeInfoCommonInterface:para];
}

#pragma mark -- 上传图片
- (void)uploadImageByImage:(UIImage *)image
{
    TO_WEAK(self, weakSelf);
    [Tools uploadImageByImage:image hudView:self.view path:@"teacher/avatar/head_" toTargetMb:@2 uploadCallback:^(BOOL isSuccess, NSError *error, NSString *url) {
        
        TO_STRONG(weakSelf, strongSelf);
        if (isSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (strongSelf->_curPhotoType) {
                    case 0:{
                        //照片
                        strongSelf->_imgUrl = url;
                        if (weakSelf.showInfoEnum != EditResumeHeadInfo) {
                            //培训证书 | 比赛证书
                            [strongSelf->infoTable reloadData];
                        }else {
                            strongSelf->headImg.image = image;
                        }
                        
                    }
                        break;
                    case 1:{
                        //logo
                        strongSelf->_companyLogo = url;
                        [strongSelf->infoTable reloadData];
                    }
                        break;
                    case 2:{
                        //营业执照
                        strongSelf->_companyLicense = url;
                        [strongSelf->infoTable reloadData];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            });
        
        }else{
            
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"头像上传失败，请重新上传" buttonTitle:nil block:nil];
        }
    } withProgressCallback:^(float progress) {
        NSLog(@"%.2f",progress);
    }];
    
}

//更新头像 | 求职意向
- (void)createOrUpdateResumeInfoCommonInterface:(NSDictionary *)para {
    
    [WebRequest PostWithUrlString:kResumeCreateOrUpdate parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            if (self.RightBarItemBlock) {
                self.RightBarItemBlock(dict[@"detail"]);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark -- 创建比赛经历 | 修改比赛经历
- (void)matchExpCreateOrUpdateMatchExp:(BOOL)isUpdate {
    
    NSArray *titles = self.conDic[kTitles];
    
    NSArray *keys = @[@"name",@"project",@"time"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *tmp = titles[i];
        [para setObject:tmp[kContent] forKey:keys[i]];
    }
    
    if (_imgUrl) {
        [para setObject:_imgUrl forKey:@"img"];
    }
    NSString *url = kMatchExpCreate;
    if (isUpdate) {
        url = kMatchExpUpdate;
        [para setObject:@(_itemId?_itemId:0) forKey:@"id"];
    }else{
        [para setObject:@(_resumeId?_resumeId:0) forKey:@"resumeId"];
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
        
    }];
}

#pragma mark -- 创建培训经历 | 修改培训经历
- (void)trainExpCreateOrUpdateTrainExp:(BOOL)isUpdate {
    
    NSArray *titles = self.conDic[kTitles];
    
    NSArray *keys = @[@"name",@"time"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *tmp = titles[i];
        [para setObject:tmp[kContent] forKey:keys[i]];
    }
    
    if (_imgUrl) {
        [para setObject:_imgUrl forKey:@"img"];
    }
    
//    NSMutableDictionary *para = @{
//                                  @"name":@"",
//                                  @"time":@"",
//                                  @"img":@""
//                                  }.mutableCopy;
    
    NSString *url = kTrainExpCreate;
    if (isUpdate) {
        url = kTrainExpUpdate;
        [para setObject:@(_itemId?_itemId:0) forKey:@"id"];
    }else{
        [para setObject:@(_resumeId?_resumeId:0) forKey:@"resumeId"];
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
        
    }];
}

#pragma mark -- 创建工作经历 | 修改工作经历
- (void)workExpCreateOrUpdateWorkExp:(BOOL)isUpdate {
    
    NSArray *titles = self.conDic[kTitles];
    
    NSString *time = titles[2][kContent];
    NSArray *timeArr = [time componentsSeparatedByString:@"-"];
    NSMutableDictionary *para = @{
                                  @"company":titles[0][kContent],
                                  @"position":titles[1][kContent],
                                  @"workStartTime":timeArr.firstObject,
                                  @"workEndTime":timeArr.lastObject,
                                  @"workContent":[titles lastObject][kContent]
                                  }.mutableCopy;
    
    NSString *url = kWorkExpCreate;
    if (isUpdate) {
        url = kWorkExpUpdate;
        [para setObject:@(_itemId?_itemId:0) forKey:@"id"];
    }else{
        [para setObject:@(_resumeId?_resumeId:0) forKey:@"resumeId"];
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
        
    }];
}


#pragma mark -- 删除 比赛经历 | 培训经历 | 工作经历
- (void)deleteItem {
    NSString *url = kMatchExpDel;
    if (self.showInfoEnum == EditResumeJobInfo) {
        url = kWorkExpDel;
    }else if (self.showInfoEnum == EditResumeTrainInfo) {
        url = kTrainExpDel;
    }
    [WebRequest PostWithUrlString:url parms:@{@"id":@(_itemId?_itemId:0)} viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            if (self.DeleteItemBlock) {
                self.DeleteItemBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 企业认证
- (void)enterprisAuth {
    
    NSArray *titles = self.conDic[kTitles];
    
    NSArray *keys = @[@"name",@"phone",@"code",@"position",@"companyName",@"companyIntroduction",@"companyScale",@"companyWelfare"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *tmp = titles[i];
        [para setObject:tmp[kContent] forKey:keys[i]];
    }
    
    [para setObject:_imgUrl?_imgUrl:@"" forKey:@"headImg"];
    [para setObject:_companyLogo?_companyLogo:@"" forKey:@"companLogo"];
    [para setObject:_companyLicense?_companyLicense:@"" forKey:@"companyLicense"];
    NSString *url = kCompanyCreate;
    if (self.itemId > 0) {
        url = kCompanyUpdate;
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
        
    }];
}

#pragma mark -- 线偏移
- (void)viewDidLayoutSubviews {
    if ([infoTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [infoTable setSeparatorInset:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(26), 0, FIT_SCREEN_WIDTH(26))];
    }
    
    if ([infoTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [infoTable setLayoutMargins:UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(26), 0, FIT_SCREEN_WIDTH(26))];
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

# pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    
    if (self.showInfoEnum == EditResumeJobInfo && (textField.tag >= 10001)) {
        
        [self chooseJobTime:textField.tag];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [infoTable addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [infoTable removeGestureRecognizer:tap];
    
    UITableViewCell *cell = textField.tableviewCell;
    
    if (cell != nil) {
        NSIndexPath *index = [infoTable indexPathForCell:cell];
        NSMutableDictionary *mDic = self.conDic[kTitles][index.row];
        [mDic setObject:textField.text forKey:kContent];
    }
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
