//
//  main.m
//  UBICoreDataApp
//
//  Created by Yuki Yasoshima on 2015/12/02.
//
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject

@property (nonatomic) UIWindow *window;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = [[UIViewController alloc] init];
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"AppDelegate");
    }
}
