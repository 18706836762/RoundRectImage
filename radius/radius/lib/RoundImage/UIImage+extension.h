//
//  UIImage+extension.h
//  Redious
//
//  Created by admin on 16/12/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extension)
//圆形
- (void)was_roundImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor  opaque:(BOOL)opaque completion:(void (^)(UIImage *))completion;
//圆角矩阵
- (void)was_roundRectImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor opaque:(BOOL)opaque radius:(CGFloat)radius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor  completion:(void (^)(UIImage *))completion;

@end



@interface UIImageView (Extension)
//网络延迟下载--圆形
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color;
//网络延迟下载--圆形矩阵
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat) cornerRadius;

//网络延迟下载--圆形 + 边框
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor;
//网络延迟下载--圆形矩阵 + 边框
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor;

@end




@interface UIButton (Extension)
//button--圆形
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color forState:(UIControlState)state;
//button--圆角矩形
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius forState:(UIControlState)state;

//button--圆形 + 边框
- (void)was_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor forState:(UIControlState)state;
//button--圆角矩形 + 边框
- (void)was_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)image fillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius BoardWidth:(CGFloat)boardWidth BoardColor:(UIColor *)boardColor forState:(UIControlState)state;
@end
