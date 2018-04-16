//
//  ViewController.m
//  二维码
//
//  Created by GG on 2018/4/12.
//  Copyright © 2018年 GG. All rights reserved.
//

#import "ViewController.h"
#import "GGQRCodeGenerator.h"


@interface ViewController ()
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UIView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}
- (void)setUpUI{
    
    UITextField *textField = [UITextField new];
    textField.text = @"https://www.baidu.com";
    textField.text = @"http://www.cocoachina.com/bbs/read.php?tid-262913.html";
//    textField.text = @"http://a.hiphotos.baidu.com/image/pic/item/241f95cad1c8a786719e896d6b09c93d70cf5019.jpg";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    self.textField = textField;
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    CGSize size = self.view.bounds.size;
    
    CGRect frame = CGRectMake(0, 20, size.width - btn.bounds.size.width, 40);
    textField.frame = frame;
    btn.frame = CGRectMake(CGRectGetMaxX(frame), frame.origin.y, btn.bounds.size.width, frame.size.height);
    
    imageView.frame = CGRectMake(0, 0, 200, 200);
    imageView.center = self.view.center;
}

- (void)btnDidClicked:(UIButton *)btn{
    
    NSString *message = self.textField.text;
//    message = @"昨晚做头发到11点多，"
////    "店里只剩我和一个发型师，"
////    "他女友开始夺命连环call，发型师不断解释：我给大姐做完头发就回去！"
////    "他女友不依：大半夜孤男寡女，做什么头发？"
////    "发型师无奈，打开视频对着我：真在做头发！"
////    "他女友看到我后，噗嗤笑了：长这样啊，你早打开视频我不就放心了吗？"
//    "我艹。。。能给钱算我脾气好！\";";
    
    self.imageView.image = [GGQRCodeGenerator gg_QRCodeImageWithMessage:message centerImage:[self getCenterImage]];
}
- (UIImage *)getCenterImage{
    
    
    UIImage *centerImage = [UIImage imageNamed:@"appstore"];
    CGRect rect = CGRectMake(0, 0, centerImage.size.width, centerImage.size.height);
    UIGraphicsBeginImageContextWithOptions(centerImage.size, 0, centerImage.scale);
    
    [[UIColor redColor] setFill];
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width * 0.2];
    [path addClip];
    
    [centerImage drawInRect:CGRectMake(0, 0, centerImage.size.width, centerImage.size.height)];
    centerImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
//    [[UIColor whiteColor] setFill];
//    UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:rect];
//    [rectpath fill];
    [centerImage drawInRect:rect];
    
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContextWithOptions(centerImage.size, 0, centerImage.scale);
    
    [[UIColor whiteColor] setFill];
//    [[UIColor blueColor] set];
    UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:rect];
    [rectpath fill];
    [centerImage drawInRect:rect];
    centerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return centerImage;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


@end
