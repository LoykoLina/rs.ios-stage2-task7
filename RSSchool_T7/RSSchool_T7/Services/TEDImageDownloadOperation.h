//
//  TEDImageDownloadOperation.h
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TEDImageDownloadOperation : NSOperation

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void(^completion)(UIImage *);

- (instancetype)initWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
