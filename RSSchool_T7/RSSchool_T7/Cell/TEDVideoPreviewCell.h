//
//  TEdVideoPreviewCell.h
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEDItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TEDVideoPreviewCell : UITableViewCell

- (void)setupCellWithItem:(TEDItem *)item;

@end

NS_ASSUME_NONNULL_END
