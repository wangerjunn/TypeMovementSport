//
//  CouponModel.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/3.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        
        if (_createTime) {
            NSTimeInterval createInterval = [_createTime floatValue] / 1000;
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:createInterval];
           _startTimeStr =  [_dateFormatter stringFromDate:createDate];
        }
        
        
        if (_expireTime) {
            NSTimeInterval createInterval = [_expireTime floatValue] / 1000;
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:createInterval];
            _endTimeStr =  [_dateFormatter stringFromDate:endDate];
        }
        
        _conditionsHeight = 0;
        if ([_remark isNotEmpty]) {
            CGSize size = [UITool sizeOfStr:_remark andFont:Font(K_TEXT_FONT_12)
                                 andMaxSize:CGSizeMake(kScreenWidth - 102 - 81, MAXFLOAT)
                           andLineBreakMode:NSLineBreakByCharWrapping
                                  lineSpace:0];
            
            _conditionsHeight = size.height + 5;
        }
        
    }
    
    return self;
}

@end
