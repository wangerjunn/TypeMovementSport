//
//  PositionDetailCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/20.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PositionDetailCell.h"

@implementation PositionDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        CGFloat coorX = FIT_SCREEN_WIDTH(26);
        self.contentLabel.frame = CGRectMake(coorX, FIT_SCREEN_HEIGHT(5), kScreenWidth-coorX*2, 20);
        [self.contentView addSubview:self.contentLabel];
        
        self.line = [[UIView alloc]initWithFrame:CGRectMake(self.contentLabel.left, self.contentLabel.bottom, self.contentLabel.width+5, 0.5)];
        self.line.backgroundColor = LaneCOLOR;
        [self.contentView addSubview:self.line];
    }
    
    return self;
}

- (void)setContentStr:(NSString *)contentStr fontSize:(CGFloat)fontSize{
    CGSize size = [UITool sizeOfStr:contentStr andFont:Font(fontSize) andMaxSize:CGSizeMake(self.contentLabel.width, 1000) andLineBreakMode:NSLineBreakByCharWrapping lineSpace:3];
    
    self.contentLabel.size = CGSizeMake(self.contentLabel.width, size.height);
    
    self.contentLabel.font = Font(fontSize);
    
    self.contentLabel.text = contentStr;
    
    self.line.top = self.contentLabel.bottom+5;
}
@end
