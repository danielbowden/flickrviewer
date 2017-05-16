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
                                   @"views":@824,
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
    XCTAssertEqual(photo.views, @824);
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

- (void)testDisplayDateReturnsDateStringInExpectedFormat
{
    Photo *photo = [[Photo alloc] init];
    photo.date = [NSDate dateWithTimeIntervalSince1970:1494924736];
    
    NSString *result = [photo displayDate];
    
    XCTAssertTrue([result isEqualToString:@"UPLOADED: MAY 16, 2017"]);
}

- (void)testDisplayDateReturnsFallbackStringForNilDate
{
    Photo *photo = [[Photo alloc] init];
    
    NSString *result = [photo displayDate];
    
    XCTAssertTrue([result isEqualToString:@"UPLOADED: UNKNOWN"]);
}

- (void)testDisplayViewsUsesSingularForViewsEqualToOne
{
    Photo *photo = [[Photo alloc] init];
    photo.views = @1;
    
    NSString *result = [photo displayViews];
    
    XCTAssertTrue([result isEqualToString:@"1 VIEW"]);
}

- (void)testDisplayViewsUsesPluralForViewsNotEqualToOne
{
    Photo *photo1 = [[Photo alloc] init];
    photo1.views = @0;
    
    Photo *photo2 = [[Photo alloc] init];
    photo2.views = @2;
    
    NSString *result1 = [photo1 displayViews];
    NSString *result2 = [photo2 displayViews];
    
    XCTAssertTrue([result1 isEqualToString:@"0 VIEWS"]);
    XCTAssertTrue([result2 isEqualToString:@"2 VIEWS"]);
}

- (void)testDisplayDimensionsReturnsUnknownForMissingSize
{
    Photo *photo = [[Photo alloc] init];
    
    NSString *result = [photo displayDimensions];
    
    XCTAssertTrue([result isEqualToString:@"ORIGINAL: UNKNOWN"]);
}

- (void)testDisplayDimensionsReturnsUnknownForInvalidSize
{
    Photo *photo = [[Photo alloc] init];
    photo.originalDimensions = CGSizeZero;
    
    NSString *result = [photo displayDimensions];
    
    XCTAssertTrue([result isEqualToString:@"ORIGINAL: UNKNOWN"]);
}

- (void)testDisplayDimensionsReturnsOriginalSizeString
{
    Photo *photo = [[Photo alloc] init];
    photo.originalDimensions = CGSizeMake(1000.0, 1600.0);
    
    NSString *result = [photo displayDimensions];
    
    XCTAssertTrue([result isEqualToString:@"ORIGINAL: 1000x1600"]);
}

@end
