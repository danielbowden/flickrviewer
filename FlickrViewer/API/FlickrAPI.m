//
//  FlickrAPI.m
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import "FlickrAPI.h"

@implementation FlickrAPI

- (instancetype)initWithBaseURL:(NSURL *)url apiKey:(NSString *)apiKey
{
    if ((self = [super init]))
    {
        _baseURL = url;
        _apiKey = apiKey;
    }
    
    return self;
}

- (NSURL *)URLForAPIMethod:(NSString *)method parameters:(NSDictionary *)params
{
    NSParameterAssert(self.baseURL);
    NSParameterAssert(self.apiKey);
    NSParameterAssert(method);
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.baseURL resolvingAgainstBaseURL:NO];
    NSMutableArray *queryItems = [NSMutableArray array];
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"method" value:method]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"api_key" value:self.apiKey]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"format" value:@"json"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"]];
    
    if (params)
    {
        for (NSString *key in params)
        {
            if (params[key] && [params[key] isKindOfClass:[NSString class]])
            {
                NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:params[key]];
                [queryItems addObject:item];
            }
        }
    }
    
    components.queryItems = queryItems;
    
    return components.URL;
}

@end
