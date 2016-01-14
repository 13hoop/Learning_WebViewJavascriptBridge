#import "ExampleAppDelegate.h"
#import "ExampleUIWebViewController.h"
#import "ExampleWKWebViewController.h"

#import "ZXViewController.h"

@implementation ExampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1. Create the UIWebView example
    ExampleUIWebViewController* UIWebViewExampleController = [[ExampleUIWebViewController alloc] init];
    UIWebViewExampleController.tabBarItem.title = @"之前UIWebView";

    // 2. Create the tab footer and add the UIWebView example
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController addChildViewController:UIWebViewExampleController];
    
    // 3. Create the  WKWebView example for devices >= iOS 8
    // iOS8 及其以上，使用WebKit
    if([WKWebView class]) {
        ExampleWKWebViewController* WKWebViewExampleController = [[ExampleWKWebViewController alloc] init];
        WKWebViewExampleController.tabBarItem.title = @"8以后WKWebView";
        [tabBarController addChildViewController:WKWebViewExampleController];
    }

    ZXViewController *zx = [[ZXViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = tabBarController;
    self.window.rootViewController = zx;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
