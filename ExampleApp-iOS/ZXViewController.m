//
//  ZXViewController.m
//  ExampleApp-iOS
//
//  Created by YongRen on 16/1/13.
//  Copyright © 2016年 Marcus Westin. All rights reserved.
//

#import "ZXViewController.h"
#import "WebViewJavascriptBridge.h"

//#define HTML_STRING(htmlPath)  [NSString stringWithContentsOfFile:htmlPath \
//encoding:NSUTF8StringEncoding error:nil]

@interface ZXViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation ZXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // 获取本地html
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ZXDemo.html" ofType:nil];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    NSString *str = [NSString stringWithContentsOfFile: htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:str baseURL: [NSURL fileURLWithPath:htmlPath]];
    
    [self.view addSubview:self.webView];
    
    // OC中的初始化
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {

        NSLog(@" data: %@", data);
        responseCallback(@"back");

    }];
    
    // OC中
    [self.bridge registerHandler:@"ZXOCHandler" handler:^(id data, WVJBResponseCallback responseCallback) {

        NSLog(@"[OC中]，JS传来的消息：%@", data);
        
        [self sendMessage:nil];
        responseCallback(@"[OC中]，已收到");
    }];
    
    
    [self createBtn];
}

- (void) sendMessage: (UIButton *) btn {

//    NSLog(@" -- 发送消息 --");
//    [self.bridge send:@"TED is goooood!" responseCallback:^(id responseData) {
//        NSLog(@"what we receve: %@ ", responseData);
//    }];

//    NSLog(@"-- 调用 ZXJSHandler --");
//    [self.bridge callHandler:@"ZXJSHandler" data:@"［OC中］来自OC的问候" responseCallback:^(id responseData) {
//        NSLog(@"ZXJSHandler的回复： %@", responseData);
//    }];

        NSLog(@"-- 调用 ZXOCHandler ,其实是在sendMessage中， 😄--");

}


- (void) createBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(150, 400, 100, 60);
    [btn setTitle:@"发送消息" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:btn aboveSubview:self.webView];
}

@end
