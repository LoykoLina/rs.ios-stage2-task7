//
//  TEDVideo.h
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TEDItem : NSObject

@property (nonatomic, copy) NSString *speaker;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
