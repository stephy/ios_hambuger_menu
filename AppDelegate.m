//
//  AppDelegate.m
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
//#import "TweetsViewController.h"
#import "MainViewController.h"
#import "User.h"

//Implementing Categories
//convinient helper
@implementation NSURL (dictionaryFromQueryString)
-(NSDictionary *) dictionaryFromQueryString{
    
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if([User currentUser] == nil){
        //load login screen
        self.window.rootViewController = [[LoginViewController alloc] init];
    }else{
        //load timeline screen
        TwitterClient *client = [TwitterClient instance];
        [self loadTimeline:client];
    }
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Twitter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Twitter.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
//callback
//whenever your application comes in via an url request, it comes through this application delegate end point.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    
    if ([url.scheme isEqualToString:@"cptwitter"]){
        if ([url.host isEqualToString:@"oauth"]){
            NSDictionary *parameters = [url dictionaryFromQueryString];
            //extract parameters from query string
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]){
                TwitterClient *client = [TwitterClient instance];
                
                [client fetchAccessTokenWithPath:@"/oauth/access_token"
                                          method:@"POST"
                                    requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                         success:^(BDBOAuthToken *accessToken){
                                             NSLog(@"access token");
                                             //saving access token
                                             //putting access token into keychain
                                             [client.requestSerializer saveAccessToken:accessToken];
                                             
                                             //if no user has been saved
                                             if ([User currentUser] == nil){
                                                 //set current user
                                                 [client getUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     NSLog(@"saving user");
                                                     // NSLog(@"Setting user %@", responseObject);
                                                     //set current user
                                                     [[User alloc] setCurrentUser:responseObject];
                                                     
                                                     //load timeline
                                                     [self loadTimeline:client];
                                                     
                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     NSLog(@"error logging user %@", [error description]);
                                                 }];
                                             }else{
                                                 //load timeline
                                                 //NSLog(@"user already saved, loading timeline");
                                                 [self loadTimeline:client];
                                             }
                                             
                                             
                                             
                                             
                                         }
                                         failure:^(NSError *error){
                                             NSLog(@"access token error %@", [error description] );
                                         }];
            }
        }
        return YES;
    }
    return NO;
}

- (void)loadTimeline:(TwitterClient *)client{
    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"loaded timeline with success");
//        TweetsViewController *mvc = [[TweetsViewController alloc] init];
//        mvc.timeline = responseObject;
//        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mvc];
//        self.window.rootViewController = nvc;
        MainViewController *mvc = [[MainViewController alloc] init];
        mvc.responseObject = responseObject;
        //mvc.timeline = responseObject;
        //UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mvc];
        self.window.rootViewController = mvc;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"homeTimeline response error %@", error.description);
//        TweetsViewController *mvc = [[TweetsViewController alloc] init];
//        mvc.timeline = nil;
//        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mvc];
//        self.window.rootViewController = nvc;
    }];
}

@end
