//
//  MyTrainListCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "MyTrainListCell.h"
#import "ParamFile.h"

@implementation MyTrainListCell

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
    self.logoImg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.logoImg];
    
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7.5);
        make.centerY.mas_equalTo(self);
        make.width.and.height.mas_equalTo(kScreenWidth/2.5-15);
    }];
    
    self.titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(15)];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImg.mas_right).offset(15);
        make.top.mas_equalTo(self.logoImg).offset(15);
        make.right.mas_equalTo(self.right).offset(-15);
        make.height.mas_equalTo(17);
    }];
    
    self.lessonTimeLabel = [LabelTool createLableWithTextColor:k75Color font:Font(10)];
    [self.contentView addSubview:self.lessonTimeLabel];
    
    [self.lessonTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
    }];
    
    self.cityLabel = [LabelTool createLableWithTextColor:k75Color font:Font(10)];
    self.cityLabel.numberOfLines = 0;
    [self.contentView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.lessonTimeLabel);
        make.top.mas_equalTo(self.lessonTimeLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(25);
    }];
    
    self.paymentLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(12)];
    [self.contentView addSubview:self.paymentLabel];
    
    [self.paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.cityLabel);
        make.top.mas_equalTo(self.cityLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(15);
    }];
    
}

- (void)setModel:(TrainModel *)model {
    _model = model;
    
    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:model.img?model.img:@""] placeholderImage:[UIImage imageNamed:holdImage]];
    self.titleLabel.text = model.title?model.title:@"";
    self.cityLabel.text = [NSString stringWithFormat:@"城市：%@",model.addr?model.addr:@""];
    self.lessonTimeLabel.text = [NSString stringWithFormat:@"开课时间: %@", model.startTime?model.startTime:@""];
    //    if (indexPath.row == 0) {
    ////        cell.paymentBtn.hidden = YES;
    //        cell.paymentLabel.hidden = NO;
    //
    self.paymentLabel.text = @"进行中";
    //    } else if (indexPath.row == 2) {
    ////        cell.paymentBtn.hidden = YES;
    //        cell.paymentLabel.hidden = NO;
    //
    //        cell.paymentLabel.text = @"已结课";
    //    } else {
    //        cell.lessonTimeLabel.textColor = [UIColor colorWithHexString:@"#ff4d24"];
    ////        cell.paymentBtn.hidden = NO;
    //        cell.paymentLabel.hidden = YES;
    //    }
    
    //    cell.paymentBtn.tag = indexPath.row + 1000;
    //    [cell.paymentBtn addTarget:self action:@selector(commentTradoAction:) forControlEvents:UIControlEventTouchUpInside];
}

@end
