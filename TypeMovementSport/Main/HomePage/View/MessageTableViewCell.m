







#import "MessageTableViewCell.h"
//#import "UILabel+AutoResizeLabel.h"

@interface MessageTableViewCell ()


@property (nonatomic, strong) UILabel *line;

@end

@implementation MessageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createViews];
        
    }
    return self;
    
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    _timeLabel.text = timeStr;
}

- (void)setMyString:(NSString *)myString {
    
    _myString = myString;
    _infoLabel.text = myString;
}

- (void)createViews {
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = UIColorFromRGB(0x666666);
    _titleLabel.font = Font(K_TEXT_FONT_12);
    [self.contentView addSubview:_titleLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = UIColorFromRGB(0xb2b2b2);
    _timeLabel.font = Font(K_TEXT_FONT_10);
    [self.contentView addSubview:_timeLabel];
    
    self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookBtn.backgroundColor = UIColorFromRGB(0xff4d24);
    [_lookBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    _lookBtn.titleLabel.font = Font(11);
    [_lookBtn setTitleColor:k46Color forState:UIControlStateNormal];
    _lookBtn.layer.cornerRadius = 5.0;
    _lookBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_lookBtn];

    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
    _deleteBtn.layer.cornerRadius = 10.0;
    _deleteBtn.layer.masksToBounds = YES;
    _deleteBtn.backgroundColor = kOrangeColor;
    [self.contentView addSubview:_deleteBtn];
    
    self.label = [[UILabel alloc] init];
    _label.backgroundColor = UIColorFromRGB(0xff4d24);
    _label.layer.cornerRadius = 3.0;
    _label.layer.masksToBounds = YES;
    [self.contentView addSubview:_label];
    
    self.infoLabel = [[UILabel alloc] init];
    _infoLabel.font = Font(K_TEXT_FONT_12);
    _infoLabel.textColor = UIColorFromRGB(0x666666);
    _infoLabel.numberOfLines = 0;
    _infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_infoLabel];
    
    self.line = [[UILabel alloc] init];
    _line.backgroundColor =LaneCOLOR;
    [self.contentView addSubview:_line];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    _label.frame = CGRectMake(20, self.frame.size.height / 2 - 3, 6, 6);
    _titleLabel.frame = CGRectMake(33, 20, (self.frame.size.width - 16) / 2, 12);
    _timeLabel.frame = CGRectMake(33, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, 100, 10);
    _deleteBtn.frame = CGRectMake(self.frame.size.width - 40, 26, 20, 20);
    _lookBtn.frame = CGRectMake(self.frame.size.width - 110, 26, 64, 20);
    _line.frame = CGRectMake(16, self.frame.size.height - 1, self.frame.size.width - 32, 0.5);
    

    if ([_isOpen isEqualToString:@"yes"]) {
        
        CGSize size = [UITool sizeOfStr:_myString andFont:Font(K_TEXT_FONT_12) andMaxSize:CGSizeMake(self.frame.size.width - 72, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping];
        _infoLabel.frame = CGRectMake(36, _timeLabel.frame.origin.y + 26, self.frame.size.width - 72, size.height+5);
        
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        [_infoLabel autoResizeUILabelHeightWithText:self.myString andOriginFrame:CGRectMake(36, _timeLabel.frame.origin.y + 26, self.frame.size.width - 72, 40) andFont:[UIFont systemFontOfSize:12] andMaxHeight:MAXFLOAT];
        [_lookBtn setTitle:@"收起" forState:UIControlStateNormal];
        _lookBtn.backgroundColor = UIColorFromRGB(0x24a0ff);
    } else {
        CGSize size = [UITool sizeOfStr:_myString andFont:Font(K_TEXT_FONT_12) andMaxSize:CGSizeMake(self.frame.size.width - 72, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping];
        _infoLabel.frame = CGRectMake(36, _timeLabel.frame.origin.y + 26, self.frame.size.width - 72, size.height+5);
//        [_infoLabel autoResizeUILabelHeightWithText:nil andOriginFrame:CGRectMake(36, _timeLabel.frame.origin.y + 26, self.frame.size.width - 72, 0) andFont:[UIFont systemFontOfSize:12] andMaxHeight:MAXFLOAT];
        [_lookBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        _lookBtn.backgroundColor = UIColorFromRGB(0xff4d24);
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
