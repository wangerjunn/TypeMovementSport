//
//  View_PickerView.m
//  GoToSchool
//
//  Created by XDH on 16/3/31.
//  Copyright © 2016年 UI. All rights reserved.
//

#define KTitleName @"title"
#define KArrayName @"data"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define klineGray [UIColor colorWithRed:208.f/255 green:208.f/255 blue:208.f/255 alpha:1.00f]
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#import "View_PickerView.h"
//#import "CustomAlertView.h"

@interface View_PickerView ()<
    UIPickerViewDelegate,
    UIPickerViewDataSource>
{
    UIView *view_bg;
    NSArray *arr_titles;//展示内容数组
    NSInteger curComponents;//当前展示的联动组
    BOOL isDateOrNo;//YES时时间选择器，NO pickerview
    NSInteger curRow;//第1级联动row
    NSInteger thirdRow;//第二级联动row
    NSString *str_title;//1个component
    NSString *str_subTitle;//当2个components时标题
    NSString *str_thirdTitle;//三级标题
    
    UIDatePickerMode pickerMode;
    
    
    BOOL isCustomDatePicker;
    NSInteger firDaysOfMonth;//第一个月天数
    NSInteger secDaysOfMonth;//第二个月天数
    
    NSInteger firSeleDay;//选中日期
    NSInteger firSeleMonth;//选中月
    
    NSInteger secSeleDay;//第二个选中日期
    NSInteger secSeleMonth;//选中月
    
    NSString *curDefaultYear;//日期默认年份
}

@property (copy, nonatomic) NSString *dateFormat;
@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;

@end

@implementation View_PickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -- UIPickerView

/**
 UIPickerView

 @param arr 数组内容，1组内容时数组内为NSString类型
            数组内容大于2组时，数据格式为 [
                                        {
                                            title:title;
                                            data:[{
                                                     title:title;
                                                     data:[{
 
                                                     }]
                                                 },]
                                         },
                                     ]
 
 @param title viewTitle
 @param clickDoneBlock 点击完成回调
 @param numberOfCompoent 分组内容
 @return self
 */
- (instancetype)initPickerViewByArr:(NSArray *)arr
                              title:(NSString *)title
                              block:(ClickDoneBlock)clickDoneBlock
                  numberOfComponent:(NSInteger)numberOfCompoent {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        //初始化
        curRow = 0;
        arr_titles = arr;
        curComponents = numberOfCompoent;
        
        switch (numberOfCompoent) {
            case 1:
            {
                if (arr_titles.count > 0) {
                    str_title = arr_titles[0];
                }
                break;
            }case 2:
            {
                if (arr_titles.count > 0) {
                    str_title = arr_titles[0][KTitleName];
                    NSArray *arr = arr_titles[0][KArrayName];
                    if (arr.count > 0) {
                        str_subTitle = arr[0][KTitleName];
                    }
                }
                break;
            }case 3:
            {
                thirdRow = 0;
                if (arr_titles.count > 0) {
                    str_title = arr_titles[0][KTitleName];
                    NSArray *arr = arr_titles[0][KArrayName];
                    if (arr.count > 0) {
                        str_subTitle = arr[0][KTitleName];
                        NSArray *thirdArr = arr[0][KArrayName];
                        if (thirdArr.count > 0) {
                            str_thirdTitle = thirdArr[0][KTitleName];
                        }
                    }
                }
                break;
            }
                
            default:
                break;
        }
        
        self.clickDoneBlock = clickDoneBlock;
        
        view_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view_bg.backgroundColor = [UIColor clearColor];
        view_bg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        [view_bg addGestureRecognizer:tap];
        
        [self initPickerViewByTitle:title datePicker:NO];
        [self addSubview:view_bg];
        
    }
    
    return self;
}


/**
 初始化view

 @param title viewTitle
 @param isDatePicker Y:UIDatePicker,N:UIPickerView
 */
