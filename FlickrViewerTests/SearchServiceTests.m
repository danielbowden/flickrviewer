//
//  SearchServiceTests.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 13/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SearchService.h"

@interface SearchService (Testing)

- (NSURL *)searchEndpointURLForLocation:(CLLocation *)location searchTerm:(NSString *)searchTerm;

@end


@interface SearchServiceTests : XCTestCase

@end

@implementation SearchServiceTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testURLContainsBaseParameters
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil searchTerm:nil];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"content_type" value:@"1"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"safe_search" value:@"1"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"extras" value:@"date_upload,views,o_dims,geo"]]);
}

- (void)testURLSkipsNilSearchParameters
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil searchTerm:nil];
    
    XCTAssertFalse([testURL.absoluteString containsString:@"lat="]);
    XCTAssertFalse([testURL.absoluteString containsString:@"lon="]);
    XCTAssertFalse([testURL.absoluteString containsString:@"text="]);
}

- (void)testURLContainsGeoLocationParametersWhenProvidedLocation
{
    SearchService *service = [[SearchService alloc] init];
    CLLocationCoordinate2D sydney = CLLocationCoordinate2DMake(-33.8634, 151.211);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:sydney.latitude longitude:sydney.longitude];
    
    NSURL *testURL = [service searchEndpointURLForLocation:location searchTerm:nil];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"lat" value:@"-33.8634"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"lon" value:@"151.211"]]);
}

- (void)testURLContainsSearchTerm
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil searchTerm:@"beach"];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"text" value:@"beach"]]);
}

@end
