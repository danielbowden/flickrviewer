//
//  UIColor+FlickrViewer.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 18/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "UIColor+FlickrViewer.h"

@implementation UIColor (FlickrViewer)

+ (instancetype)flickrViewerAccent
{
    return [UIColor colorWithRed:238.0/255.0 green:117.0/255.0 blue:70.0/255.0 alpha:1.0];
}

+ (instancetype)flickrViewerContent
{
    return [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
}

+ (instancetype)flickrViewerBackground
{
    return [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
}


@end
