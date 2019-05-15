//
//  IncreaseVideoPayOrFreeCell.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/3.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "IncreaseVideoPayOrFreeCell.h"

@implementation IncreaseVideoPayOrFreeCell

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
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    CGFloat coorX = FIT_SCREEN_WIDTH(13);
    CGFloat wdt = FIT_SCREEN_WIDTH(18);
    
    self.numLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_10)];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.text = @"1";
    self.numLabel.frame = CGRectMake(coorX, FIT_SCREEN_HEIGHT(60)/2.0-wdt/2.0, wdt, wdt);
    [self.contentView addSubview:self.numLabel];
    
    //视频图标
    self.videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"course_play"]];
    self.videoIcon.frame = CGRectMake(self.width - coorX - wdt, self.numLabel.top, wdt, wdt);
    [self.contentView addSubview:self.videoIcon];
    
    self.conLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    self.conLabel.numberOfLines = 0;
    self.conLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.conLabel.frame = CGRectMake(self.numLabel.right + FIT_SCREEN_WIDTH(19), 0, self.videoIcon.left - self.numLabel.right - FIT_SCREEN_WIDTH(19*2), FIT_SCREEN_HEIGHT(60));
    self.conLabel.text = @"器械练习";
    [self.contentView addSubview:self.conLabel];
}
@end
