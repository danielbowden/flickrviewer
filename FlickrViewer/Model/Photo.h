//
//  Photo.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 13/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Photo : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *farm;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) CGSize originalDimensions;
@property (nonatomic, strong) NSNumber *views;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, strong) NSArray<NSString *> *tags;

- (instancetype)initWithJSON:(NSDictionary *)data;

- (NSString *)displayViews;
- (NSString *)displayDate;
- (NSString *)displayDimensions;

@end
