//
//  GalleryDataSource.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "GalleryDataSource.h"

#import "Photo.h"
#import "SearchService.h"

@interface GalleryDataSource ()

@property (nonatomic, strong) NSMutableArray<Photo *> *photos;
@property (nonatomic, strong) SearchService *searchService;

@end

@implementation GalleryDataSource

- (instancetype)init
{
    if ((self = [super init]))
    {
        _photos = [NSMutableArray array];
        _searchService = [[SearchService alloc] init];
    }
    
    return self;
}

- (Photo *)photoAtIndex:(NSInteger)index
{
    if (index < [self numberOfPhotos])
    {
        return self.photos[index];
    }
    
    return nil;
}

- (NSInteger)numberOfPhotos
{
    return self.photos.count;
}

- (void)refreshPhotosWithLocation:(CLLocation *)location searchTerm:(NSString *)searchTerm completion:(void (^)(BOOL, NSError *))completionBlock
{
    [self.searchService photosForLocation:location searchTerm:searchTerm success:^(NSArray<Photo *> *photos) {
        
        [self.photos removeAllObjects];
        [self.photos addObjectsFromArray:photos];
        
        if (completionBlock)
        {
            completionBlock(YES, nil);
        }
        
    } failure:^(NSError *error) {
        
        if (completionBlock)
        {
            completionBlock(NO, error);
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfPhotos];
}

@end
