//
//  ReviewQuestionCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/16.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ReviewQuestionCell.h"

@implementation ReviewQuestionCell

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
    
    self.titleLab = [LabelTool createLableWithTextColor:k46Color font:Font(13)];
    self.titleLab.frame = CGRectMake(coorX, 0, kScreenWidth - coorX*2, 40);
    self.titleLab.numberOfLines = 0;
    self.titleLab.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.titleLab];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom+1, self.titleLab.width+5, 0.5)];
    line.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:line];
    
    UILabel *rightTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(13)];
    rightTitleLabel.frame = CGRectMake(_titleLab.left, line.bottom+8, _titleLab.width/2.0, 21);
    rightTitleLabel.text = @"正确：";
    [self.contentView addSubview:rightTitleLabel];
    
    self.rightLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(13)];
    self.rightLabel.frame = CGRectMake(rightTitleLabel.right, rightTitleLabel.top, rightTitleLabel.width, rightTitleLabel.height);
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    
    UILabel *wrongTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(13)];
    wrongTitleLabel.frame = CGRectMake(_titleLab.left, rightTitleLabel.bottom+8, rightTitleLabel.width, rightTitleLabel.height);
    wrongTitleLabel.text = @"错误：";
    [self.contentView addSubview:wrongTitleLabel];
    
    self.wrongLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(13)];
    self.wrongLabel.frame = CGRectMake(rightTitleLabel.right, wrongTitleLabel.top, wrongTitleLabel.width, wrongTitleLabel.height);
    self.wrongLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.wrongLabel];
    
    
    UILabel *rightRateTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(13)];
    rightRateTitleLabel.frame = CGRectMake(_titleLab.left, wrongTitleLabel.bottom+8, rightTitleLabel.width, rightTitleLabel.height);
    rightRateTitleLabel.text = @"正确率：";
    [self.contentView addSubview:rightRateTitleLabel];
    
    self.rightRateLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(13)];
    self.rightRateLabel.frame = CGRectMake(rightTitleLabel.right, rightRateTitleLabel.top, wrongTitleLabel.width, wrongTitleLabel.height);
    self.rightRateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightRateLabel];
    
}

- (void)setModel:(QuestionModel *)model {
    _model = model;
    
//    self.titleLab.text = [NSString stringWithFormat:@"测试试卷：健身教练国职展业模拟理论考试-初级 第%ld套",(long)indexPath.section+1];
     self.titleLab.text = [NSString stringWithFormat:@"测试试卷：%@",model.name];
    self.rightLabel.text = [NSString stringWithFormat:@"%ld",(long)model.successCount];
    self.wrongLabel.text = [NSString stringWithFormat:@"%ld",(long)model.errorCount];
    self.rightRateLabel.text = [NSString stringWithFormat:@"%.2f%%",((CGFloat)model.successCount / (model.successCount + model.errorCount))*100];
}

@end
