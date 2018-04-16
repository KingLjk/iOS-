//
//  GGQRCodeGenerator.m
//  二维码
//
//  Created by GG on 2018/4/12.
//  Copyright © 2018年 GG. All rights reserved.
//

#import "GGQRCodeGenerator.h"

@implementation GGQRCodeGenerator

+ (UIImage *)gg_QRCodeImageWithMessage:(NSString *)message centerImage:(UIImage *)centerImage{
    
    // CIQRCodeGenerator的由来
    //    // 获取分类里对应的二维码的过滤器
    //    NSArray *tempArray = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    //    NSLog(@"%@",tempArray);

    
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 滤镜设置默认值
    [filter setDefaults];
    /*
     inputMessage,         二维码的内容
     inputCorrectionLevel  二维码的容错率
     */
//    NSLog(@"%@",filter.inputKeys);

    // 3. 给滤镜添加数据
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    // inputMessage必须要传入二进制   否则会崩溃
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4. 获取二维码的图片
    CIImage *outputImage = [filter outputImage];
    
    
    // 5. 放大图片到指定尺寸
    CGSize size = CGSizeMake(200, 200);
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
    CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleWidth, scaleHeight)];
    UIImage *image = [UIImage imageWithCIImage:outputImage];
    
    
    UIGraphicsBeginImageContextWithOptions(size, 0, 1);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    if (centerImage) {
        // 35 40 50 55 60(微信可以，系统相机)
        CGFloat scale = 55/200.0;
        CGSize centerSize = CGSizeMake(scale * size.width, scale * size.height);
        [centerImage drawInRect:CGRectMake((size.width - centerSize.width) * 0.5, (size.height - centerSize.height) * 0.5, centerSize.width, centerSize.height)];
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
//
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//
//    // 1.创建bitmap;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//
//    // 2.保存bitmap到图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}



@end
