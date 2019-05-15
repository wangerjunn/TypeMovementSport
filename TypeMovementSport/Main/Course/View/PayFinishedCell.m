//
//  PayFinishedCell.m
//  TypeMovementSport
//
//  Created by XDH on 2019/1/15.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "PayFinishedCell.h"

@implementation PayFinishedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
        
    }
    return self;
    
}

- (void)createView {
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = Font(K_TEXT_FONT_14);
    _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_titleLabel];
    
    self.infoLabel = [[UILabel alloc] init];
    _infoLabel.font = Font(K_TEXT_FONT_14);
    _infoLabel.textAlignment = NSTextAlignmentRight;
    _infoLabel.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    
    [self.contentView addSubview:_infoLabel];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(46, 6, 120, 14);
    self.infoLabel.frame = CGRectMake(self.frame.size.width - 256, 6, 230, 14);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
