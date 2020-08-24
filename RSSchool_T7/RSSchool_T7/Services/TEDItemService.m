//
//  TEDItemService.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/21/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDItemService.h"
#import "TEDXMLParser.h"
#import "TEDImageDownloadOperation.h"
#import "TEDItem.h"
#import "AppDelegate.h"
#import "TEDFavoriteItem+CoreDataProperties.h"

@interface TEDItemService ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) TEDXMLParser *parser;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<NSOperation *> *> *operations;

@end

@implementation TEDItemService

- (instancetype)initWithParser:(TEDXMLParser *)parser {
    self = [super init];
    if (self) {
        _parser = parser;
        _queue = [NSOperationQueue new];
        _operations = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Load and parse item from URL

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

- (void)loadItemsFromWeb:(void (^)(NSArray<TEDItem *> *, NSError *))completion {
    NSURL *url = [NSURL URLWithString:@"https://www.ted.com/themes/rss/id"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }

        [self.parser parseTEDItem:data completion:completion];
    }];

    [dataTask resume];
}

#pragma mark - Load image from URL

- (void)loadImageForURL:(NSString *)url completion:(void (^)(UIImage *))completion {
    [self cancelDownloadingForUrl:url];
    TEDImageDownloadOperation *operation = [[TEDImageDownloadOperation alloc] initWithUrl:url];
    self.operations[url] = @[operation];
    operation.completion = ^(UIImage *image) {
        completion(image);
    };
    [self.queue addOperation:operation];
}

- (void)cancelDownloadingForUrl:(NSString *)url {
    NSArray<NSOperation *> *operations = self.operations[url];
    if (!operations) { return; }
    for (NSOperation *operation in operations) {
        [operation cancel];
    }
}


#pragma mark - Core Data

- (NSManagedObjectContext *)viewContext {
    return ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
}

- (NSManagedObjectContext *)newBackgroundContext {
    return ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.newBackgroundContext;
}

- (BOOL)isSavedItem:(TEDItem *)item {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"TEDFavoriteItem" inManagedObjectContext:[self viewContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", item.link];
    request.predicate = predicate;
    NSError *error = nil;
    
    NSInteger isExist = [[self viewContext] countForFetchRequest:request error:&error];
    if (error) {
    }
    
    return isExist == 1;
}

- (void)saveItem:(TEDItem *)item {
        
    NSManagedObjectContext *context = [self newBackgroundContext];
    
    __block TEDFavoriteItem *favItem;
    [context performBlockAndWait:^{
        favItem = [[TEDFavoriteItem alloc] initWithContext:context];
        favItem.title = item.title;
        favItem.speaker = item.speaker;
        favItem.itemDescription = item.itemDescription;
        favItem.link = item.link;
        favItem.duration = item.duration;
        favItem.videoURL = item.videoURL;
        favItem.imageURL = item.imageURL;
    }];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"[TEDItemService] - Couldn't save: %@", error);
    }
}

- (void)deleteItem:(TEDItem *)item {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"TEDFavoriteItem" inManagedObjectContext:[self viewContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link == %@", item.link];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *objs = [[self viewContext] executeFetchRequest:request error:&error];
    if (error) {
        return;
    }
    
    NSManagedObjectContext *context = [self viewContext];
    [context performBlockAndWait:^{
        [context deleteObject:objs[0]];
    }];

    if (![context save:&error]) {
        NSLog(@"[TEDItemService] - Couldn't save: %@", error);
    }
}

- (void)loadSavedItems:(void (^)(NSArray<TEDItem *> *, NSError *))completion {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"TEDFavoriteItem" inManagedObjectContext:[self viewContext]];
    NSError *error = nil;
    NSArray *objs = [[self viewContext] executeFetchRequest:request error:&error];
    if (error) {
        completion(nil, error);
        return;
    }
    
    NSManagedObjectContext *context = [self newBackgroundContext];
    __block NSMutableArray<TEDItem *> *items = [[NSMutableArray  alloc] init];
    
    [context performBlockAndWait:^{
        for (TEDFavoriteItem *favItem in objs) {
            TEDItem *item = [[TEDItem alloc]init];
            item.title = favItem.title;
            item.speaker = favItem.speaker;
            item.itemDescription = favItem.itemDescription;
            item.link = favItem.link;
            item.duration = favItem.duration;
            item.videoURL = favItem.videoURL;
            item.imageURL = favItem.imageURL;
            
            [items addObject:item];
        }
    }];
    
    if (![context save:&error]) {
        NSLog(@"[TEDItemService] - Couldn't save: %@", error);
        completion(nil, error);
        return;
    }
    
    completion(items, nil);
}

@end
