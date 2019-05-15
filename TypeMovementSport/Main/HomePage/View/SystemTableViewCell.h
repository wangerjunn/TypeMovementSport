







#import <UIKit/UIKit.h>

@interface SystemTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString * myString;
@property (nonatomic, strong) NSString *isOpen;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *timeStr;


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *label;


@end
