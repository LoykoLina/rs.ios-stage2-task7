//
//  TEDXMLParser.h
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TEDItem;

@interface TEDXMLParser : NSObject 

- (void)parseTEDItem:(NSData *)data completion:(void (^)(NSArray<TEDItem *> *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
