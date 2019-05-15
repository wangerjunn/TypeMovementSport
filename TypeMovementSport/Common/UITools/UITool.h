

#import <UIKit/UIKit.h>
#pragma mark - <1.Image>

@interface ImageTool : NSObject

+ (UIImage *)clipRoundHeadImage:(UIImage *)image;
/*控制图片在多少M以内*/
+ (NSData *)compressImage:(UIImage *)image toTargetM:(CGFloat)targetM;
/**创建单色image图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

//返回特定尺寸的UImage  ,  image参数为原图片，size为要设定的图片大小
/**压缩图片，会失真的压缩，简单的裁剪*/
+ (UIImage*)resizeImageToSize:(CGSize)size image:(UIImage*)image;

/**返回指定view生成的图片*/
+ (UIImage *)imageFromView:(UIView *)view;

/**返回指定视图中指定范围生成的image图片*/
+ (UIImage *)imageFromView:(UIView *)view inRect:(CGRect)rect;

/**把图片写入到手机相册*/
+ (void)writeImageToSavedPhotosAlbum:(UIImage *)image;

//生成二维码图片
+ (UIImage *)qrImage:(NSString *)qrCode;
+ (UIImage *)qrImage:(NSString *)qrCode WithSize: (CGSize)size onColor: (UIColor *)onColor offColor: (UIColor *)offColor;
@end

#pragma mark - <2.Color>
@interface ColorTool : NSObject

/**RGB值生成颜色 取值范围0-255*/
+ (UIColor *)createColorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;

/**RGB值生成颜色 取值范围0-255 alpha透明度*/
+ (UIColor *)createColorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue alpha:(CGFloat)alpha;

/**
 颜色混合

 @param start start description
 @param end end description
 @param f f description
 @return return value description
 */
+ (UIColor *)interpolateRGBColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)f ;
@end


#pragma mark - <3.DeviceAttribute>
/**得到设备相关属性的方法*/
@interface DeviceAttributeTool : NSObject

/**
 *  获取屏幕宽度
 *
 *  @return 屏幕宽度
 */
+(CGFloat)currentScreenWidth;


/**
 *  获取屏幕高度
 *
 *  @return 屏幕高度
 */
+(CGFloat)currentScreenHeight;


/**
 *  获取屏幕大小
 *
 *  @return 屏幕大小
 */
+(CGSize)currentScreenSize;


/**
 *  获取操作系统版本号
 *
 *  @return 操作系统版本号
 */
+(NSString *)currentVersion;


/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
+(NSString *)currentModel;


@end

#pragma mark - <4.TableView>
@interface TableViewTool : NSObject
+ (UITableView *)createTableViewWithFrame:(CGRect)frame viewController:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)vc;

+ (UITableView *)createTableViewWithFrame:(CGRect)frame superView:(UIView *)view delegateViewController:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)delegate;

+ (UITableView *)createTableViewWithFrame:(CGRect)frame superView:(UIView *)view delegate:(id<UITableViewDataSource, UITableViewDelegate>)delegate;
@end

#pragma mark - <5.GestureRecognizerTool>
@interface GestureRecognizerTool : NSObject

//添加单击手势  3.1以后废除
+ (void)addGestureInView:(UIView *)view target:(id)target action:(SEL)action;

//添加单击手势
+ (UITapGestureRecognizer *)addSingleGestureInView:(UIView *)view target:(id)target action:(SEL)action;


@end

#pragma mark - <6.ButtonTool>
@interface ButtonTool : NSObject
+ (UIButton *)createButtonWithImageName:(NSString *)imageName
                              addTarget:(id)target
                                 action:(SEL)action;

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action;

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                              isSizeToFit:(BOOL)isSizeToFit;

/**根据传入的图片大小生成一个Button*/
+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor;

/**根据传入的图片大小生成一个Button, 并添加到父视图上*/
+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                                superView:(UIView *)superView;

