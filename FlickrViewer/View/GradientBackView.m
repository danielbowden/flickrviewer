//
//  GradientBackView.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 16/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "GradientBackView.h"

@implementation GradientBackView

@dynamic layer;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.layer.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,

                          (id)[UIColor colorWithWhite:0.0 alpha:0.9].CGColor];
    self.layer.locations = @[@(0), @(0.7)];
    self.layer.startPoint = CGPointMake(0.0, 0.0);
    self.layer.endPoint = CGPointMake(0.0, 1.0);
}

@end
