//
//  TEDFavoriteItem+CoreDataProperties.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/24/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//
//

#import "TEDFavoriteItem+CoreDataProperties.h"

@implementation TEDFavoriteItem (CoreDataProperties)

+ (NSFetchRequest<TEDFavoriteItem *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TEDFavoriteItem"];
}

@dynamic duration;
@dynamic imageURL;
@dynamic itemDescription;
@dynamic link;
@dynamic speaker;
@dynamic title;
@dynamic videoURL;

@end
