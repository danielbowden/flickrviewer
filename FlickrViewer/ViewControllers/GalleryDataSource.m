//
//  GalleryDataSource.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "GalleryDataSource.h"

#import "Photo.h"
#import "PhotoCell.h"
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

- (void)searchPhotosWithLocation:(CLLocation *)location searchText:(NSString *)searchText scope:(GallerySearchScope)scope completion:(void (^)(BOOL, NSError *))completionBlock
{
    NSArray *tags = nil;
    NSString *keywords = nil;
    
    if (scope == GallerySearchScopeTag)
    {
        tags = [searchText componentsSeparatedByString:@" "];
    }
    else
    {
        keywords = searchText;
    }
    
    [self.searchService photosForLocation:location keywords:keywords tags:tags success:^(NSArray<Photo *> *photos) {
        
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

- (NSArray<NSString *> *)availableTags
{
    return [self.photos valueForKeyPath:@"@distinctUnionOfArrays.tags"];
}

- (void)filterByTags:(NSArray<NSString *> *)tags completion:(void (^)())completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableSet *filterTags = [NSMutableSet setWithArray:tags];
        
        [self.photos filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Photo *photo, NSDictionary<NSString *,id> * _Nullable bindings) {
            
            return [filterTags intersectsSet:[NSSet setWithArray:photo.tags]];
            
        }]];
        
        if (completionBlock)
        {
            completionBlock();
        }
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfPhotos];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCell cellIdentifier] forIndexPath:indexPath];
    
    Photo *photo = [self photoAtIndex:indexPath.row];
    cell.photo = photo;
    
    return cell;
}

@end
