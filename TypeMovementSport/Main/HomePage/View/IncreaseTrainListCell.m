//
//  IncreaseTrainListCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "IncreaseTrainListCell.h"

@implementation IncreaseTrainListCell

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
    CGFloat coorX = 20;
    
    self.logoImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.logoImg];
    
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(coorX);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_height).mas_offset(-16);
    }];
    
    self.titLabel = [LabelTool createLableWithTextColor:k46Color font:Font(15)];
    self.titLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titLabel];
    [self.titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImg.mas_right).offset(8);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(41);
        make.right.mas_equalTo(-coorX);
    }];
    
    self.timeLabel = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titLabel);
        make.top.mas_equalTo(self.titLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    
    self.numberLabel = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.height.mas_equalTo(self.timeLabel);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8);
        
    }];
    
    self.priceLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(12)];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberLabel);
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(65);
    }];
    
    self.orgNameLabel = [LabelTool createLableWithTextColor:k46Color font:Font(10)];
    self.orgNameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.orgNameLabel];
    [self.orgNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLabel);
        make.left.mas_equalTo(self.priceLabel.mas_right);
        make.width.and.top.mas_equalTo(self.priceLabel);
    }];
}

- (void)setModel:(TrainModel *)model {
    _model = model;
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:model.img?model.img:@""] placeholderImage:[UIImage imageNamed:holdImage]];
    
    self.titLabel.text = [NSString stringWithFormat:@"%@",model.title?model.title:@""];
    
    self.timeLabel.text =[NSString stringWithFormat:@"%@⋅%@-%@",model.city?model.city:@"",model.startTime?model.startTime:@"",model.endTime?model.endTime:@""];
    self.priceLabel.text =[NSString stringWithFormat:@"¥%.2f", model.price/100];
    self.orgNameLabel.text = [NSString stringWithFormat:@"%@",model.addr?model.addr:@""];
    self.logoImg.contentMode =  UIViewContentModeScaleAspectFill;
    
    self.logoImg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.logoImg.clipsToBounds  = YES;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人已浏览",model.browseCount];
}
@end
