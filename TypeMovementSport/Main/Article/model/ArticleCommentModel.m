//
//  ArticleCommentModel.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleCommentModel.h"

@implementation ArticleCommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
     
        CGSize size = [UITool sizeOfStr:_content
                                                 andFont:Font(K_TEXT_FONT_12)
                                           andMaxSize:CGSizeMake(kScreenWidth - 160, 1000)
                       andLineBreakMode:NSLineBreakByCharWrapping lineSpace:3];
        
        _contentHeight = 36;
        if (size.height > 36) {
            _contentHeight = size.height;
        }
        
    }
    return self;
}
@end
