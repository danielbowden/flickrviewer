//
//  Photo.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 13/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "Photo.h"


@interface Photo ()

@end

static NSDateFormatter *dateFormatter = nil;

@implementation Photo

- (instancetype)initWithJSON:(NSDictionary *)data
{
    if ((self = [super init]))
    {
        _ID = data[@"id"];
        _secret = data[@"secret"];
        _server = data[@"server"];
        _farm = data[@"farm"];
        _title = data[@"title"];
        _views = data[@"views"];
        
        NSString *uploadDate = data[@"dateupload"];
        if (uploadDate)
        {
            _date = [NSDate dateWithTimeIntervalSince1970:[uploadDate doubleValue]];
        }
        
        NSString *latitude = data[@"latitude"];
        NSString *longitude = data[@"longitude"];
        if (latitude && longitude)
        {
            _location = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
        }
        else
        {
            _location = kCLLocationCoordinate2DInvalid;
        }
        
        NSNumber *originalWidth = data[@"o_width"];
        NSNumber *originalHeight = data[@"o_height"];
        if (originalWidth && originalHeight)
        {
            _originalDimensions = CGSizeMake(originalWidth.floatValue, originalHeight.floatValue);
        }
    }
    
    return self;
}

@end
