//
//  UIImageView+FlickrImageDownloader.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "UIImageView+FlickrImageDownloader.h"

#import "Photo.h"

//Map Flickr size suffixes for appropriate image sizes for this app
NSString static *const ImageDownloadSizeString[] = {
    [ImageDownloadSizeThumbnail] = @"m",
    [ImageDownloadSizeSmall] = @"c",
    [ImageDownloadSizeMedium] = @"h",
    [ImageDownloadSizeLarge] = @"k"
};

NSString static *const kFlickrCDNURL = @"https://staticflickr.com";

@implementation UIImageView (FlickrImageDownloader)

- (void)downloadPhoto:(Photo *)photo atSize:(ImageDownloadSize)size placeholderImage:(UIImage *)placeholderImage
{
    [self downloadPhoto:photo atSize:size placeholderImage:placeholderImage animated:NO];
}

- (void)downloadPhoto:(Photo *)photo atSize:(ImageDownloadSize)size placeholderImage:(UIImage *)placeholderImage animated:(BOOL)animated
{
    NSURL *url = [self urlForPhoto:photo size:size];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    //Check if we have photo cached first
    if (cachedResponse.data)
    {
            UIImage *image = [UIImage imageWithData:cachedResponse.data];
            self.image = image;
    }
    else if (request)
    {
        self.image = placeholderImage;
        __weak typeof(self)weakSelf = self;
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (data)
            {
                UIImage *image = [UIImage imageWithData:data];
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (image)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (animated)
                        {
                            [UIView transitionWithView:self duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                strongSelf.image = image;
                            } completion:nil];
                        }
                        else
                        {
                            strongSelf.image = image;
                        }
                    });
                }
            }
        }];
        
        [task resume];
    }
}

- (void)cancelDownloadForPhoto:(Photo *)photo size:(ImageDownloadSize)size
{
    NSURL *urlToCancel = [self urlForPhoto:photo size:size];
    
    [[NSURLSession sharedSession] getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        
        //Find the matching photo request and cancel it
        NSInteger index = [dataTasks indexOfObjectPassingTest:^BOOL(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            return [obj.originalRequest.URL.absoluteString isEqualToString:urlToCancel.absoluteString];
        }];
        
        if (index != NSNotFound)
        {
            NSURLSessionDataTask *task = dataTasks[index];
            [task cancel];
        }
    }];
}

#pragma mark - Private

- (NSURL *)urlForPhoto:(Photo *)photo size:(ImageDownloadSize)size
{
    NSURLComponents *components = [NSURLComponents componentsWithString:kFlickrCDNURL];
    
    components.host = [NSString stringWithFormat:@"farm%@.%@", photo.farm, components.host];
    components.path = [NSString stringWithFormat:@"/%@/%@_%@_%@.jpg", photo.server, photo.ID, photo.secret, ImageDownloadSizeString[size]];
    
    return components.URL;
}

@end
