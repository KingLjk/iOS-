//
//  ViewController.m
//  键盘处理
//  利用UIKeyboardWillChangeFrameNotification、UIKeyboardWillHideNotification两个通知监听键盘
//  Created by GG on 2018/4/3.
//  Copyright © 2018年 GG. All rights reserved.
//

#import "ViewController.h"

#define kGGRGBColor(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1.0]

@interface ViewController ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *textField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNotifications];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpUI{
    CGSize size = self.view.bounds.size;
    CGRect frame = CGRectMake(0, 0, size.width, size.height - 44);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height * 2);
    scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    for (int i = 0; i<10; i++) {
        UIView *view = [UIView new];
        CGFloat r = arc4random()%256/255.0f;
        CGFloat g = arc4random()%256/255.0f;
        CGFloat b = arc4random()%256/255.0f;
        view.backgroundColor = kGGRGBColor(r, g, b);
        view.frame = CGRectMake(0, scrollView.contentSize.height/10 * i, scrollView.contentSize.width, scrollView.contentSize.height/10);
        [scrollView addSubview:view];
    }
    
    frame = CGRectMake(0, CGRectGetMaxY(frame), frame.size.width, 44);
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [self.view addSubview:textField];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"点击输入内容";
    self.textField = textField;
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"结束编辑" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn sizeToFit];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置拖拽 ScrollView 隐藏键盘
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
#pragma ********************* 1. 添加键盘的监听 *********************
- (void)addKeyboardNotifications{
    
    // 监听键盘的位置改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    // 监听键盘的隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)btnDidClicked:(UIButton *)btn{
    [self.view endEditing:YES];
}

- (void)keyboardWillChange:(NSNotification *)notification{
    
    /*
    {name = UIKeyboardWillChangeFrameNotification; userInfo = {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 271}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 871.5}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 600.5}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 736}, {414, 271}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 465}, {414, 271}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     }}
     */
    /*
     {name = UIKeyboardWillHideNotification; userInfo = {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {414, 271}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {207, 600.5}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {207, 871.5}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 465}, {414, 271}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 736}, {414, 271}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     }}
     */
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = 0;
    //⚠️ [self.view endEditing:YES]; 结束编辑的方法发送UIKeyboardWillChangeFrameNotification通知,此处的y不为零，所以要添加UIKeyboardWillHideNotification通知
    NSLog(@"%@--->:%f",notification.name,y);
    if (notification.name == UIKeyboardWillChangeFrameNotification) {
        y = keyboardFrameEnd.size.height;
    }

    // 开始动画
//    [UIView beginAnimations:@"translate" context:nil];
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:duration];
    CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -y);
    [self.textField setTransform:transform];
    
//     // 偏移整个视图
//    [self.view setTransform:transform];
    
    // 提交动画
    [UIView commitAnimations];
    
}




@end
