//
//  UIImage+FlickrViewer.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 17/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FlickrViewer)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
