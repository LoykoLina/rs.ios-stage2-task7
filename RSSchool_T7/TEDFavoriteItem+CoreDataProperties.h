//
//  TEDFavoriteItem+CoreDataProperties.h
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/24/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//
//

#import "TEDFavoriteItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TEDFavoriteItem (CoreDataProperties)

+ (NSFetchRequest<TEDFavoriteItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *duration;
@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, copy) NSString *itemDescription;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *speaker;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *videoURL;

@end

NS_ASSUME_NONNULL_END
