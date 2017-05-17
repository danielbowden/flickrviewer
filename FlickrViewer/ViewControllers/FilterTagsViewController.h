//
//  FilterTagsViewController.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 17/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FilterTagsSelectionBlock)(NSArray<NSString *> *selectedTags);

@interface FilterTagsViewController : UIViewController

@property (nonatomic, strong) NSArray<NSString *> *availableTags;

- (instancetype)initWithAvailableTags:(NSArray<NSString *> *)availableTags completion:(FilterTagsSelectionBlock)completionBlock;

@end
