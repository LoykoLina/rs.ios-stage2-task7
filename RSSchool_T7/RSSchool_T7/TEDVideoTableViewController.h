//
//  TEDVideoTableViewController.h
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TEDItem;
@class TEDItemService;

@interface TEDVideoTableViewController : UITableViewController

@property (copy, nonatomic) NSArray<TEDItem *> *dataSource;
@property (strong, nonatomic) TEDItemService *itemService;

@end

NS_ASSUME_NONNULL_END
