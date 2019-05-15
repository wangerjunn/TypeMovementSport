







#import "SystemTableViewCell.h"
//#import "UILabel+AutoResizeLabel.h"

@interface SystemTableViewCell ()


@property (nonatomic, strong) UILabel *line;

@end


@implementation SystemTableViewCell

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

    self.infoLabel = [[UILabel alloc] init];
    _infoLabel.font = Font(K_TEXT_FONT_12);
    _infoLabel.textColor = UIColorFromRGB(0x666666);
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_infoLabel];
    
    self.line = [[UILabel alloc] init];
    _line.backgroundColor = LaneCOLOR;
    [self.contentView addSubview:_line];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    _titleLabel.frame = CGRectMake(33, 20, (self.frame.size.width - 16) / 2, 12);
    _timeLabel.frame = CGRectMake(33, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, 100, 10);
    _line.frame = CGRectMake(16, self.frame.size.height - 1, self.frame.size.width - 32, 0.5);
    
    CGSize size = [UITool sizeOfStr:_myString andFont:Font(K_TEXT_FONT_12) andMaxSize:CGSizeMake(self.frame.size.width - 72, MAXFLOAT) andLineBreakMode:NSLineBreakByCharWrapping];
    _infoLabel.frame = CGRectMake(36, _timeLabel.frame.origin.y + 26, self.frame.size.width - 72, size.height+5);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
