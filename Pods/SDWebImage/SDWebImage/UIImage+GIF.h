/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Laurin Brandner
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"

// This category is just use as a convenience method. For more detail control, use methods in `UIImage+MultiFormat.h` or directlly use `SDImageCoder`
@interface UIImage (GIF)

/**
 Creates an animated UIImage from an NSData.
 This will create animated image if the data is Animated GIF. And will create a static image is the data is Static GIF.

 @param data The GIF data
 @return The created image
 */
+ (nullable UIImage *)sd_imageWithGIFData:(nullable NSData *)data;

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;

/**
 *  Checks if an UIImage instance is a GIF. Will use the `images` array.
 */
- (BOOL)isGIF;

@end
