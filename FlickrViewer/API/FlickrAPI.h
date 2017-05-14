//
//  FlickrAPI.h
//  FlickrViewer
//
//  Created by Daniel Bowden on 14/5/17.
//  Copyright © 2017 Daniel Bowden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrAPI : NSObject

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, copy) NSString *apiKey;

- (instancetype)initWithBaseURL:(NSURL *)url apiKey:(NSString *)apiKey;
- (NSURL *)URLForAPIMethod:(NSString *)method parameters:(NSDictionary *)parameters;

@end
