//
//  SimulatedExerciseCell.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/11.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "SimulatedExerciseCell.h"
#import "AttachFileDetailViewController.h"

@implementation SimulatedExerciseCell

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
        UIImageView *conView = [[UIImageView alloc] init];
        conView.contentMode = UIViewContentModeScaleAspectFill;
        conView.userInteractionEnabled = YES;
        conView.tag = 10010;
//        CGFloat coorX = FIT_SCREEN_WIDTH(20);
        CGFloat coorX = 10;
        conView.frame = CGRectMake(coorX,0,kScreenWidth-coorX*2,FIT_SCREEN_HEIGHT(105));
        conView.backgroundColor = [UIColor whiteColor];
        conView.layer.cornerRadius = 15;
        conView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:conView];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(18), FIT_SCREEN_HEIGHT(11), FIT_SCREEN_WIDTH(75), FIT_SCREEN_HEIGHT(85))];
        [conView addSubview:self.icon];
        
        self.titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(20)];
        self.titleLabel.frame = CGRectMake(self.icon.right+coorX, FIT_SCREEN_HEIGHT(25), conView.width - self.icon.right - coorX, 25);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [conView addSubview:self.titleLabel];
        
        self.priceLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(20)];
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        self.priceLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+2, _titleLabel.width/2.0, _titleLabel.height);
        [conView addSubview:self.priceLabel];
        
        self.buyNumberLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
        self.buyNumberLabel.frame = CGRectMake(_priceLabel.right, _priceLabel.top, _priceLabel.width, _priceLabel.height);
        [conView addSubview:_buyNumberLabel];
        
        CGFloat iconWdt = 35;
        CGFloat iconHgt = 23;
        self.levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(conView.width-iconWdt, conView.height-iconHgt, iconWdt, iconHgt)];
        self.levelLabel.font = Font(15);
        self.levelLabel.textAlignment = NSTextAlignmentCenter;
        self.levelLabel.textColor = [UIColor whiteColor];
        self.levelLabel.backgroundColor = kOrangeColor;
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.levelLabel.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.levelLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        self.levelLabel.layer.mask = maskLayer;
        [conView addSubview:self.levelLabel];
        
        
        
        
        self.maskView = [[UIView alloc] initWithFrame:conView.frame];
        self.maskView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.8];
        self.maskView.hidden = YES;
        self.maskView.layer.cornerRadius = 15;
        self.maskView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.maskView];
        
        //敬请期待
        self.expectLabel = [LabelTool createLableWithTextColor:
                            [UIColor blackColor] font:Font(24)];
        self.expectLabel.frame = CGRectMake(self.priceLabel.left, self.titleLabel.bottom+2, self.titleLabel.width, 30);
        self.expectLabel.text = @"即将上线  敬请期待";
        [self.maskView addSubview:self.expectLabel];
        
        
        //课件下载view
        
        CGFloat attachViewWidth = 75;
        self.attachView = [[UIView alloc] initWithFrame:CGRectMake(conView.width - attachViewWidth - coorX, coorX, attachViewWidth, 25)];
        self.attachView.layer.borderColor = k210Color.CGColor;
        self.attachView.layer.borderWidth = 1;
        self.attachView.layer.cornerRadius = 5;
        self.attachView.layer.masksToBounds = YES;
        self.attachView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(displayAttachContent)];
        [self.attachView addGestureRecognizer:tap];
        [conView addSubview:self.attachView];
        
        UILabel *downloadLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_14)];
        downloadLabel.frame = CGRectMake(5, 2, self.attachView.width - 10, self.attachView.height - 4);
        downloadLabel.textAlignment = NSTextAlignmentCenter;
        downloadLabel.text = @"查看课件";
        [self.attachView addSubview:downloadLabel];
        
        self.attachView.hidden = YES;
        
//        //15*35
//        UIImageView *downloadIcon = [[UIImageView alloc] initWithImage:
//                                     [UIImage imageNamed:@"course_attach"]];
//
//        CGFloat wdtDownloadIcon = (self.attachView.height - 8) * 15 / 35;
//
//        downloadIcon.frame = CGRectMake(self.attachView.width - wdtDownloadIcon - coorX , 4, wdtDownloadIcon, self.attachView.height-8);
//        [self.attachView addSubview:downloadIcon];
    }
    
    return self;
}

- (void)setModel:(QuestionModel *)model {
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"class_icon.jpg"]];
    self.titleLabel.text = _model.name;

    
    if (model.isShowPrice) {
        if (model.price != 0) {
            self.priceLabel.textColor = kOrangeColor;
            self.priceLabel.font = Font(20);
            self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price/100];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
            
            [attr addAttribute:NSFontAttributeName value:Font(10) range:NSMakeRange(0, 1)];
            self.priceLabel.attributedText = attr;
            self.buyNumberLabel.text = [NSString stringWithFormat:@"%ld人已购买",(long)model.payCount];
        }
    }else {
        NSString *browseCount = [NSString stringWithFormat:@"%ld",(long)model.browseCount];
        self.priceLabel.text = [NSString stringWithFormat:@"%@ 人已浏览",browseCount];
        self.priceLabel.textColor = k75Color;
        self.priceLabel.font = Font(K_TEXT_FONT_12);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
        [attr addAttribute:NSForegroundColorAttributeName value:k46Color range:NSMakeRange(0, browseCount.length)];
        self.priceLabel.attributedText = attr;
        
        NSString *shareCount = [NSString stringWithFormat:@"%ld",(long)model.shareCount];
        self.buyNumberLabel.text = [NSString stringWithFormat:@"%@ 人已分享",shareCount];
        NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:self.buyNumberLabel.text];
        [attr2 addAttribute:NSForegroundColorAttributeName value:k46Color range:NSMakeRange(0, shareCount.length)];
        self.buyNumberLabel.attributedText = attr2;
    }
    
    
    
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price/100];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
//
//    [attr addAttribute:NSFontAttributeName value:Font(10) range:NSMakeRange(0, 1)];
//    self.priceLabel.attributedText = attr;
//    self.buyNumberLabel.text = [NSString stringWithFormat:@"%ld人已购买",(long)model.payCount];
    
    self.levelLabel.text = [NSString stringWithFormat:@"%@",model.count?model.count:@""];
    
    //即将上线
    self.maskView.hidden = model.isOnline;
    self.buyNumberLabel.hidden = !model.isOnline;
    self.priceLabel.hidden = !model.isOnline;
    self.levelLabel.hidden = !model.isOnline;
    self.attachView.hidden = !model.isOnline;
    
    if (model.isOnline) {
        self.attachView.hidden = YES;
        if ([_model.pdf isNotEmpty] && _model.expireTime > 0) {
            self.attachView.hidden = NO;
        }
    }
    
    UIImageView *conView = (UIImageView *)[self.contentView viewWithTag:10010];
    if (!([model.backImg containsString:@"null"] && model.backImg.length > 0)) {
        [conView sd_setImageWithURL:[NSURL URLWithString:model.backImg] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            conView.image = image;
            conView.layer.cornerRadius = 15;
            conView.layer.masksToBounds = YES;
        }];
    }else {
        conView.backgroundColor = [UIColor whiteColor];
    }
    
}

- (void)displayAttachContent {
    if ([_model.pdf isNotEmpty] && _model.expireTime > 0) {
        AttachFileDetailViewController *attachDetail = [[AttachFileDetailViewController alloc] init];
        [attachDetail setAttachFileUrlString:_model.pdf];
        attachDetail.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:attachDetail animated:YES];
    }
}
@end
