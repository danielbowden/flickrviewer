//
//  PhotoTests.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Photo.h"

@interface PhotoTests : XCTestCase

@end

@implementation PhotoTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPhotoObjectSerializesFromExpectedAPIResponse
{
    NSDictionary *responseJSON = @{
                                   @"id":@"34642583775",
                                   @"farm":@"5",
                                   @"server":@"4162",
                                   @"secret":@"175b8ba0c6",
                                   @"title":@"Photo title",
                                   @"views":@"824",
                                   @"dateupload":@"1494729235",
                                   @"latitude":@"-33.918036",
                                   @"longitude":@"151.199807",
                                   @"o_width":@"1826",
                                   @"o_height":@"2435"
                                   };
    
    Photo *photo = [[Photo alloc] initWithJSON:responseJSON];
    
    XCTAssertEqual(photo.ID, @"34642583775");
    XCTAssertEqual(photo.farm, @"5");
    XCTAssertEqual(photo.server, @"4162");
    XCTAssertEqual(photo.secret, @"175b8ba0c6");
    XCTAssertEqual(photo.title, @"Photo title");
    XCTAssertTrue([photo.date compare:[NSDate dateWithTimeIntervalSince1970:1494729235]] == NSOrderedSame);
    XCTAssertTrue(CLLocationCoordinate2DIsValid(photo.location));
    XCTAssertTrue(CGSizeEqualToSize(photo.originalDimensions, CGSizeMake(1826, 2435)));
    XCTAssertEqual(photo.views, @"824");
}

- (void)testPhotoObjectSerializationHandlesMissingUploadDate
{
    NSDictionary *responseJSON = @{
                                   @"id":@"34642583775",
                                   @"farm":@"5",
                                   @"server":@"4162",
                                   @"secret":@"175b8ba0c6",
                                   @"title":@"Photo title"
                                   };
    
    Photo *photo = [[Photo alloc] initWithJSON:responseJSON];
    
    XCTAssertNil(photo.date);
}

- (void)testPhotoObjectReturnsSizeZeroForMissingOriginalDimensions
{
    NSDictionary *responseJSON = @{
                                   @"id":@"34642583775",
                                   @"farm":@"5",
                                   @"server":@"4162",
                                   @"secret":@"175b8ba0c6",
                                   @"title":@"Photo title"
                                   };
    
    Photo *photo = [[Photo alloc] initWithJSON:responseJSON];
    
    XCTAssertTrue(CGSizeEqualToSize(photo.originalDimensions, CGSizeZero));
}

- (void)testPhotoObjectReturnsSizeZeroForOneMissingOriginalDimension
{
    NSDictionary *responseJSON = @{
                                   @"id":@"34642583775",
                                   @"farm":@"5",
                                   @"server":@"4162",
                                   @"secret":@"175b8ba0c6",
                                   @"title":@"Photo title",
                                   @"o_width":@"1826"
                                   };
    
    Photo *photo = [[Photo alloc] initWithJSON:responseJSON];
    
    XCTAssertTrue(CGSizeEqualToSize(photo.originalDimensions, CGSizeZero));
}

- (void)testPhotoObjectSerializationHandlesMissingGeoLocation
{
    NSDictionary *responseJSON = @{
                                   @"id":@"34642583775",
                                   @"farm":@"5",
                                   @"server":@"4162",
                                   @"secret":@"175b8ba0c6",
                                   @"title":@"Photo title"
                                   };
    
    Photo *photo = [[Photo alloc] initWithJSON:responseJSON];
    
    XCTAssertFalse(CLLocationCoordinate2DIsValid(photo.location));
}

@end