- (void)initPickerViewByTitle:(NSString *)title
                   datePicker:(BOOL)isDatePicker {
    
    isDateOrNo = isDatePicker;
    UIView *view = [[UIView alloc]initWithFrame:
                    CGRectMake(0, kScreenHeight,
                               kScreenWidth, 470/2.0)];
    
    //add single Gesture
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(clickView)];
    [view addGestureRecognizer:tap];
    view.tag = 100;
    view.backgroundColor = [UIColor whiteColor];
    [view_bg addSubview:view];
    
    UILabel *lbl_title = [[UILabel alloc]initWithFrame:
                          CGRectMake(0, 0, kScreenWidth, 40)];
    lbl_title.textAlignment = NSTextAlignmentCenter;
    lbl_title.font = [UIFont systemFontOfSize:15];
    lbl_title.text = title;
    [view addSubview:lbl_title];
    //取消按钮
    UIButton *btn_cancel = [[UIButton alloc]initWithFrame:
                            CGRectMake(0, 0, 60,
                                       HEIGHT(lbl_title))];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    btn_cancel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [btn_cancel setTitleColor:[UIColor blackColor]
                   forState:UIControlStateNormal];
    
    [btn_cancel addTarget:self
                   action:@selector(removeSelf)
         forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn_cancel];

    //完成按钮
    UIButton *btn_done = [[UIButton alloc]initWithFrame:
                          CGRectMake(kScreenWidth-60, 0, 60,
                                     HEIGHT(lbl_title))];
    [btn_done setTitle:@"完成" forState:UIControlStateNormal];
    btn_done.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [btn_done setTitleColor:[UIColor blackColor]
                   forState:UIControlStateNormal];
    
    [btn_done addTarget:self
                 action:@selector(showSelectedCon)
       forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn_done];
    
    UIImageView *img_line = [[UIImageView alloc]initWithFrame:
                             CGRectMake(0, MaxY(btn_done), kScreenWidth, 1)];
    img_line.backgroundColor = klineGray;
    [view addSubview:img_line];
    
    if (isDatePicker) {
        //时间选择器
        UIDatePicker* datePiker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, MaxY(img_line), kScreenWidth, HEIGHT(view)-MaxY(img_line))];
        datePiker.backgroundColor = [UIColor whiteColor];
        datePiker.tag = 101;
        
        
        if (_maxDate) {
            datePiker.maximumDate = _maxDate;
        }
        
        if (_minDate) {
            datePiker.minimumDate = _minDate;
        }
        
//        if (pickerMode) {
            datePiker.datePickerMode = pickerMode;
//        }
        if ([_dateFormat isEqualToString:@"HH:mm"]) {
            [datePiker setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
        }else{
            [datePiker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
        }
        
        [view addSubview:datePiker];
        
    }else{
        
        //-(isCustomDatePicker?kScreenWidth/2.0-25:0)
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, MaxY(img_line), kScreenWidth, HEIGHT(view)-MaxY(img_line))];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.tag = 1000;
        
        [view addSubview:pickerView];
        
        if (isCustomDatePicker) {
            
            [pickerView selectRow:firSeleMonth-1 inComponent:0 animated:YES];
            [pickerView selectRow:firSeleDay-1 inComponent:1 animated:YES];
            
            [pickerView selectRow:secSeleMonth-1 inComponent:3 animated:YES];
            [pickerView selectRow:secSeleDay-1 inComponent:4 animated:YES];

        }
        
    }
    
}

