//
//  FlickrImageDownloaderTests.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 16/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UIImageView+FlickrImageDownloader.h"
#import "Photo.h"

@interface UIImageView (FlickrImageDownloaderTesting)

- (NSURL *)urlForPhoto:(Photo *)photo size:(ImageDownloadSize)size;

@end

@interface FlickrImageDownloaderTests : XCTestCase

@end

@implementation FlickrImageDownloaderTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testConstructedFlickrImageURLForThumbnailSize
{
    Photo *photo = [[Photo alloc] init];
    photo.ID = @"33882008633";
    photo.farm = @"5";
    photo.server = @"4167";
    photo.secret = @"83b366004c";
    
    NSURL *result = [[UIImageView new] urlForPhoto:photo size:ImageDownloadSizeThumbnail];
    
    XCTAssertTrue([result.absoluteString isEqualToString:@"https://farm5.staticflickr.com/4167/33882008633_83b366004c_m.jpg"]);
}

- (void)testConstructedFlickrImageURLForLargeSize
{
    Photo *photo = [[Photo alloc] init];
    photo.ID = @"33882008631";
    photo.farm = @"4";
    photo.server = @"4166";
    photo.secret = @"83b366004d";
    
    NSURL *result = [[UIImageView new] urlForPhoto:photo size:ImageDownloadSizeLarge];
    
    XCTAssertTrue([result.absoluteString isEqualToString:@"https://farm4.staticflickr.com/4166/33882008631_83b366004d_h.jpg"]);
}

@end
