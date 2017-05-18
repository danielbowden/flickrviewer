//
//  FilterTagCell.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 17/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "FilterTagCell.h"

#import "UIColor+FlickrViewer.h"

@interface FilterTagCell ()

@property (nonatomic, weak) IBOutlet UILabel *tagLabel;
@property (nonatomic, weak) IBOutlet UIImageView *selectedImage;

@end

@implementation FilterTagCell

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.tagLabel.textColor = [UIColor flickrViewerContent];
    self.selectedImage.image = [self.selectedImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.selectedImage.tintColor = [UIColor flickrViewerAccent];
}

- (void)populateWithTag:(NSString *)tag selected:(BOOL)selected
{
    self.tagLabel.text = tag;
    self.selectedImage.hidden = !selected;
    
    CGFloat fontSize = self.tagLabel.font.pointSize;
    self.tagLabel.font = selected ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
}

- (void)setTagSelected:(BOOL)selected
{
    if (selected)
    {
        self.tagLabel.font = [UIFont boldSystemFontOfSize:self.tagLabel.font.pointSize];
        self.selectedImage.hidden = NO;
        self.selectedImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        [UIView animateWithDuration:0.3/1.5 animations:^{
            self.selectedImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.selectedImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3/2 animations:^{
                    self.selectedImage.transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }
    else
    {
        self.tagLabel.font = [UIFont systemFontOfSize:self.tagLabel.font.pointSize];
        self.selectedImage.hidden = YES;
    }
}

@end