#pragma mark -- single Gesture
- (void)clickView {
    
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (isCustomDatePicker) {
        return 5;
    }
    return curComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
        {
            if (isCustomDatePicker) {
                return 12;
            }
            return arr_titles.count;
        }case 1:
        {
            if (isCustomDatePicker) {
                return firDaysOfMonth;
            }
            if (arr_titles.count > curRow) {
                NSArray *arr_subTitles = arr_titles[curRow][KArrayName];
                return arr_subTitles.count;
            }
        }case 2:
        {
            if (isCustomDatePicker) {
                return 1;
            }
            if (arr_titles.count > curRow) {
                NSArray *arr_subTitles = arr_titles[curRow][KArrayName];
                if (arr_subTitles.count > thirdRow) {
                    NSArray *thirdArr = arr_subTitles[thirdRow][KArrayName];
                    return thirdArr.count;
                }
            }
        }case 3:{
            return 12;
        }case 4:{
            return secDaysOfMonth;
        }
            
        default:
            break;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
        {
            if (isCustomDatePicker) {
                return [NSString stringWithFormat:@"%.2ld",(long)row+1];
            }
            if (curComponents == 1) {
                return [NSString stringWithFormat:@"%@",arr_titles[row]];
            }
            if (row < arr_titles.count) {
                NSDictionary *dict = arr_titles[row];
                return [NSString stringWithFormat:@"%@",dict[KTitleName]];
            }
        }case 1:
        {
            if (isCustomDatePicker) {
                return [NSString stringWithFormat:@"%.2ld",(long)row+1];
            }
            if (arr_titles.count > curRow) {
                NSArray *arr_subTitle = arr_titles[curRow][KArrayName];
                if (row < arr_subTitle.count) {
                    NSDictionary *dic = arr_subTitle[row];
                    return dic[KTitleName];
                }
            }
        }case 2:
        {
            if (isCustomDatePicker) {
                return @"至";
            }
            if (arr_titles.count > curRow) {
                NSArray *arr_subTitle = arr_titles[curRow][KArrayName];
                if (thirdRow < arr_subTitle.count) {
                    NSArray *thirdArr = arr_subTitle[thirdRow][KArrayName];
                    if (thirdArr.count > row) {
                        NSDictionary *dic = thirdArr[row];
                        return dic[KTitleName];
                    }
                }
            }
        }case 3:{
            
        }case 4:{
            return [NSString stringWithFormat:@"%.2ld",(long)row+1];
        }
            
        default:
            break;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    switch (component) {
        case 0:
        {
            if (isCustomDatePicker) {
                
                if (pickerView.tag == 1000) {
                    firSeleMonth = row+1;
                    firDaysOfMonth = [self getDaysByMonth:firSeleMonth];
                    firSeleDay = 1;
                    [pickerView reloadComponent:1];
                    
                    [pickerView selectRow:0 inComponent:1 animated:YES];
                }
                
                return;
            }
            curRow = row;
            if (arr_titles.count > row) {
                //获取一级内容
                if (curComponents == 1) {
                    str_title = [NSString stringWithFormat:@"%@",arr_titles[row]];
                }else{
                    str_title = arr_titles[row][KTitleName];
                    if (curComponents == 2) {
                        //2级联动时，滑动一级，二级更新数据
                        
                        //获取二级数据
                        NSArray *subArr = arr_titles[row][KArrayName];
                        if (subArr.count > 0) {
                            //二级标题
                            str_subTitle = subArr[0][KTitleName];
                            [pickerView reloadComponent:1];
                            [pickerView selectRow:0 inComponent:1 animated:YES];
                        }
                        
                        
                    }else if (curComponents == 3){
                        
                        //三级联动时，滚动一级时，二级，三级更新数据
                        
                        thirdRow = 0;
                        
                        //判断一级数据
                        if (arr_titles.count > row) {
                            
                            //二级数据
                            NSArray *subArr = arr_titles[row][KArrayName];
                            if (subArr.count > 0) {
                                //二级标题
                                str_subTitle = subArr[0][KTitleName];
                                
                                //三级数据
                                NSArray *thirdArr = subArr[0][KArrayName];
                                if (thirdArr.count > 0) {
                                    //三级标题
                                    str_thirdTitle = thirdArr[0][KTitleName];
                                    
                                    //更新二级数据
                                    [pickerView reloadComponent:1];
                                    [pickerView selectRow:0 inComponent:1 animated:YES];
                                    //更新三级数据
                                    [pickerView reloadComponent:2];
                                    [pickerView selectRow:0 inComponent:2 animated:YES];
                                }
                                
                            }
                            
                        }
                    }
                }
                
            }
            
            break;
        }case 1:
        {
            //操作二级联动时
            
            if (isCustomDatePicker) {
                
                firSeleDay = row+1;
                return;
            }
            
            if (curComponents == 2) {
                //数据只有二级时,获取二级数据
                NSArray *arr = arr_titles[curRow][KArrayName];
                if (arr.count > row) {
                    str_subTitle = arr[row][KTitleName];
                }
            }else{
                //操作二级联动时更新三级联动数据
                
                //先获取二级数据
                NSArray *arr = arr_titles[curRow][KArrayName];
                if (arr.count > row) {
                    str_subTitle = arr[row][KTitleName];
                    thirdRow = row;
                    
                    //获取三级数据，默认展示第0个
                    NSArray *subArr = arr[row][KArrayName];
                    if (subArr.count > 0) {
                        str_thirdTitle = subArr[0][KTitleName];
                        
                        [pickerView reloadComponent:2];
                        [pickerView selectRow:0 inComponent:2 animated:YES];
                    }
                }
            }
            break;
        }case 2:
        {
            if (isCustomDatePicker) {
                return;
            }
            //三级联动
            if (arr_titles.count > curRow) {
                //先获取二级数据
                NSArray *subArr = arr_titles[curRow][KArrayName];
                if (subArr.count > thirdRow) {
                    //获取三级数据
                    NSArray *thirdArr = subArr[thirdRow][KArrayName];
                    
                    if (thirdArr.count > row) {
                        str_thirdTitle = thirdArr[row][KTitleName];
                    }
                    
                }
            }
            
            break;
        }case 3:{
            secSeleMonth = row+1;
            secDaysOfMonth = [self getDaysByMonth:secSeleMonth];
            secSeleDay = 1;
            [pickerView reloadComponent:4];
            
            [pickerView selectRow:0 inComponent:4 animated:YES];
            break;
        }case 4:{
            secSeleDay = row+1;
            break;
        }
            
        default:
            break;
    }
    
}

