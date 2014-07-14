//
//  User.m
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "User.h"
#import <Foundation/NSJSONSerialization.h>

@implementation User

static User *currentUser = nil;

+ (User *)currentUser{
    if (currentUser == nil){
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSData *data = [def objectForKey:@"current_user"];
        NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
        if (retrievedDictionary) {
            currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return currentUser;
}

- (void)setCurrentUser:(id)response{
    currentUser = [[User alloc] initWithDictionary:response];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary:response];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSKeyedArchiver archivedDataWithRootObject:dictionary] forKey:@"current_user"];
    [def synchronize];
}

- (id)initWithDictionary: (NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.screen_name = dictionary[@"screen_name"];
        self.language = dictionary[@"language"];
    }
    
    
    return self;
}


@end
