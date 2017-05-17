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

- (NSURL *)searchEndpointURLForLocation:(CLLocation *)location keywords:(NSString *)keywords tags:(NSArray<NSString *> *)tags;

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
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil keywords:nil tags:nil];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"content_type" value:@"1"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"safe_search" value:@"1"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"extras" value:@"date_upload,views,o_dims,geo,owner_name"]]);
}

- (void)testURLSkipsNilKeywordSearchParameters
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil keywords:nil tags:nil];
    
    XCTAssertFalse([testURL.absoluteString containsString:@"lat="]);
    XCTAssertFalse([testURL.absoluteString containsString:@"lon="]);
    XCTAssertFalse([testURL.absoluteString containsString:@"text="]);
}

- (void)testURLContainsGeoLocationParametersWhenProvidedLocation
{
    SearchService *service = [[SearchService alloc] init];
    CLLocationCoordinate2D sydney = CLLocationCoordinate2DMake(-33.8634, 151.211);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:sydney.latitude longitude:sydney.longitude];
    
    NSURL *testURL = [service searchEndpointURLForLocation:location keywords:nil tags:nil];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"lat" value:@"-33.8634"]]);
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"lon" value:@"151.211"]]);
}

- (void)testURLContainsKeywordSearchTerm
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil keywords:@"beach" tags:nil];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"text" value:@"beach"]]);
}

- (void)testURLContainsCommaSeparatedTagSearchWhenMultipleTagsPassed
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil keywords:nil tags:@[@"city", @"sunset", @"buildings"]];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"tags" value:@"city,sunset,buildings"]]);
}

- (void)testURLHandlesSingleTagSearch
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil keywords:nil tags:@[@"city"]];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"tags" value:@"city"]]);
}

- (void)testURLHandlesExclusionTags
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil keywords:nil tags:@[@"car", @"ferrari", @"-red"]];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"tags" value:@"car,ferrari,-red"]]);
}

- (void)testURLContainsTagModeAllForTagSearch
{
    SearchService *service = [[SearchService alloc] init];
    
    NSURL *testURL = [service searchEndpointURLForLocation:nil keywords:nil tags:@[@"city", @"sunset", @"buildings"]];
    NSURLComponents *components = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"tag_mode" value:@"all"]]);
}

@end