//点击完成，显示已选择内容
- (void)showSelectedCon {
    if (isDateOrNo) {
        
        UIView *view = (UIView *)[view_bg viewWithTag:100];
        
        
        NSDate *date = [(UIDatePicker *)[view viewWithTag:101] date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        
        if (self.dateFormat) {
            [dateFormatter setDateFormat:self.dateFormat];
        }else{
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            
        }
        
        NSString *str_date = [dateFormatter stringFromDate:date];
        self.clickDoneBlock(str_date);
        
    }else{
        
        if (isCustomDatePicker) {
            
            NSInteger curYear = [curDefaultYear integerValue];
            if (firSeleMonth > secSeleMonth) {
                curYear-=1;
//                [[CustomAlertView shareCustomAlertView] showAlertViewWtihTitle:@"时间格式不正确" viewController:nil];
//                return;
            }else {
                if (firSeleMonth == secSeleMonth) {
                    if (firSeleDay > secSeleDay) {
                        curYear-=1;
//                        [[CustomAlertView shareCustomAlertView] showAlertViewWtihTitle:@"时间格式不正确" viewController:nil];
//                        return;
                    }
                }
                
                
            }
            
            NSString *str_temp = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld~%@-%.2ld-%.2ld",(long)curYear,(long)firSeleMonth,(long)firSeleDay,curDefaultYear,(long)secSeleMonth,(long)secSeleDay];
            self.clickDoneBlock(str_temp);
            
        }else{
            switch (curComponents) {
                case 1:
                {
                    //一级联动
                    self.clickDoneBlock(str_title?str_title:@"");
                    break;
                }case 2:
                {
                    //二级联动
                    NSString *str_temp = [NSString stringWithFormat:@"%@,%@",str_title?str_title:@"",str_subTitle?str_subTitle:@""];
                    self.clickDoneBlock(str_temp);
                    break;
                }case 3:
                {
                    //三级联动
                    NSString *str_temp = [NSString stringWithFormat:@"%@,%@,%@",str_title?str_title:@"",str_subTitle?str_subTitle:@"",str_thirdTitle?str_thirdTitle:@""];
                    self.clickDoneBlock(str_temp);
                    break;
                }
                    
                default:
                    break;
            }
        }
        
        
    }
    
    [self removeSelf];
}

- (void)removeSelf {
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.35 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        UIView *view = (UIView*)[strongSelf->view_bg viewWithTag:100];
        strongSelf->view_bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        view.transform = CGAffineTransformMakeTranslation
        (0, 470/2.0);
        //view_bg.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        //view_lendFace.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark -- UIDatePickerView
- (instancetype)initDatePickerViewByViewTitle:(NSString *)viewTitle
                                      minDate:(NSDate *)minDate
                                      maxDate:(NSDate *)maxDate
                             UIDatePickerMode:(UIDatePickerMode)mode
                                   dateFormat:(NSString *)dateFormat
                               clickDoneBlock:(ClickDoneBlock)block {
    
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        //初始化
        self.backgroundColor = [UIColor clearColor];
        
        if (minDate) {
            _minDate = minDate;
        }
        
        if (maxDate) {
            _maxDate = maxDate;
        }
        
        _dateFormat = dateFormat;
        self.clickDoneBlock = block;
        
        pickerMode = mode;
        view_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view_bg.backgroundColor = [UIColor clearColor];
        view_bg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        [view_bg addGestureRecognizer:tap];
        
        [self initPickerViewByTitle:viewTitle?viewTitle:@"" datePicker:YES];
        [self addSubview:view_bg];
        
    }
    
    return self;
}


- (instancetype)initCustomTimeByViewTitle:(NSString *)viewTitle seleTime:(NSString *)seleTime clickDoneBlock:(ClickDoneBlock)block {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        //初始化
        self.backgroundColor = [UIColor clearColor];
        
        self.clickDoneBlock = block;
        
        isCustomDatePicker = YES;
        
        if (seleTime) {
            NSArray *arr = [seleTime componentsSeparatedByString:@"~"];
            
            
            if (arr.count > 0) {
                
                NSString *tmpStartTime = arr.firstObject;
                
                NSArray *tmpStartArr = [tmpStartTime componentsSeparatedByString:@"-"];
                firSeleDay = [tmpStartArr.lastObject integerValue];
                firSeleMonth = [tmpStartArr.firstObject integerValue];
                
                if (arr.count == 2) {
                    
                    NSString *tmpEndTime = arr.lastObject;
                    NSArray *tmpEndArr = [tmpEndTime componentsSeparatedByString:@"-"];
                    secSeleDay = [tmpEndArr.lastObject integerValue];
                    secSeleMonth = [tmpEndArr.firstObject integerValue];
                }else{
                    //无结束时间
                    NSString *startTime = [self getTimeByStartTime:tmpStartTime timeStamp:7*24*60*60];
                    NSArray *endTimeArr = [startTime componentsSeparatedByString:@"-"];
                    
                    secSeleMonth = [endTimeArr.firstObject integerValue];
                    
                    secSeleDay = [endTimeArr.lastObject integerValue];
                }
            }
            
            
        }
        
        firDaysOfMonth = [self getDaysByMonth:firSeleMonth];
        secDaysOfMonth = [self getDaysByMonth:secDaysOfMonth];
        
        view_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view_bg.backgroundColor = [UIColor clearColor];
        view_bg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        [view_bg addGestureRecognizer:tap];
        
        [self initPickerViewByTitle:viewTitle?viewTitle:@"" datePicker:NO];
        [self addSubview:view_bg];
    }
    
    return self;
}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    TO_WEAK(self, weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->view_bg.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        UIView *view = (UIView*)[strongSelf->view_bg viewWithTag:100];
        view.transform = CGAffineTransformMakeTranslation
        (0, -470/2.0);
    }];

}

