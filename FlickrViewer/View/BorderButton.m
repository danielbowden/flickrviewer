//
//  BorderButton.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 18/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "BorderButton.h"

@implementation BorderButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
        self.layer.borderColor = self.tintColor.CGColor;
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    self.layer.borderColor = tintColor.CGColor;
    [self setTitleColor:tintColor forState:UIControlStateNormal];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted == super.highlighted)
    {
        return;
    }
    
    [super setHighlighted:highlighted];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.layer.backgroundColor = highlighted ? self.tintColor.CGColor : [UIColor clearColor].CGColor;
    }];
}

@end
