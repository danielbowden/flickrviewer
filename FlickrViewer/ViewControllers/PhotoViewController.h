//
//  PhotoViewController.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 16/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) Photo *photo;

- (instancetype)initWithPhoto:(Photo *)photo;

@end
