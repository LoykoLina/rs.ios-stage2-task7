//
//  TEDImageDownloadOperation.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDImageDownloadOperation.h"

@interface TEDImageDownloadOperation ()

@property (nonatomic, copy) NSString *url;

@end

@implementation TEDImageDownloadOperation

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)main {
    __weak typeof(self) weakSelf = self;
    if (self.isCancelled) { return; }

    NSURL *url = [NSURL URLWithString:self.url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                                      dataTaskWithURL:url
                                      completionHandler:^(NSData *data,
                                                          NSURLResponse *response,
                                                          NSError * error) {
        if (weakSelf.isCancelled) { NSLog(@"[TEDImageDownloadOperation] - cancelled"); return; }
        if (!data) { return; }
        UIImage *image = [UIImage imageWithData:data];
        weakSelf.image = image;
        if (self.completion) {
            self.completion(image);
        }
    }];

    if (self.isCancelled) { return; }
    [dataTask resume];
}

@end

