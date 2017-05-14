//
//  PhotoCell.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "PhotoCell.h"

#import "Photo.h"
#import "UIImageView+FlickrImageDownloader.h"

@interface PhotoCell ()

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@end

@implementation PhotoCell

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)setPhoto:(Photo *)aPhoto
{
    _photo = aPhoto;
    UIImage *placeholder = [UIImage imageNamed:@"placeholder-th"];
    [self.photoImageView downloadPhoto:_photo atSize:ImageDownloadSizeThumbnail placeholderImage:placeholder animated:YES];
}
}

@end
