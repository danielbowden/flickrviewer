//
//  FilterTagCell.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 17/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTagCell : UITableViewCell

+ (NSString *)cellIdentifier;
- (void)populateWithTag:(NSString *)tag selected:(BOOL)selected;
- (void)setTagSelected:(BOOL)selected;

@end
