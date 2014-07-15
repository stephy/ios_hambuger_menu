//
//  TweetViewController.m
//  Twitter
//
//  Created by Stephani Alves on 6/30/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()
@property (strong, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *icon_image;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation TweetViewController

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
    self.tweetTextLabel.text = self.currentTweet[@"text"];
    NSMutableString *screen_name = [[NSMutableString alloc]init];
    [screen_name appendString:@"@"];
    [screen_name appendString:self.currentTweet[@"user"][@"screen_name"]];
    self.screenNameLabel.text = screen_name;
    
    NSString *profile_image_url = self.currentTweet[@"user"][@"profile_image_url"];
    [self.icon_image setImageWithURL: [NSURL URLWithString:profile_image_url]];
    
    self.fullNameLabel.text =self.currentTweet[@"user"][@"name"];
    self.dateLabel.text = self.currentTweet[@"created_at"];
    
    //retweet count
    NSString *strFromInt = [NSString stringWithFormat:@"%@",self.currentTweet[@"retweet_count"]];
    self.retweetsCountLabel.text = strFromInt;
    
    
    //favorites count
    NSString *strFromInt2 = [NSString stringWithFormat:@"%@",self.currentTweet[@"user"][@"favourites_count"]];
    self.favoritesCountLabel.text = strFromInt2;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
