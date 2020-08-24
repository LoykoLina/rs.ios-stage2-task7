//
//  TEDItemService.h
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TEDXMLParser;
@class TEDItem;

@interface TEDItemService : NSObject

- (instancetype)initWithParser:(TEDXMLParser *)parser;
- (void)loadImageForURL:(NSString *)url completion:(void (^)(UIImage *))completion;
- (void)loadItemsFromWeb:(void (^)(NSArray<TEDItem *> *, NSError *))completion;
- (void)cancelDownloadingForUrl:(NSString *)url;

- (void)saveItem:(TEDItem *)item;
- (BOOL)isSavedItem:(TEDItem *)item;
- (void)deleteItem:(TEDItem *)item;
- (void)loadSavedItems:(void (^)(NSArray<TEDItem *> *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
