//
//  TEDFavouritesController.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDFavoritesController.h"
#import "TEDItemService.h"
#import <CoreData/CoreData.h>
#import "TEDFavoriteItem+CoreDataProperties.h"
#import "AppDelegate.h"

@interface TEDFavoritesController ()

@end

@implementation TEDFavoritesController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.itemService = [[TEDItemService alloc] init];
    self.dataSource = [NSArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [self.itemService loadSavedItems:^(NSArray<TEDItem *> *items, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                         message:[NSString stringWithFormat:@"Something went wrong"]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
            } else {
                weakSelf.dataSource = items;
                [weakSelf.tableView reloadData];
            }
        });
    }];
}

@end
