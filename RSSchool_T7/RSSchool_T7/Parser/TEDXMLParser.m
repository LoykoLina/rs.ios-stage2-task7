//
//  TEDXMLParser.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDXMLParser.h"
#import "TEDItem.h"

@interface TEDXMLParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *itemDictionary;
@property (nonatomic, strong) NSMutableDictionary *parsingDictionary;
@property (nonatomic, strong) NSMutableString *parsingString;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *speakers;
@property (nonatomic, strong) NSMutableArray *videoURLs;
@property (nonatomic, copy) void (^completion)(NSArray<TEDItem *> *, NSError *);

@end

@implementation TEDXMLParser

- (NSMutableArray *)speakers {
    if (!_speakers) {
        _speakers = [NSMutableArray new];
    }
    return _speakers;
}

- (NSMutableArray *)videoURLs {
    if (!_videoURLs) {
        _videoURLs = [NSMutableArray new];
    }
    return _videoURLs;
}

- (void)parseTEDItem:(NSData *)data completion:(void (^)(NSArray<TEDItem *> *, NSError *))completion {
    self.completion = completion;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.completion) {
        self.completion(nil, parseError);
    }
    
    self.items = nil;
    self.itemDictionary = nil;
    self.parsingDictionary = nil;
    self.parsingString = nil;
    self.speakers = nil;
    self.videoURLs = nil;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.items = [NSMutableArray new];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"item"]) {
        self.itemDictionary = [NSMutableDictionary new];
    } else if ([elementName isEqualToString:@"itunes:image"]) {
        self.parsingDictionary = [NSMutableDictionary new];
        self.parsingString = [NSMutableString stringWithString:attributeDict[@"url"]];
        
    } else if ([elementName isEqualToString:@"media:content"]) {
        self.parsingDictionary = [NSMutableDictionary new];
        self.parsingString = [NSMutableString stringWithString:attributeDict[@"url"]];
        
    } else if ([elementName isEqualToString:@"media:credit"] ||
               [attributeDict[@"role"] isEqualToString:@"speaker"] ||
               [elementName isEqualToString:@"description"]) {
        self.parsingDictionary = [NSMutableDictionary new];
        self.parsingString = [NSMutableString new];
        
    } else if ([elementName isEqualToString:@"title"] ||
               [elementName isEqualToString:@"itunes:duration"] ||
               [elementName isEqualToString:@"link"]) {
        self.parsingDictionary = [NSMutableDictionary new];
        self.parsingString = [NSMutableString new];
    } else {
        self.parsingString = [NSMutableString new];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (self.parsingString) {
        [self.parsingDictionary setObject:self.parsingString forKey:elementName];
        self.parsingString = nil;
    }
    
    if ([elementName isEqualToString:@"itunes:image"] ||
        [elementName isEqualToString:@"title"] ||
        [elementName isEqualToString:@"itunes:duration"] ||
        [elementName isEqualToString:@"link"]) {
        [self.itemDictionary addEntriesFromDictionary:self.parsingDictionary];
        self.parsingDictionary = nil;
        
    } else if ([elementName isEqualToString:@"media:credit"]) {
        [self.speakers addObject:self.parsingDictionary[@"media:credit"]];
        self.parsingDictionary = nil;
        
    } else if ([elementName isEqualToString:@"media:content"]) {
        [self.videoURLs addObject:self.parsingDictionary[@"media:content"]];
        self.parsingDictionary = nil;
        
    } else if ([elementName isEqualToString:@"description"]) {
        [self.itemDictionary addEntriesFromDictionary:self.parsingDictionary];
        self.parsingDictionary = nil;
        
    } else if ([elementName isEqualToString:@"item"]) {
        if (self.speakers.count > 1) {
            self.itemDictionary[@"media:credit"] = [self.speakers componentsJoinedByString:@" and "];
        } else {
            self.itemDictionary[@"media:credit"] = self.speakers[0];
        }
        self.itemDictionary[@"media:content"] = self.videoURLs[4];
        
        TEDItem *item = [[TEDItem alloc] initWithDictionary:self.itemDictionary];
        self.itemDictionary = nil;
        self.speakers = nil;
        self.videoURLs = nil;
        [self.items addObject:item];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.completion) {
        self.completion(self.items, nil);
    }
    
    self.items = nil;
    self.itemDictionary = nil;
    self.parsingDictionary = nil;
    self.parsingString = nil;
    self.speakers = nil;
    self.videoURLs = nil;
}

@end