- (NSInteger)getDaysByMonth:(NSInteger )month {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *curDateStr = [formatter stringFromDate:date];
    
    NSArray *dateArr = [curDateStr componentsSeparatedByString:@"-"];
    
    //当前默认年份
    curDefaultYear = dateArr.firstObject;
    
    if (!firSeleMonth) {
        
        secSeleMonth = [dateArr[1] integerValue];
        secSeleDay = [dateArr.lastObject integerValue];
        
        NSString *tmpEndTime = [NSString stringWithFormat:@"%ld-%ld",(long)secSeleMonth,(long)secSeleDay];
        NSString *tmpStartTimeStr = [self getTimeByStartTime:tmpEndTime timeStamp:-7*24*60*60];
        NSArray *startTimeArr = [tmpStartTimeStr componentsSeparatedByString:@"-"];
        
        firSeleDay = [startTimeArr.lastObject integerValue];
        firSeleMonth = [startTimeArr.firstObject integerValue];
//        secSeleMonth = firSeleMonth;
//        secSeleDay = firSeleDay;
    }
    
    
    if (!month) {
        month = [dateArr[1] integerValue];
    }
    curDateStr = [NSString stringWithFormat:@"%@-%.2ld-01",dateArr.firstObject,(long)month];
    
    NSDate *tmpDate = [formatter dateFromString:curDateStr];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:tmpDate];
    
    return range.length;
}

- (NSString *)getTimeByStartTime:(NSString *)startTime timeStamp:(NSTimeInterval)timeInterval {
    NSDate *date = [self dateStrTransferDate:startTime formatter:@"MM-dd"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"MM-dd"];
    
    NSDate *classEndDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:date];
    
    NSString *targetDateStr = [df stringFromDate:classEndDate];
    
    return targetDateStr;
}

- (NSDate *)dateStrTransferDate:(NSString *)dateStr formatter:(NSString *)formatter {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:formatter];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}


@end
