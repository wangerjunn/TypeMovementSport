//
//  ExamModel.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ExamModel.h"

@implementation ExamModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        
        _curSeleIndex = -1;
        
        _contentHeight = [UITool sizeOfStr:_content andFont:BoldFont(13) andMaxSize:CGSizeMake(kScreenWidth-56, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping lineSpace:10].height;
        
        if (_a) {
            _aHeight = [UITool sizeOfStr:_a andFont:Font(K_TEXT_FONT_14) andMaxSize:CGSizeMake(kScreenWidth-76, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping].height;
        }
        
        if (_b) {
            _bHeight = [UITool sizeOfStr:_b andFont:Font(K_TEXT_FONT_14) andMaxSize:CGSizeMake(kScreenWidth-76, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping].height;
        }
        
        if (_c) {
            _cHeight = [UITool sizeOfStr:_c andFont:Font(K_TEXT_FONT_14) andMaxSize:CGSizeMake(kScreenWidth-76, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping].height;
        }
        
        if (_d) {
            _dHeight = [UITool sizeOfStr:_d andFont:Font(K_TEXT_FONT_14) andMaxSize:CGSizeMake(kScreenWidth-76, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping].height;
        }
    }
    
    
    return self;
}
@end
