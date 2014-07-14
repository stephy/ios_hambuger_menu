//
//  TwitterClient.h
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

#pragma mark Initialization

+ (NSString*)encodeURL:(NSString *)string;
+ (TwitterClient *)instance;

- (void)login;
- (AFHTTPRequestOperation *)homeTimelineWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)mentionsTimelineWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)userTimelineWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)getUserWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)favoritesDestroyId: (NSString *)tweetId
                                       success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)favoritesCreateId: (NSString *)tweetId
                                      success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)tweetWithText: (NSString *)tweetText
                                  success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)getUserWithID: (NSString *)userID
                                  success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)retweetURL: (NSString *)tweetId
                               success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end