//
//  TEDVideo.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDItem.h"

@implementation TEDItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _speaker = dictionary[@"media:credit"];
        _title = dictionary[@"title"];
        _imageURL = dictionary[@"itunes:image"];
        _duration = dictionary[@"itunes:duration"];
        _link = dictionary[@"link"];
        _itemDescription = dictionary[@"description"];
        _videoURL = dictionary[@"media:content"];
    }
    return self;
}

@end
