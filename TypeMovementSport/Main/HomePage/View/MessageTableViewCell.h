







#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell


@property (strong, nonatomic) NSString * myString;

@property (nonatomic, strong) NSString *isOpen;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *allOpen;

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UIButton *lookBtn;//查看详情
@property (nonatomic, strong) UIButton *deleteBtn;//删除按钮
@property (nonatomic, strong) UILabel *infoLabel;//消息内容
@property (nonatomic, strong) UILabel *label;//未读消息标识

@end





