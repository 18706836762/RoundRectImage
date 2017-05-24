//
//  UIImage+extension.m
//  Redious
//
//  Created by admin on 16/12/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIImage+extension.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImage+Additional.h"

@implementation UIImage (extension)
- (void)was_roundImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor  opaque:(BOOL)opaque completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        //圆+边框
        UIImage * result = [UIImage circleImage:self  fillColor:fillColor withbodarWidth:boardWidth boadarColor:boardColor];


        // 7. 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
}

//圆角矩形
- (void)was_roundRectImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor opaque:(BOOL)opaque radius:(CGFloat)radius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor  completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *result = [UIImage circleImage:self fillColor:fillColor cornerRadius:radius withbodarWidth:boardWidth boadarColor:boardColor];

        // 7. 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        //        NSTimeInterval start = CACurrentMediaTime();
//        
//        // 1. 利用绘图，建立上下文 BOOL选项为是否为不透明
//        UIGraphicsBeginImageContextWithOptions(size, opaque, 0);
//        
//        CGRect rect = CGRectMake(0, 0, size.width, size.height);
//        
//        // 2. 设置填充颜色
//        if (opaque) {
//            [fillColor setFill];
//            UIRectFill(rect);
//        }
//        
//        // 3. 利用 贝赛尔路径 `裁切 效果
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
////        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
//        
//        [path addClip];
//        
//        // 4. 绘制图像
//        if (self) {
//            [self drawInRect:rect];
//        }
//        
//        // 5. 取得结果
//        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
//        
//        // 6. 关闭上下文
//        UIGraphicsEndImageContext();
//        
//        //        NSLog(@"%f", CACurrentMediaTime() - start);
//        
//        // 7. 完成回调
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion != nil) {
//                completion(result);
//            }
//        });
//    });
}


@end

#pragma mark - UIImageView
@implementation UIImageView (Extension)
//圆
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color{
    [self was_setCircleImageWithUrlString:urlString placeholder:image fillColor:color BoardWidth:0 BoardColor:nil opaque:color];
}


//圆形矩阵
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat) cornerRadius{
    [self was_setRoundRectImageWithUrlString:urlString placeholder:image fillColor:color opaque:color cornerRadius:cornerRadius BoardWidth:0 BoardColor:nil];
}


//网络延迟下载--圆形 + 边框
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor
{
    [self was_setCircleImageWithUrlString:urlString placeholder:image fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:color];
}
//网络延迟下载--圆形矩阵 + 边框
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor
{
     [self was_setRoundRectImageWithUrlString:urlString placeholder:image fillColor:color opaque:color cornerRadius:cornerRadius BoardWidth:boardWidth BoardColor:boardColor];
}


- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor opaque:(BOOL)opaque{
    [self.superview layoutIfNeeded];
    NSURL *url = [NSURL URLWithString:urlString];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (image) {
        //占位图片不为空的情况
        //1.现将占位图圆角化，这样就避免了如图片下载失败，使用占位图的时候占位图不是圆角的问题
        [image was_roundImageWithSize:size fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:opaque completion:^(UIImage *radiusPlaceHolder) {
            
            //2.使用sd的方法缓存异步下载的图片
            [weakSelf sd_setImageWithURL:url placeholderImage:radiusPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //3.如果下载成功那么讲下载成功的图进行圆角化
                [img was_roundImageWithSize:size fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:opaque completion:^(UIImage *radiusImage) {
                    weakSelf.image = radiusImage;
                }];
                
            }];
            
        }];
    } else {
        //占位图片为空的情况
        //2.使用sd的方法缓存异步下载的图片
        [weakSelf sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img was_roundImageWithSize:size fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:opaque completion:^(UIImage *radiusImage) {
                weakSelf.image = radiusImage;
            }];
        }];
    }
}

- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color opaque:(BOOL)opaque cornerRadius:(CGFloat) cornerRadius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor{
    [self.superview layoutIfNeeded];
    NSURL *url = [NSURL URLWithString:urlString];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (image) {
        //占位图片不为空的情况
        //1.现将占位图圆角化，这样就避免了如图片下载失败，使用占位图的时候占位图不是圆角的问题
        [image was_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius BoardWidth:boardWidth BoardColor:boardColor completion:^(UIImage *roundRectPlaceHolder) {
            
            //2.使用sd的方法缓存异步下载的图片
            [weakSelf sd_setImageWithURL:url placeholderImage:roundRectPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //3.如果下载成功那么讲下载成功的图进行圆角化
                [img was_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius BoardWidth:boardWidth BoardColor:boardColor completion:^(UIImage *radiusImage) {
                    weakSelf.image = radiusImage;
                }];
                
            }];
            
        }];
    } else {
        //占位图片为空的情况
        //.使用sd的方法缓存异步下载的图片
        [weakSelf sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img was_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius BoardWidth:0 BoardColor:nil completion:^(UIImage *radiusImage) {
                weakSelf.image = radiusImage;
            }];
        }];
    }
}

@end

#pragma mark - UIButton

@implementation UIButton (Extension)
//圆形
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color forState:(UIControlState)state {
    [self was_setCircleImageWithUrlString:urlString placeholder:image fillColor:color BoardWidth:0 BoardColor:nil opaque:color forState:state];
}


//圆角矩阵
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat) cornerRadius forState:(UIControlState)state{

    [self was_setRoundRectImageWithUrlString:urlString placeholder:image fillColor:color opaque:color cornerRadius:cornerRadius BoardWidth:0 BoardColor:nil forState:state];
}

//button--圆形 + 边框
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor forState:(UIControlState)state;
{
    [self was_setCircleImageWithUrlString:urlString placeholder:image fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:color forState:state];
}
//button--圆角矩形 + 边框
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor forState:(UIControlState)state;
{
    [self was_setRoundRectImageWithUrlString:urlString placeholder:image fillColor:color opaque:color cornerRadius:cornerRadius BoardWidth:boardWidth BoardColor:boardColor forState:state];
}


- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color opaque:(BOOL)opaque cornerRadius:(CGFloat) cornerRadius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor forState:(UIControlState)state{
    NSURL *url = [NSURL URLWithString:urlString];
    [self.superview layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (image) {
        //占位图片不为空的情况
        //占位处理
        [image was_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius BoardWidth:boardWidth BoardColor:boardColor completion:^(UIImage *roundRectPlaceHolder) {
            //sd
            [weakSelf sd_setImageWithURL:url forState:state placeholderImage:roundRectPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //3.如果下载成功那么讲下载成功的图进行圆角化
                [img was_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius BoardWidth:boardWidth BoardColor:boardColor completion:^(UIImage *roundRectImage) {
                    [weakSelf setImage:roundRectImage forState:state];
                }];
                
            }];
            
        }];
    } else {
        //占位图片为空的情况
        [weakSelf sd_setImageWithURL:url forState:state placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img was_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius BoardWidth:boardWidth BoardColor:boardColor completion:^(UIImage *roundRectImage) {
                [weakSelf setImage:roundRectImage forState:state];
            }];
            
        }];
    }
}


- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor opaque:(BOOL)opaque forState:(UIControlState)state{
    NSURL *url = [NSURL URLWithString:urlString];
    [self.superview layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (image) {
        //占位图片不为空的情况
        //占位处理
        [image was_roundImageWithSize:size fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:opaque completion:^(UIImage *radiusPlaceHolder) {
            //sd
            [weakSelf sd_setImageWithURL:url forState:state placeholderImage:radiusPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //3.如果下载成功那么讲下载成功的图进行圆角化
                [img was_roundImageWithSize:size fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:opaque completion:^(UIImage *radiusImage) {
                    [weakSelf setImage:radiusImage forState:state];
                }];
                
            }];
            
        }];
    } else {
        //占位图片为空的情况
        [weakSelf sd_setImageWithURL:url forState:state placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img was_roundImageWithSize:size fillColor:color BoardWidth:boardWidth BoardColor:boardColor opaque:opaque completion:^(UIImage *radiusImage) {
                [weakSelf setImage:radiusImage forState:state];
            }];
            
        }];
    }
    
}




@end
