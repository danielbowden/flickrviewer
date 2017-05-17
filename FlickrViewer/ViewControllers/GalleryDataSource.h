//
//  GalleryDataSource.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Photo;

typedef NS_ENUM(NSInteger, GallerySearchScope)
{
    GallerySearchScopeKeyword = 0,
    GallerySearchScopeTag
};

NSString static *const GallerySearchScopeTitle[] = {
    [GallerySearchScopeKeyword] = @"Keywords",
    [GallerySearchScopeTag] = @"Tags"
};

@interface GalleryDataSource : NSObject <UICollectionViewDataSource>

- (void)searchPhotosWithLocation:(CLLocation *)location searchText:(NSString *)searchText scope:(GallerySearchScope)scope completion:(void (^)(BOOL success, NSError *error))completionBlock;

- (Photo *)photoAtIndex:(NSInteger)index;
- (NSInteger)numberOfPhotos;

@end
