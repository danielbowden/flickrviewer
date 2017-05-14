//
//  PhotoCell.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) Photo *photo;

+ (NSString *)cellIdentifier;

@end
