//
//  CalendarFlowLayout.m
//  TypeMovementSport
//
//  Created by XDH on 2019/2/24.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "CalendarFlowLayout.h"

@implementation CalendarFlowLayout

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    
    //从第二个循环到最后一个
    for(int i = 0; i < [attributes count]; i++) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        
        CGRect frame = currentLayoutAttributes.frame;
        NSInteger column = i / 7;
        frame.origin.y = column * self.itemSize.height;
        if (i % 7 == 0) {
            frame.origin.x = 0;
        }else {
            frame.origin.x = (i % 7 ) * (self.itemSize.width + self.minimumInteritemSpacing);
        }
        currentLayoutAttributes.frame = frame;
        
    }
    
    return attributes;
}



@end
