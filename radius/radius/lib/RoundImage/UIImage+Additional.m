
//
//  UIImage+Additional.m
//
//  Created by User on 16/3/22.
//  Copyright © 2016年 jzhd. All rights reserved.
//

#import "UIImage+Additional.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Additional)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return img;
    }
}

-(UIImage *)resizableImageExtendWithCapInsets:(UIEdgeInsets)capInsets{
    UIImage *newImage = nil;
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        newImage = [self resizableImageWithCapInsets:capInsets];
    } else {
        newImage = [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    
    return newImage;
}

+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(error || !data) {
        return nil;
    } else {
        return [UIImage imageWithData:data];
    }
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)blurred
{
    return [self applyBlurWithRadius:15 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] saturationDeltaFactor:1.8 maskImage:nil];
   
}

+ (UIImage *)createImageFromView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return uiImage;
}

- (UIImage *)imageWithQuality:(CGFloat)quality{
    NSData *data = UIImageJPEGRepresentation(self, quality);
    return [UIImage imageWithData:data];
}

- (UIImage *)imageWithWithRect:(CGRect)rect{
    return [self imageWithWithRect:rect size:rect.size];
}

- (UIImage *)imageWithWithRect:(CGRect)rect size:(CGSize)imageSize{
    // Create a graphics image context
//    UIGraphicsBeginImageContext(imageSize);
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0f);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:rect];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

/**
 *  根据宽高比例生成一张新图，若是当前图的比例与新生成的图比例不一样，则截取中间部分
 *
 *  @param ratio 生成的新图的宽高比例
 *
 *  @return <#return value description#>
 */
- (UIImage *)createImageWithRatio:(CGFloat)ratio{
    if(ratio <= 0){
        return nil;
    }
    CGFloat oldRatio = self.size.width / self.size.height;
    /**
     *  w/h < w1/h1 裁剪h
     *  w/h > w1/h1 裁剪w
     *  oldRatio = w/h
     *  ration = w1/h1
     */
    CGRect newRect = CGRectZero;
    if(oldRatio < ratio){
        CGFloat newHeight = self.size.width / ratio;
        newRect = CGRectMake(0, (self.size.height-newHeight)/2.0, self.size.width, newHeight);
        return [self imageWithWithRect:newRect];
    }
    else if(oldRatio > ratio){
        CGFloat newWidth = self.size.height * ratio;
        newRect = CGRectMake((self.size.width - newWidth)/2.0, 0, newWidth, self.size.height);
        return [self imageWithWithRect:newRect];
    }
    else{
        return self;
    }
}

- (UIImage *)scaleImageToSize:(CGSize)size{
    CGFloat oldRatio = self.size.width / self.size.height;
    CGFloat ratio = size.width / size.height;
    /**
     *  w/h < w1/h1 裁剪h
     *  w/h > w1/h1 裁剪w
     *  oldRatio = w/h
     *  ration = w1/h1
     */
    CGRect newRect = CGRectZero;
    if(oldRatio < ratio){
        CGFloat newHeight = self.size.width / ratio;
        newRect = CGRectMake(0, (self.size.height-newHeight)/2.0, self.size.width, newHeight);
    }
    else if(oldRatio > ratio){
        CGFloat newWidth = self.size.height * ratio;
        newRect = CGRectMake((self.size.width - newWidth)/2.0, 0, newWidth, self.size.height);
    }
    else{
        newRect = CGRectMake(0, 0, self.size.width, self.size.height);
    }
    return [self imageWithWithRect:newRect size:size];
}



/*
 * ⭕️ 对图片进行圆形裁剪 添加边框
 */
+(UIImage*) circleImage:(UIImage*) image fillColor:(UIColor *)fillColor withbodarWidth:(CGFloat)bodarWidth boadarColor:(UIColor *)bodarColor;
{
    UIGraphicsBeginImageContext(image.size);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    // 2. 设置填充背景颜色
    if (fillColor) {
        [fillColor setFill];
        UIRectFill(rect);
    }

    if(bodarWidth==0){
        //圆形 不加边框
        UIBezierPath *path =[UIBezierPath bezierPathWithOvalInRect:rect];
        [path addClip];
        [image drawAtPoint:CGPointZero];
    }else{
        //圆形加边框
        CGContextRef context =UIGraphicsGetCurrentContext();
        //圆的边框宽度为2，颜色为红色
        CGContextSetLineWidth(context,bodarWidth);
        CGContextSetStrokeColorWithColor(context, bodarColor.CGColor);
        rect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextAddEllipseInRect(context, rect);
        CGContextClip(context);
        //在圆区域内画出image原图
        [image drawInRect:rect];
        CGContextAddEllipseInRect(context, rect);
        CGContextStrokePath(context);
    }
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}



/*
 * 图片  圆角裁剪 bodarWidth==0不添加边框 else添加边框
 */
+(UIImage*) circleImage:(UIImage*) image fillColor:(UIColor *)fillColor cornerRadius:(float)radius withbodarWidth:(CGFloat)bodarWidth boadarColor:(UIColor *)bodarColor
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    // 2. 设置填充背景颜色
    if (fillColor) {
        [fillColor setFill];
        UIRectFill(rect);
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                    cornerRadius:radius];
    CGContextAddPath(c, path.CGPath);
    
    CGContextClip(c);
    [image drawInRect:rect];
    CGContextDrawPath(c, kCGPathFillStroke);
    
    if(bodarWidth>0){
        //+ 边框
        CGContextSetLineWidth(c,bodarWidth);
        CGContextSetStrokeColorWithColor(c,bodarColor.CGColor);
        
        CGContextAddPath(c, path.CGPath);
        CGContextStrokePath(c);
    }
    
    UIImage *NewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return NewImage;
}
@end
