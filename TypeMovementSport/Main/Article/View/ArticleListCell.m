//
//  ArticleListCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleListCell.h"

@implementation ArticleListCell {
    UIView *bgView;
    UIImageView *yinYingImg;
    UIImageView *bgImg;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createViews];
    }
    return self;
    
}
- (void)createViews {
    bgImg  = [[UIImageView alloc] init];
    bgImg.layer.masksToBounds = YES;
    bgImg.layer.cornerRadius = 10;
    bgImg.image = [UIImage imageNamed:@"article_bg"];
    [self.contentView addSubview:bgImg];
    
    bgView = [[UIView alloc]init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    self.shouImg = [[UIImageView alloc] init];
    self.shouImg.layer.masksToBounds = YES;
    self.shouImg.layer.cornerRadius = 5;
    [self.shouImg setContentMode:UIViewContentModeScaleAspectFill];
    self.shouImg.clipsToBounds = YES;
    [bgView addSubview:self.shouImg];
    
    self.titleLabel = [LabelTool createLableWithTextColor:k46Color font:BoldFont(15)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [bgView addSubview:self.titleLabel];
    
    self.breakLabel = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
    self.breakLabel.textAlignment = NSTextAlignmentLeft;
    self.breakLabel.numberOfLines = 0;
    self.breakLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [bgView addSubview:self.breakLabel];
    
    self.commentImg = [[UIImageView alloc] init];
    self.commentImg.image = [UIImage imageNamed:@"article_comment"];
    [bgView addSubview:self.commentImg];
    
    self.commentCountLabel = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
    [bgView addSubview:self.commentCountLabel];
    
    self.focusOnImg = [[UIImageView alloc] init];
    self.focusOnImg.image = [UIImage imageNamed:@"article_collect"];
    [bgView addSubview:self.focusOnImg];
    
    self.collectionCountLabel = [LabelTool createLableWithTextColor:k210Color font:Font(11)];
    [bgView addSubview:self.collectionCountLabel];
    
    yinYingImg = [[UIImageView alloc] init];
    yinYingImg.image = [UIImage imageNamed:@"article_shadow"];
    [self.contentView addSubview:yinYingImg];
}

- (void)setModel:(ArticleListModel *)model {
    _model = model;
    
    [self.shouImg sd_setImageWithURL:[NSURL URLWithString:model.img?model.img:@""] placeholderImage:[UIImage imageNamed:holdImage]];
    NSString *title = [NSString stringWithFormat:@"%@",model.name];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.headIndent = 0;
    
    paragraphStyle.firstLineHeadIndent = 0;
    
    paragraphStyle.lineSpacing = 3;
    
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    [self.titleLabel setAttributedText:setString];
    self.collectionCountLabel.text =[NSString stringWithFormat:@"%ld",(long)model.collectionCount];
    self.commentCountLabel.text =[NSString stringWithFormat:@"%ld",(long)model.commentCount];
    
    NSString *secTitle = [NSString stringWithFormat:@"%@",model.remark];
    NSMutableAttributedString  *setString1 = [[NSMutableAttributedString alloc] initWithString:secTitle];
    NSMutableParagraphStyle  *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle1.headIndent = 0;
    
    paragraphStyle1.firstLineHeadIndent = 0;
    
    paragraphStyle1.lineSpacing = 3;
    
    [setString1  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0,[secTitle length])];
    [self.breakLabel setAttributedText:setString1];
    
}


- (void)layoutSubviews {
    if ([self.FROME isEqualToString:@"YES"]) {
        bgView.hidden = NO;
        bgView.backgroundColor = [UIColor clearColor];
        bgImg.hidden = NO;
        yinYingImg.hidden = YES;
    }else {
        bgView.hidden = NO;
        bgImg.hidden = YES;
        yinYingImg.hidden = NO;
    }
    bgView.frame = CGRectMake(10.5, 9, kScreenWidth - 21, FIT_SCREEN_HEIGHT(120));
    bgImg.frame = CGRectMake(0, 0, kScreenWidth , FIT_SCREEN_HEIGHT(130) + 9);

    self.shouImg.frame = CGRectMake(11, (FIT_SCREEN_HEIGHT(120) - FIT_SCREEN_HEIGHT(104))/2.0, FIT_SCREEN_WIDTH(120), FIT_SCREEN_HEIGHT(104));
    
    UIFont * font = self.titleLabel.font;
    NSDictionary * dict = @{NSFontAttributeName : font};
    CGSize size7 = [self.titleLabel.text boundingRectWithSize:CGSizeMake(bgView.width - self.shouImg.right - 21 - 21, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    if (size7.height >20) {
        self.titleLabel.frame = CGRectMake(self.shouImg.right + 21, self.shouImg.top,  bgView.width - self.shouImg.right - 21 - 21, 40);
    }else {
        self.titleLabel.frame = CGRectMake(self.shouImg.right + 21, self.shouImg.top,  bgView.width - self.shouImg.right- 21 - 21, 15);
    }
    
//    UIFont * font1 = self.breakLabel.font;
//    NSDictionary * dict1 = @{NSFontAttributeName : font1};
//    CGSize size2 = [self.breakLabel.text boundingRectWithSize:CGSizeMake(bgView.width - self.shouImg.right- 21 - 14, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict1 context:nil].size;
    self.breakLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 5, self.titleLabel.width, 30);
    
    self.commentImg.frame = CGRectMake(self.titleLabel.left, self.shouImg.bottom - 13, 13.5, 13);
    CGSize size = [ self.commentCountLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.commentCountLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    self.commentCountLabel.frame =CGRectMake(self.commentImg.right + 5, self.commentImg.top, JGlabelContentWidth, 11);
    self.focusOnImg.frame = CGRectMake(self.commentCountLabel.left + JGlabelContentWidth + 28, self.commentImg.top, 13.5, 12);
    CGSize size1 = [ self.collectionCountLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.collectionCountLabel.font,NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth1 = size1.width;
    self.collectionCountLabel.frame = CGRectMake(self.focusOnImg.right + 5, self.focusOnImg.y, JGlabelContentWidth1, 11);
    yinYingImg.frame = CGRectMake(20, bgView.bottom, kScreenWidth - 40, 8);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
