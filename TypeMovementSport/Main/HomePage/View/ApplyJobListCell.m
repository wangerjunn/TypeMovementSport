//
//  ApplyJobListCell.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ApplyJobListCell.h"

@implementation ApplyJobListCell {
    UIView *lane;
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
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createViews];
    }
    return self;
    
}
- (void)createViews {
    
    self.headImg = [[UIImageView alloc] init];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = FIT_SCREEN_WIDTH(30)/2.0;
    self.headImg.clipsToBounds = YES;
    [self.contentView addSubview:self.headImg];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = BoldFont(15);
    self.titleLabel.textColor = k46Color;
    [self.contentView addSubview:self.titleLabel];
    
    self.companyLabel = [[UILabel alloc] init];
    self.companyLabel.font = Font(12);
    self.companyLabel.textColor = k46Color;
    [self.contentView addSubview:self.companyLabel];
    
    self.salaryLabel = [[UILabel alloc] init];
    self.salaryLabel.font = Font(12);
    self.salaryLabel.textColor = kOrangeColor;
    [self.contentView addSubview:self.salaryLabel];
    
    self.salaryLabel = [[UILabel alloc] init];
    self.salaryLabel.font = Font(10);
    self.salaryLabel.textColor = k210Color;
    self.salaryLabel.textAlignment = NSTextAlignmentCenter;
    
    self.salaryLabel.layer.masksToBounds = YES;
    self.salaryLabel.layer.borderWidth = 1;
    self.salaryLabel.layer.borderColor = k210Color.CGColor;
    [self.contentView addSubview:self.salaryLabel];
    
    self.experienceLabel = [[UILabel alloc] init];
    self.experienceLabel.font = Font(10);
    self.experienceLabel.textColor = k210Color;
    self.experienceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.experienceLabel.layer.masksToBounds = YES;
    self.experienceLabel.layer.borderWidth = 1;
    self.experienceLabel.layer.borderColor = k210Color.CGColor;
    [self.contentView addSubview:self.experienceLabel];
    
    self.educationLevelLabel = [[UILabel alloc] init];
    self.educationLevelLabel.font = Font(10);
    self.educationLevelLabel.textColor = k210Color;
    self.educationLevelLabel.textAlignment = NSTextAlignmentCenter;
    
    self.educationLevelLabel.layer.masksToBounds = YES;
    self.educationLevelLabel.layer.borderWidth = 1;
    self.educationLevelLabel.layer.borderColor = k210Color.CGColor;
    [self.contentView addSubview:self.educationLevelLabel];
    
    
    self.suffixLabel = [[UILabel alloc] init];
    self.suffixLabel.font = Font(12);
    self.suffixLabel.textColor = k46Color;
    [self.contentView addSubview:self.suffixLabel];
    
    lane = [[UIView alloc] init];
    lane.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:lane];
    
}
- (void)layoutSubviews {
    
    CGSize size = [ self.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    self.titleLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(14), 15, JGlabelContentWidth, 15);
    
    self.companyLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom + FIT_SCREEN_HEIGHT(9), kScreenWidth - FIT_SCREEN_WIDTH(61) - FIT_SCREEN_WIDTH(14) - FIT_SCREEN_WIDTH(14), 12);
    
    CGSize size1 = [ self.salaryLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.salaryLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth1 = size1.width;
    self.salaryLabel.frame = CGRectMake(self.width - FIT_SCREEN_WIDTH(24) -JGlabelContentWidth1 , 16, JGlabelContentWidth1, 12);
    
    CGSize size2 = [ self.salaryLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.salaryLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth2 = size2.width + 15;
    self.salaryLabel.frame = CGRectMake(self.companyLabel.left, self.companyLabel.bottom + FIT_SCREEN_HEIGHT(9), JGlabelContentWidth2, 14);
    
    CGSize size3 = [ self.experienceLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.experienceLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth3 = size3.width +15;
    self.experienceLabel.frame = CGRectMake(self.salaryLabel.right + FIT_SCREEN_WIDTH(10) , self.salaryLabel.top, JGlabelContentWidth3, 14);
    
    CGSize size4 = [ self.educationLevelLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.educationLevelLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth4 = size4.width + 15;
    self.educationLevelLabel.frame = CGRectMake(self.experienceLabel.right + FIT_SCREEN_WIDTH(10) , self.salaryLabel.top, JGlabelContentWidth4, 14);
    
    self.educationLevelLabel.layer.cornerRadius = self.educationLevelLabel.width*0.1;
    self.experienceLabel.layer.cornerRadius = self.experienceLabel.width*0.1;
    self.salaryLabel.layer.cornerRadius = self.salaryLabel.width*0.1;
    
    
    self.headImg.frame = CGRectMake(FIT_SCREEN_WIDTH(14), self.salaryLabel.bottom + FIT_SCREEN_HEIGHT(14), FIT_SCREEN_WIDTH(30), FIT_SCREEN_WIDTH(30));
    
    
    CGSize size5 = [ self.suffixLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.suffixLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth5 = size5.width;
    self.suffixLabel.frame = CGRectMake(self.headImg.right + FIT_SCREEN_WIDTH(14), self.headImg.top, JGlabelContentWidth5, self.headImg.height);
    
    lane.frame = CGRectMake(FIT_SCREEN_WIDTH(14), self.height - 0.5, self.width - FIT_SCREEN_WIDTH(28), 0.5);
}

- (void)setModel:(PositionModel *)model {
    _model = model;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.company[@"headImg"]] placeholderImage:[UIImage imageNamed:holdFace]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name?model.name:@""];
    self.salaryLabel.text = [NSString stringWithFormat:@"%@",model.hopealary?model.hopealary:@""];
    self.companyLabel.text = model.company[@"companyName"];
    self.addressLabel.text = [NSString stringWithFormat:@"城市:%@",model.addr?model.addr:@""];
    if (model.exp) {
        self.experienceLabel.text = [NSString stringWithFormat:@"经验:%@",model.exp];
    }
    if (model.education) {
        self.educationLevelLabel.text =[NSString stringWithFormat:@"学历:%@",model.education];
    }
   
   self.suffixLabel.text = [NSString stringWithFormat:@"%@∙%@",model.company[@"name"],model.company[@"position"]];
    
    if ([model.state isEqualToString:@"CLOSE"]) {
        self.titleLabel.textColor = k210Color;
        self.companyLabel.textColor = k210Color;
        self.suffixLabel.textColor = k210Color;
    }
}
@end
