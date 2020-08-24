#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "TEDTabBarController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)) {
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    TEDTabBarController *tabBarVC = [TEDTabBarController new];
    tabBarVC.tabBar.barTintColor = [UIColor colorNamed:@"tabbar_color"];
    [tabBarVC.tabBar setTranslucent:NO];
    [self.window setRootViewController:tabBarVC];
    [self.window makeKeyAndVisible];
}


@end
