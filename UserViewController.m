//
//  UserViewController.m
//  Hamburger
//
//  Created by Stephani Alves on 7/14/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "UserViewController.h"
#import "TwitterClient.h"

@interface UserViewController ()
@property (strong, nonatomic) IBOutlet UILabel *screennameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *posterImage;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoView;
- (IBAction)onBackButton:(id)sender;
@property (strong, nonatomic) NSDictionary *user;
@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    TwitterClient *client = [TwitterClient instance];
    NSString *userID =self.currentTweet[@"user"][@"screen_name"];
    [client getUserWithID: userID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //set user
        self.user = [responseObject objectAtIndex:0];
    
        self.fullnameLabel.text = self.user[@"name"];
        self.screennameLabel.text = self.user[@"screen_name"];
        
        NSMutableString *screen_name = [[NSMutableString alloc]init];
        [screen_name appendString:@"@"];
        [screen_name appendString:self.user[@"screen_name"]];
        self.screennameLabel.text = screen_name;
        
        NSString *profile_image_url = self.user[@"profile_image_url"];
        [self.userPhotoView setImageWithURL: [NSURL URLWithString:profile_image_url]];
        
        NSString *background_image_url = self.user[@"profile_banner_url"];
        [self.posterImage setImageWithURL:[NSURL URLWithString:background_image_url]];
        
        // Get the Layer of any view
        CALayer * l = [self.userPhotoView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail %@", error.description );
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
