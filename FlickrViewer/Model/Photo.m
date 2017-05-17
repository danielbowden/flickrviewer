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
        _owner = data[@"ownername"];
        
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
        
        NSString *tagString = data[@"tags"];
        if (tagString && tagString.length)
        {
            _tags = [tagString componentsSeparatedByString:@" "];
        }
    }
    
    return self;
}

- (NSString *)displayDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    if (self.date)
    {
        return [NSString stringWithFormat:@"UPLOADED: %@", [formatter stringFromDate:self.date].uppercaseString];
    }
    else
    {
        return @"UPLOADED: UNKNOWN";
    }
}

- (NSString *)displayViews
{
    return [NSString stringWithFormat:@"%@ %@", self.views, self.views.integerValue != 1 ? @"VIEWS" : @"VIEW"];
}

- (NSString *)displayDimensions
{
    if (CGSizeEqualToSize(self.originalDimensions, CGSizeZero))
    {
        return @"ORIGINAL: UNKNOWN";
    }
    else
    {
        return [NSString stringWithFormat:@"ORIGINAL: %.fx%.f", self.originalDimensions.width, self.originalDimensions.height];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Super %@ \n ID: %@ \n secret: %@ \n server: %@ \n farm: %@ \n title: %@ \n views: %@ \n date: %@ \n location: %f,%f \n originalDimensions: %@",
            [super description],
            self.ID,
            self.secret,
            self.server,
            self.farm,
            self.title,
            self.views,
            self.date,
            self.location.latitude, self.location.longitude,
            NSStringFromCGSize(self.originalDimensions)];
}

@end
