//
//  ViewController.m
//  radius
//
//  Created by admin on 16/12/20.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+extension.h"
#import "UIImage+Additional.h"
@interface ViewController ()
@end

@implementation ViewController{
    UIImageView *_imgView1;
    UIImageView *_imgView2;
    UIButton *_btn1;
    UIButton *_btn2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(60, 20, 128, 128);
    [self.view addSubview:imageView1];
    _imgView1 = imageView1;
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(60, 150, 128, 128);
    [self.view addSubview:imageView2];
    _imgView2 = imageView2;
    
    UIButton *roundButton = [[UIButton alloc] init];
    roundButton.frame = CGRectMake(200, 20, 128, 128);
    [self.view addSubview:roundButton];
    _btn1 = roundButton;
    
    UIButton *roundRectButton = [[UIButton alloc] init];
    roundRectButton.frame = CGRectMake(200, 150, 128, 128);
    [self.view addSubview:roundRectButton];
    _btn2 = roundRectButton;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"左侧为UIImageView，右侧为UIButton(有背景色)";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    titleLabel.center = CGPointMake(190, 300);
    
    //    NSURL *url = [NSURL URLWithString:@"http://cc.cocimg.com/api/uploads/20150803/1438567345483993.jpg"];
    NSString *urlString = @"http://cc.cocimg.com/api/uploads/20150803/1438567345483993.jpg";
    
///////////////////////////////／／／//网络图片///////////////////////////////////
    //圆形
    //[_imgView1 was_setCircleImageWithUrlString:urlString placeholder:[UIImage imageNamed:@"head"] fillColor:nil];
    //加边框
    [_imgView1 was_setCircleImageWithUrlString:urlString placeholder:[UIImage imageNamed:@"head"] fillColor:[UIColor whiteColor] BoardWidth:8.0 BoardColor:[UIColor redColor]];
    
    //圆角矩阵
    //[_imgView2 was_setRoundRectImageWithUrlString:urlString placeholder:[UIImage imageNamed:@"head"] fillColor:[UIColor whiteColor] cornerRadius:20];
    //加边框
    [_imgView2 was_setRoundRectImageWithUrlString:urlString placeholder:[UIImage imageNamed:@"head"] fillColor:[UIColor whiteColor] cornerRadius:20 BoardWidth:3.0 BoardColor:[UIColor purpleColor]];
    
    
    
    //圆形按钮
    [_btn1 was_setCircleImageWithUrlString:urlString placeholder:[UIImage imageNamed:@"head"] fillColor:[UIColor whiteColor] BoardWidth:4.0 BoardColor:[UIColor cyanColor] forState:UIControlStateNormal];

    //圆角矩阵按钮
    [_btn2 was_setRoundRectImageWithUrlString:urlString placeholder:[UIImage imageNamed:@"head"] fillColor:[UIColor whiteColor] cornerRadius:20  forState:UIControlStateNormal];
    
    
    //无背景色 透明
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.frame = CGRectMake(60, 320, 128, 128);
    [self.view addSubview:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc] init];
    imageView4.frame = CGRectMake(60, 450, 128, 128);
    [self.view addSubview:imageView4];
    
    UIButton *roundButton1 = [[UIButton alloc] init];
    roundButton1.frame = CGRectMake(200, 320, 128, 128);
    [self.view addSubview:roundButton1];
    
    UIButton *roundRectButton1 = [[UIButton alloc] init];
    roundRectButton1.frame = CGRectMake(200, 450, 128, 128);
    [self.view addSubview:roundRectButton1];
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.text = @"左侧为UIImageView，右侧为UIButton(无背景色)";
    titleLabel1.font = [UIFont systemFontOfSize:16];
    titleLabel1.textColor = [UIColor whiteColor];
    [titleLabel1 sizeToFit];
    [self.view addSubview:titleLabel1];
    titleLabel1.center = CGPointMake(190, 600);
    
    
    /////////////////////////////////本地图片///////////////////////////////////
    //圆形 +边框
    imageView3.image = [UIImage circleImage:[UIImage imageNamed:@"head"] fillColor:nil withbodarWidth:2.0 boadarColor:[UIColor redColor]];
    //圆角
    imageView4.image= [UIImage circleImage:[UIImage imageNamed:@"head"] fillColor:[UIColor yellowColor] cornerRadius:20 withbodarWidth:0 boadarColor:nil];
    
    //圆形
    roundButton1.backgroundColor = [UIColor yellowColor];
    [roundButton1 setImage:[UIImage circleImage:[UIImage imageNamed:@"head"] fillColor:nil withbodarWidth:0 boadarColor:nil] forState:UIControlStateNormal];
    //圆角 + 边框
    [roundRectButton1 setImage:[UIImage circleImage:[UIImage imageNamed:@"head"] fillColor:nil cornerRadius:20 withbodarWidth:4 boadarColor:[UIColor blueColor]] forState:UIControlStateNormal];
}

//
//
//// 非等比缩放
//- (UIImage *)Image:(UIImage *)img hyb_cropEqualScaleImageToSize:(CGSize)size {
//    CGFloat scale =  [UIScreen mainScreen].scale;
//    
//    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
//    
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}



@end
