//
//  SearchService.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 13/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Photo;

@interface SearchService : NSObject

- (void)photosForLocation:(CLLocation *)location success:(void (^)(NSArray<Photo *> *photos))success failure:(void (^)(NSError *error))failure;
- (void)photosForLocation:(CLLocation *)location searchTerm:(NSString *)searchTerm success:(void (^)(NSArray<Photo *> *photos))success failure:(void (^)(NSError *error))failure;

@end
