







#import "TestCardCollectionViewCell.h"

@implementation TestCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
    
}

- (void)createViews {
    
    self.testNumLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(K_TEXT_FONT_12)];
    self.testNumLabel.textAlignment = NSTextAlignmentCenter;
    self.testNumLabel.frame = CGRectMake(0, 0, (kScreenWidth - 169) / 6, (kScreenWidth - 169) / 6);
    self.testNumLabel.layer.cornerRadius = self.testNumLabel.width/2.0;
    self.testNumLabel.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.testNumLabel.layer.borderWidth = 1.0;
    self.testNumLabel.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_testNumLabel];
    
}

@end
