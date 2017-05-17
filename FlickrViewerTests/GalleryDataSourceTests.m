//
//  GalleryDataSourceTests.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 17/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GalleryDataSource.h"
#import "Photo.h"

@interface GalleryDataSource (Testing)

@property (nonatomic, strong) NSMutableArray<Photo *> *photos;

@end

@interface GalleryDataSourceTests : XCTestCase

@end

@implementation GalleryDataSourceTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFilteringByOneTagReturnsOnlyPhotosWithThatTag
{
    Photo *photo1 = [[Photo alloc] init];
    photo1.tags = @[@"beach", @"sunset", @"water"];
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.tags = @[@"beach", @"water"];
    
    GalleryDataSource *dataSource = [[GalleryDataSource alloc] init];
    dataSource.photos = [NSMutableArray arrayWithArray:@[photo1, photo2]];
    
    XCTAssertTrue([dataSource numberOfPhotos] == 2);
    
    [dataSource filterByTags:@[@"sunset"] completion:^{
        
        XCTAssertTrue([dataSource numberOfPhotos] == 1);
    }];
}

- (void)testFilteringByOneTagReturnsAllPhotosWithThatTag
{
    Photo *photo1 = [[Photo alloc] init];
    photo1.tags = @[@"beach", @"sunset", @"water"];
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.tags = @[@"sunset", @"clouds"];
    
    GalleryDataSource *dataSource = [[GalleryDataSource alloc] init];
    dataSource.photos = [NSMutableArray arrayWithArray:@[photo1, photo2]];
    
    XCTAssertTrue([dataSource numberOfPhotos] == 2);
    
    [dataSource filterByTags:@[@"sunset"] completion:^{
        
        XCTAssertTrue([dataSource numberOfPhotos] == 2);
    }];
}

- (void)testFilteringByATagNotExistingInPhotosReturnsNoPhotos
{
    Photo *photo1 = [[Photo alloc] init];
    photo1.tags = @[@"beach", @"sunset", @"water"];
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.tags = @[@"beach", @"water"];
    
    GalleryDataSource *dataSource = [[GalleryDataSource alloc] init];
    dataSource.photos = [NSMutableArray arrayWithArray:@[photo1, photo2]];
    
    XCTAssertTrue([dataSource numberOfPhotos] == 2);
    
    [dataSource filterByTags:@[@"snow"] completion:^{
        
        XCTAssertTrue([dataSource numberOfPhotos] == 0);
    }];
}

- (void)testFilteringByMultipleTagsReturnsPhotosWithAnyOfThoseTags
{
    Photo *photo1 = [[Photo alloc] init];
    photo1.tags = @[@"beach", @"sunset", @"water", @"warm"];
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.tags = @[@"snow", @"wind", @"cold"];
    
    GalleryDataSource *dataSource = [[GalleryDataSource alloc] init];
    dataSource.photos = [NSMutableArray arrayWithArray:@[photo1, photo2]];
    
    XCTAssertTrue([dataSource numberOfPhotos] == 2);
    
    [dataSource filterByTags:@[@"cold", @"warm"] completion:^{
        
        XCTAssertTrue([dataSource numberOfPhotos] == 2);
    }];
}

- (void)testFilteringByMultipleTagsReturnsOnlyPhotosWithAnyOfThoseTags
{
    Photo *photo1 = [[Photo alloc] init];
    photo1.tags = @[@"beach", @"sunset", @"water", @"warm"];
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.tags = @[@"snow", @"wind", @"cold"];
    
    Photo *photo3 = [[Photo alloc] init];
    photo3.tags = @[@"snow", @"blue", @"ice"];
    
    Photo *photo4 = [[Photo alloc] init];
    photo4.tags = @[@"city", @"shopping", @"coffee"];
    
    GalleryDataSource *dataSource = [[GalleryDataSource alloc] init];
    dataSource.photos = [NSMutableArray arrayWithArray:@[photo1, photo2, photo3, photo4]];
    
    XCTAssertTrue([dataSource numberOfPhotos] == 4);
    
    [dataSource filterByTags:@[@"snow", @"water"] completion:^{
        
        XCTAssertTrue([dataSource numberOfPhotos] == 3);
    }];
}

- (void)testFilteringIgnoresPhotosWithoutTags
{
    GalleryDataSource *dataSource = [[GalleryDataSource alloc] init];
    dataSource.photos = [NSMutableArray arrayWithArray:@[[Photo new], [Photo new], [Photo new]]];
    
    XCTAssertTrue([dataSource numberOfPhotos] == 3);
    
    [dataSource filterByTags:@[@"snow"] completion:^{
        
        XCTAssertTrue([dataSource numberOfPhotos] == 0);
    }];
}

- (void)testFilteringIgnoresOnlyThePhotosWithoutTags
{
    Photo *photo1 = [[Photo alloc] init];
    photo1.tags = @[@"snow", @"mountains", @"cold"];
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.tags = @[@"summer", @"beach", @"hot"];
    
    GalleryDataSource *dataSource = [[GalleryDataSource alloc] init];
    dataSource.photos = [NSMutableArray arrayWithArray:@[photo1, [Photo new], photo2]];
    
    XCTAssertTrue([dataSource numberOfPhotos] == 3);
    
    [dataSource filterByTags:@[@"snow"] completion:^{
        
        XCTAssertTrue([dataSource numberOfPhotos] == 1);
    }];
}

@end
