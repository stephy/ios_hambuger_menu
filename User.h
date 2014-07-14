//
//  User.h
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *screen_name;
@property (strong, nonatomic) NSString *language;

+ (User *)currentUser;
- (void)setCurrentUser:(id)responseObject;
- (id)initWithDictionary: (NSDictionary *)dictionary;


@end
