//
//  Course_theoryPlayCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/11.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "Course_theoryPlayCell.h"

@implementation Course_theoryPlayCell {
    UIImageView *PlayImg;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createViews];
    }
    return self;
    
}
- (void)createViews {
    
    PlayImg = [[UIImageView alloc] init];
    PlayImg.image = [UIImage imageNamed:@"course_play.png"];
    [self.contentView addSubview:PlayImg];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = k75Color;
    self.titleLabel.font = Font(K_TEXT_FONT_12);
    
    [self.contentView addSubview:self.titleLabel];
    
    self.tryWatchLabel = [[UILabel alloc] init];
    self.tryWatchLabel.textColor = kOrangeColor;
    self.tryWatchLabel.font = Font(K_TEXT_FONT_12);
    self.tryWatchLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tryWatchLabel];
}
- (void)layoutSubviews {
    
    PlayImg.frame = CGRectMake(FIT_SCREEN_WIDTH(27.5), (self.height - 16)/2.0, 16, 16);
    
    self.titleLabel.frame = CGRectMake(PlayImg.x + PlayImg.width + FIT_SCREEN_WIDTH(15), 0,150, self.height);
    
    self.tryWatchLabel.frame = CGRectMake(self.width - 120, 0,120, self.height);
}

@end
