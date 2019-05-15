//
//  AnswerTableViewCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "ParamFile.h"

@implementation AnswerTableViewCell{
    
    UIView* bgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createViews];
    }
    return self;
    
}
- (void)createViews{


    self.contentView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(28, 0, kScreenWidth-56, self.height - 10)];
    _mainView.layer.cornerRadius = 5;
    _mainView.layer.masksToBounds = YES;
//    [_mainView setCornerRadius:5];
    [self.contentView addSubview:_mainView];
    

    //单行内容
    self.titleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(13)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.frame = CGRectMake(10 + _mainView.left, _mainView.top, _mainView.width - 20, _mainView.height);
    [self.contentView addSubview:self.titleLabel];
    
}

@end
