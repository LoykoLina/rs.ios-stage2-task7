//
//  TEDTabBarController.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDTabBarController.h"
#import "TEDHomeController.h"
#import "TEDFavoritesController.h"

static CGFloat const kTabImageOffset = 5;

@interface TEDTabBarController ()

@end

@implementation TEDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"background_color"];
    [self setupTabsControllers];
}

- (void)setupTabsControllers {
    TEDHomeController *homeVC = [[TEDHomeController alloc] initWithStyle:UITableViewStyleGrouped];
    [self setupTabViewController:homeVC
                           image:[UIImage imageNamed:@"home_unselected"]
                   selectedImage:[UIImage imageNamed:@"home_selected"]];
    
    TEDFavoritesController *favoritesVC = [[TEDFavoritesController alloc] init];
    [self setupTabViewController:favoritesVC
                           image:[UIImage imageNamed:@"favorites_unselected"]
                   selectedImage:[UIImage imageNamed:@"favorites_selected"]];
    
    self.viewControllers = @[[self embedInNavigationController:homeVC],
                             [self embedInNavigationController:favoritesVC]];
}

- (UINavigationController *)embedInNavigationController:(UIViewController*)vc {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nc.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [nc.navigationBar setTranslucent:NO];
    [nc.navigationBar setBarTintColor:[UIColor colorNamed:@"background_color"]];
    
    UIImage *image = [UIImage new];
    nc.navigationBar.shadowImage = image;
    [nc.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    return nc;
}

- (void)setupTabViewController:(UIViewController *)vc image:()image selectedImage:()selectedImage{
    vc.view.backgroundColor = [UIColor colorNamed:@"background_color"];
    vc.tabBarItem = [[UITabBarItem alloc]
                         initWithTitle:nil
                         image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                         selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(kTabImageOffset, 0, -kTabImageOffset, 0);
}

@end
