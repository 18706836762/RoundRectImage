//
//  UIImage+Additional.h
//
//  Created by User on 16/3/22.
//  Copyright © 2016年 jzhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additional)
/**
 *  @brief 通过色值生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/*
 *  extend stretchableImageWithLeftCapWidth:topCapHeight on ios5++
 *
 *  on ios4 make sure your capInsets's left as stretchableImageWithLeftCapWidth:topCapHeight 's width and capInsets'top as stretchableImageWithLeftCapWidth:topCapHeight 's height
 *  on ios5&ios5++ like call resizableImageWithCapInsets:
 */
- (UIImage *)resizableImageExtendWithCapInsets:(UIEdgeInsets)capInsets;


/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

/*
 * Scales the image to the given size
 */
- (UIImage*)scaleToSize:(CGSize)size;

/*
 *高斯模糊效果，渲染很费电，占内存，慎用。
 */
- (UIImage *)blurred;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

/**
 *  将某个视图渲染成一张图片
 */
+ (UIImage *)createImageFromView:(UIView *)view;

/**
 * 缩放图片
 */
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  降低图片质量
 *
 *  @param quality 值在0.1~1.0之间
 *
 *  @return <#return value description#>
 */
- (UIImage *)imageWithQuality:(CGFloat)quality;

/**
 *  截取图片中区域的内容
 *
 */
- (UIImage *)imageWithWithRect:(CGRect)rect;
/**
 *  截取图片中某个区域的内容，并生成一个固定尺寸大小的图片
 *
 *  @param rect      原图片的区域
 *  @param imageSize 图片大小
 *
 *  @return <#return value description#>
 */
- (UIImage *)imageWithWithRect:(CGRect)rect size:(CGSize)imageSize;

/**
 *  根据宽高比例生成一张新图，若是当前图的比例与新生成的图比例不一样，则截取中间部分
 *
 *  @param ratio 生成的新图的宽高比例
 *
 *  @return <#return value description#>
 */
- (UIImage *)createImageWithRatio:(CGFloat)ratio;


/**
 *  缩放一张图片到对应大小，若是图片大小比例不一样，则取中间部分
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)scaleImageToSize:(CGSize)size;

/*
 * 图片 圆形裁剪 bodarWidth==0不添加边框 else添加边框
 */
+(UIImage*) circleImage:(UIImage*) image fillColor:(UIColor *)fillColor withbodarWidth:(CGFloat)bodarWidth boadarColor:(UIColor *)bodarColor;

/*
 * 图片  圆角裁剪 bodarWidth==0不添加边框 else添加边框
 */
+(UIImage*) circleImage:(UIImage*) image fillColor:(UIColor *)fillColor cornerRadius:(float)radius withbodarWidth:(CGFloat)bodarWidth boadarColor:(UIColor *)bodarColor;


@end
