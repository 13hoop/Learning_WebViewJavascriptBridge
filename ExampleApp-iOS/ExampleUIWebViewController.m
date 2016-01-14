//
//  ExampleUIWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "ExampleUIWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ExampleUIWebViewController ()
/// 引入“WebViewJavascriptBridge”
@property WebViewJavascriptBridge* bridge;
@end

@implementation ExampleUIWebViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_bridge) { return; }
    
    // 创建webView
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    // 输出日志
    [WebViewJavascriptBridge enableLogging];
    
    // 实例化WebViewJavascriptBridge并且带上一个UIWebView (iOS)或者WebView (OSX)
    NSLog(@" - 0 - create bridge when start! --");
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"只要js调OC，就执行");
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];

    // javascript -> OC
    // testObjcCallback要一致
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"OC 中 testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    // OC 发消息给 js
//    [_bridge send:@"［OC中］：从ObjC到javascript发送一些消息 before Webview has loaded : Give me a response, will you?" responseCallback:^(id responseData) {
//        NSLog(@"objc got response! %@", responseData);
//    }];
    
    // OC -> js
//    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
    
//    [_bridge send:@"A string sent from ObjC after Webview has loaded."];
}

// 在webView上添加3个Btn
- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [messageButton setTitle:@"本地发送消息" forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:messageButton aboveSubview:webView];
    messageButton.frame = CGRectMake(10, 470, 100, 35);
    messageButton.titleLabel.font = font;
    messageButton.backgroundColor = [UIColor redColor];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callbackButton.backgroundColor = [UIColor yellowColor];
    [callbackButton setTitle:@"调用方法Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(110, 470, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reloadButton.backgroundColor = [UIColor orangeColor];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(210, 470, 100, 35);
    reloadButton.titleLabel.font = font;
}


#pragma mark 本地事件 （oc －> js）
// 发消息
- (void)sendMessage:(id)sender {
    [_bridge send:@"本地消息" responseCallback:^(id response) {
        NSLog(@"［oc］sendMessage got response: %@", response);
    }];
}
// 调方法
- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!  来自OC的调用" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

#pragma mark 加载HTML
- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

#pragma mark webView-Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"－－－ 111 webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"－－－ 222 webViewDidFinishLoad");
}


@end
