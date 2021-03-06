//
//  SearchService.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 13/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "SearchService.h"

#import "Photo.h"
#import "FlickrAPI.h"

@interface SearchService ()

@property (nonatomic, strong) FlickrAPI *flickrAPI;

- (NSURL *)searchEndpointURLForLocation:(CLLocation *)location keywords:(NSString *)keywords tags:(NSArray <NSString *> *)tags;

@end

@implementation SearchService

- (instancetype)init
{
    if ((self = [super init]))
    {
        NSDictionary *config = [[NSBundle mainBundle] infoDictionary];
        _flickrAPI = [[FlickrAPI alloc] initWithBaseURL:[NSURL URLWithString:config[@"kFlickrBaseURL"]] apiKey:config[@"kFlickrAPIKey"]];
    }
    
    return self;
}

- (void)photosForLocation:(CLLocation *)location success:(void (^)(NSArray<Photo *> *))success failure:(void (^)(NSError *))failure
{
    [self photosForLocation:location keywords:nil tags:nil success:success failure:failure];
}

- (void)photosForLocation:(CLLocation *)location keywords:(NSString *)keywords tags:(NSArray<NSString *> *)tags success:(void (^)(NSArray<Photo *> *))success failure:(void (^)(NSError *))failure
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [self searchEndpointURLForLocation:location keywords:keywords tags:tags];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            if (failure)
            {
                failure(error);
            }
        }
        else
        {
            NSError *parseError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            
            if (parseError)
            {
                if (failure)
                {
                    failure(parseError);
                }
            }
            else
            {
                NSMutableArray *photos = [NSMutableArray array];
                
                for (NSDictionary *data in json[@"photos"][@"photo"])
                {
                    Photo *photo = [[Photo alloc] initWithJSON:data];
                    [photos addObject:photo];
                }
                
                if (success)
                {
                    success([photos copy]);
                }
            }
        }
    }];
    
    [task resume];
}

#pragma mark - Private

- (NSURL *)searchEndpointURLForLocation:(CLLocation *)location keywords:(NSString *)keywords tags:(NSArray<NSString *> *)tags
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"content_type":@"1",
                                                                                  @"safe_search":@"1",
                                                                                  @"extras":@"date_upload,views,o_dims,geo,owner_name,tags"
                                                                                  }];
    
    if (location && CLLocationCoordinate2DIsValid(location.coordinate))
    {
        params[@"lat"] = @(location.coordinate.latitude).stringValue;
        params[@"lon"] = @(location.coordinate.longitude).stringValue;
    }
    
    if (keywords && keywords.length)
    {
        params[@"text"] = keywords;
    }
    
    if (tags && tags.count)
    {
        params[@"tags"] = [tags componentsJoinedByString:@","];
        params[@"tag_mode"] = @"all";
    }
    
    return [self.flickrAPI URLForAPIMethod:@"flickr.photos.search" parameters:params];
}

@end
