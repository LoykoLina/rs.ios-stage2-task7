//
//  TEDHomeController.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDHomeController.h"
#import "TEDItemService.h"
#import "TEDXMLParser.h"

@interface TEDHomeController ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation TEDHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSArray new];
    self.itemService = [[TEDItemService alloc] initWithParser:[TEDXMLParser new]];
    
    if (@available(iOS 13.0, *)) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    } else {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    self.activityIndicator.color = [UIColor colorNamed:@"title_color"];
    self.tableView.backgroundView = self.activityIndicator;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     
    [self startLoading];
}

- (void)startLoading {
    __weak typeof(self) weakSelf = self;
    [self.activityIndicator startAnimating];
    [self.itemService loadItemsFromWeb:^(NSArray<TEDItem *> *items, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                UIAlertController *alertController;
                
                if (error.code == NSURLErrorNotConnectedToInternet) {
                    alertController = [UIAlertController alertControllerWithTitle:@"Cellular Data is Turned Off"
                                                                          message:[NSString stringWithFormat:@"Turn on cellular data or use Wi-Fi to access data"]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                    NSURL *settingsURL = [NSURL URLWithString:@"App-Prefs:root=Cellular"];
    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Settings"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action) {
                        if ([UIApplication.sharedApplication canOpenURL:settingsURL]) {
                            [UIApplication.sharedApplication openURL:settingsURL options:@{} completionHandler:nil];
                        }
                    }]];
                } else {
                    alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                          message:[NSString stringWithFormat:@"Something went wrong"]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                }
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
            } else {
                weakSelf.dataSource = items;
                [weakSelf.tableView reloadData];
            }
            [weakSelf.activityIndicator stopAnimating];
        });
    }];
}


@end
