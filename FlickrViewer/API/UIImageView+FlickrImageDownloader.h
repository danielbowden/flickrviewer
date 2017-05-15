//
//  UIImageView+FlickrImageDownloader.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

typedef NS_ENUM(NSInteger, ImageDownloadSize)
{
    ImageDownloadSizeThumbnail = 0,
    ImageDownloadSizeSmall,
    ImageDownloadSizeMedium,
    ImageDownloadSizeLarge
};

@interface UIImageView (FlickrImageDownloader)

- (void)downloadPhoto:(Photo *)photo atSize:(ImageDownloadSize)size placeholderImage:(UIImage *)placeholderImage;
- (void)downloadPhoto:(Photo *)photo atSize:(ImageDownloadSize)size placeholderImage:(UIImage *)placeholderImage animated:(BOOL)animated;
- (void)cancelDownloadForPhoto:(Photo *)photo size:(ImageDownloadSize)size;

@end
