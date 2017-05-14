//
//  FlickrAPITests.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "FlickrAPI.h"

@interface FlickrAPITests : XCTestCase

@end

@implementation FlickrAPITests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testURLContainsExpectedBaseURLAndAPIKey
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com/api/path/"];
    NSString *apiKey = @"ABC123";
    
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:apiKey];
    
    NSURL *result = [api URLForAPIMethod:@"methodname" parameters:nil];
    NSURLComponents *components = [NSURLComponents componentsWithURL:result resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.scheme isEqualToString:@"https"]);
    XCTAssertTrue([components.host isEqualToString:@"apiurl.com"]);
    XCTAssertTrue([components.path isEqualToString:@"/api/path/"]);
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"api_key" value:apiKey]]);
}

- (void)testBasicParametersIncludedInAllURLs
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com/api/path/"];
    NSString *apiKey = @"ABC123";
    
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:apiKey];
    
    NSURL *result = [api URLForAPIMethod:@"methodname" parameters:nil];
    NSArray *queryItems = [NSURLComponents componentsWithURL:result resolvingAgainstBaseURL:NO].queryItems;
    
    XCTAssertEqual(queryItems.count, 4);
    XCTAssertTrue([queryItems containsObject:[NSURLQueryItem queryItemWithName:@"method" value:@"methodname"]]);
    XCTAssertTrue([queryItems containsObject:[NSURLQueryItem queryItemWithName:@"api_key" value:apiKey]]);
    XCTAssertTrue([queryItems containsObject:[NSURLQueryItem queryItemWithName:@"format" value:@"json"]]);
    XCTAssertTrue([queryItems containsObject:[NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"]]);
}

- (void)testCallingForURLWithoutSupplyingBaseURLThrowsException
{
    FlickrAPI *api = [[FlickrAPI alloc] init];
    
    XCTAssertThrows([api URLForAPIMethod:@"methodname" parameters:nil]);
}

- (void)testCallingForURLWithoutSupplyingAPIKeyThrowsException
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com"];
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:nil];
    
    XCTAssertThrows([api URLForAPIMethod:@"methodname" parameters:nil]);
}

- (void)testCallingForURLWithoutSupplyingAPIMethodThrowsException
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com"];
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:@"ABC123"];
    
    XCTAssertThrows([api URLForAPIMethod:nil parameters:nil]);
}

- (void)testURLContainsAPIMethod
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com"];
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:@"ABC123"];
    
    NSURL *result = [api URLForAPIMethod:@"mymethod" parameters:nil];
    NSURLComponents *components = [NSURLComponents componentsWithURL:result resolvingAgainstBaseURL:NO];
    
    XCTAssertTrue([components.queryItems containsObject:[NSURLQueryItem queryItemWithName:@"method" value:@"mymethod"]]);
}

- (void)testURLReturnedEscapedForUnescapedValue
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com"];
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:@"ABC123"];
    
    NSURL *result =  [api URLForAPIMethod:@"mymethod" parameters:@{@"name":@"spaces other #stuff"}];
    
    XCTAssertTrue([result.absoluteString containsString:@"name=spaces%20other%20%23stuff"]);
}

- (void)testIgnoresNonStringParameterValue
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com"];
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:@"ABC123"];
    
    NSURL *result =  [api URLForAPIMethod:@"mymethod" parameters:@{@"number":@2}];
    
    XCTAssertFalse([result.absoluteString containsString:@"number="]);
}

- (void)testIgnoresOnlyNonStringParameters
{
    NSURL *baseURL = [NSURL URLWithString:@"https://apiurl.com"];
    FlickrAPI *api = [[FlickrAPI alloc] initWithBaseURL:baseURL apiKey:@"ABC123"];
    NSDictionary *params = @{
                             @"number":@2,
                             @"name":@"daniel",
                             @"devices":@[@"iphone",@"ipad"],
                             @"country":@"australia"
                             };
    
    NSURL *result =  [api URLForAPIMethod:@"mymethod" parameters:params];
    
    NSArray *queryItems = [NSURLComponents componentsWithURL:result resolvingAgainstBaseURL:NO].queryItems;
    
    XCTAssertTrue([queryItems containsObject:[NSURLQueryItem queryItemWithName:@"name" value:@"daniel"]]);
    XCTAssertTrue([queryItems containsObject:[NSURLQueryItem queryItemWithName:@"country" value:@"australia"]]);
    XCTAssertFalse([result.absoluteString containsString:@"number="]);
    XCTAssertFalse([result.absoluteString containsString:@"devices="]);
}

- (void)testBaseURLAndAPICredentialsIncludedInBuild
{
    NSDictionary *config = [[NSBundle mainBundle] infoDictionary];
    
    XCTAssertNotNil(config[@"kFlickrBaseURL"]);
    XCTAssertNotEqual([config[@"kFlickrBaseURL"] length], 0);
    XCTAssertNotNil(config[@"kFlickrAPIKey"]);
    XCTAssertNotEqual([config[@"kFlickrAPIKey"] length], 0);
}

@end
