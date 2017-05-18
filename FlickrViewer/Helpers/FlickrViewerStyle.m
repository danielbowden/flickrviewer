//
//  FlickrViewerStyle.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 18/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "FlickrViewerStyle.h"

#import "UIColor+FlickrViewer.h"
#import "UIImage+FlickrViewer.h"

@implementation FlickrViewerStyle

+ (void)addStyles
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor flickrViewerAccent]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor flickrViewerAccent]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor whiteColor]
                                                           }];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor flickrViewerAccent]]];
    [[UISearchBar appearance] setScopeBarBackgroundImage:[UIImage imageWithColor:[UIColor flickrViewerAccent]]];
    [[UISearchBar appearance] setTintColor:[UIColor whiteColor]];
    [[UISearchBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITextField appearance] setTintColor:[UIColor flickrViewerAccent]];
}

+ (void)removeStyles
{
    [[UINavigationBar appearance] setTintColor:nil];
    [[UIBarButtonItem appearance] setTintColor:nil];
    [[UINavigationBar appearance] setTitleTextAttributes:nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:nil forState:UIControlStateNormal];
    [[UIBarItem appearance] setTitleTextAttributes:nil forState:UIControlStateNormal];
}

@end
