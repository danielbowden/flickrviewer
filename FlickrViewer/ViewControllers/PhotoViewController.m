//
//  PhotoViewController.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 16/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "PhotoViewController.h"

#import "Photo.h"
#import "UIImageView+FlickrImageDownloader.h"
#import "GradientBackView.h"

@interface PhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet GradientBackView *metadataView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *originalDimensionsLabel;
@property (nonatomic, weak) IBOutlet UILabel *viewsLabel;

@end

@implementation PhotoViewController

- (instancetype)initWithPhoto:(Photo *)photo
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *identifier = NSStringFromClass([self class]);
    
    if ((self = [storyboard instantiateViewControllerWithIdentifier:identifier]))
    {
        _photo = photo;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.photo.owner;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *placeholder = [UIImage imageNamed:@"placeholder-lrg"];
    [self.photoImageView downloadPhoto:self.photo atSize:ImageDownloadSizeLarge placeholderImage:placeholder animated:YES];
    
    self.titleLabel.text = self.photo.title;
    self.viewsLabel.text = [self.photo displayViews];
    self.dateLabel.text = [self.photo displayDate];
    self.originalDimensionsLabel.text = [self.photo displayDimensions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