+ (UIButton *)createButtonWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                          titleFont:(UIFont *)font
                          addTarget:(id)target
                             action:(SEL)action;

+ (void)addTarget:(id)target
           action:(SEL)action
         onButton:(UIButton *)btn;

+ (UIButton *)createButtonWithBGNormalImageName:(NSString *)bgImageName
                                 hightImageName:(NSString *)hightImageName
                                      addTarget:(id)target
                                         action:(SEL)action
                                    isSizeToFit:(BOOL)isSizeToFit;

+ (void)setTitle:(NSString *)title
           color:(UIColor *)color
            font:(NSInteger)fontSize
        onButton:(UIButton *)btn;

//创建阴影按钮
+ (UIButton *)createShadowButtonWithTitle:(NSString *)title
                                addTarget:(id)target
                                   action:(SEL)action
                                    frame:(CGRect)frame
                                  bgColor:(UIColor *)bgColor
                              shadowColor:(UIColor *)shadowColor
                                superView:(UIView *)superView;
/*
 改变按钮
 */
//设置按钮圆角
+ (void)setBtnCorner:(UIButton *)btn;

@end

#pragma mark - <7.LabelTool>
@interface LabelTool : NSObject

/**
 *  创建lable，设置标题颜色（颜色为nil时，为黑色） 文本字体大小
 *
 *  @param frame     frame description
 *  @param textColor textColor description
 *  @param size      size description
 *
 *  @return lable
 */
+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;

/**
 *  创建lable，设置标题颜色（颜色为nil时，为黑色） 文本字体
 *
 *  @param frame     frame description
 *  @param textColor textColor description
 *  @param font      size description
 *
 *  @return lable
 */
+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;


+ (UILabel *)createLableWithTextColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;
+ (UILabel *)createLableWithTextColor:(UIColor *)textColor font:(UIFont *)font;

@end

#pragma mark - <8.LayoutConstraintTool>

@interface LayoutConstraintTool : NSObject

+ (NSArray *)constraintsWithVisualFormat:(NSString *)format views:(NSDictionary *)views;


@end

#pragma mark - <9.ScrollViewTool>

@interface ScrollViewTool : NSObject

+ (UIScrollView *)createScrollView;


@end


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define QLLogFunction NSLog(@"%s", __FUNCTION__);



@interface UITool : NSObject

//是否包含emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSString *) stringFromNumber:(NSNumber *)number;

/*****
 * 区分ios7计算字符串高度
 *
 * str   字符串
 * font  字体
 * size  区域
 * mode  折行方式
 */
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode;
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode lineSpace:(CGFloat)lineSpace;
/**
 *  设置label行间距
 *
 *  @param label       label
 *  @param lineSpacing 行间距
 *  @param color       字体颜色
 */
+(void)label:(UILabel *)label andLineSpacing:(CGFloat )lineSpacing andColor:(UIColor *)color;

/*****
 * 存入用户信息
 *
 * dict 用户信息
 */
+(BOOL)insertUserInfoToPlist:(nonnull NSDictionary *)dict;

/*****
 * 读取userinfo
 */
+(nonnull NSDictionary *)getUserInfo;

/*****
 * 更新userinfo
 */
+(BOOL)updateUserInfoWithItem:(nonnull NSString *)key value:(nonnull NSString *)value;

/*****
 * 清空userinfo
 */
+(void)clearUserInfo;

/**
 *  解决图片自动旋转
 *
 *  @param aImag 原图
 *
 *  @return image
 */
+ (UIImage *_Nullable)fixOrientation:(UIImage *_Nullable)aImag;

+ (UIImage *_Nullable) imageCompressForWidth:(UIImage *_Nullable)sourceImage targetWidth:(CGFloat)defineWidth;



/**
 *  找到导航栏底下的线条
 *
 *  @param view
 *
 *  @return 导航栏底部的线条
 */
+(UIImageView *_Nullable)findHairlineImageViewUnder:(UIView *_Nullable)view;
@end
