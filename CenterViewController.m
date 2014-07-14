//
//  CenterViewController.m
//  Hamburger
//
//  Created by Stephani Alves on 7/12/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "CenterViewController.h"
#import "MenuCell.h"
#import "TweetCell.h"
#import "TwitterClient.h"

#define TAG_PROFILE 0
#define TAG_TIMELINE 1
#define TAG_MENTIONS 2
#define TAG_LOGOUT 3

@interface CenterViewController ()
@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *userPhotoView;
@property (strong, nonatomic) IBOutlet UILabel *fullnameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *userPosterImageView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) NSMutableArray *currentResult;

- (IBAction)btnMovePanelRight:(id)sender;

@end

@implementation CenterViewController

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
    self.tweets = @[@"tweet1",@"tweet2", @"tweet3"];
    self.currentResult = [[NSMutableArray alloc] init];
    self.currentResult = self.responseObject;
    self.fullnameLabel.text = @"";
    //NSLog(@"response object: %@", self.responseObject);
    
    //load timeline cell on first load
    //registration process
    
    
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    //set row height
    self.tableView.rowHeight = 120;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnMovePanelRight:(id)sender {
    [self moveMenu:sender];
}


-(void) loaded:(int)tag {
    TwitterClient *client = [TwitterClient instance];
    switch (tag) {
        case TAG_PROFILE: {
            [self setTableProfile: client];
            self.viewLabel.text = @""; //will load photo
            break;
        }
        
        case TAG_TIMELINE: {
            [self setTableTimeline: client];
            self.viewLabel.text = @"Home Timeline";
            break;
        }
        
        case TAG_MENTIONS: {
            [self setTableMentions: client];
            self.viewLabel.text = @"Mentions Timeline";
            break;
        }
            
        case TAG_LOGOUT: {
            break;
        }
            
        default:
            break;
    }
    [_delegate movePanelToOriginalPosition];
}

-(void)moveMenu: (id)sender{
    UIButton *button = sender;
    NSLog(@"btnMovePanelRight called button tag %d", button.tag);
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}


//table view
//number of rows
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows you want in this table view
    return [self.currentResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    //NSLog(@"table view indexpath.row = %d", indexPath.row);
//    MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
//    cell.menuLabel.text = [self.currentResult objectAtIndex:indexPath.row];
//    
//    return cell;
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    NSDictionary *tweet = [self.currentResult objectAtIndex:indexPath.row];
    //[self.favorites insertObject:tweet[@"favorited"] atIndex:indexPath.row];
    
    //NSLog(@"tweet: %@", tweet[@"favorited"]);
    //check to see if tweet has been retweeted
    if ([@"0" isEqualToString:tweet[@"retweeted"]]) {
        //show retweeted label
        cell.retweetLabel.text =@"somebody retweeted this";
    }else{
        //don't show retweeted label
        cell.retweetLabel.text = @"";
    }
    
    cell.name_label.text = tweet[@"user"][@"name"];
    NSMutableString *screen_name = [[NSMutableString alloc]init];
    [screen_name appendString:@"@"];
    [screen_name appendString:tweet[@"user"][@"screen_name"]];
    
    cell.screen_name_label.text = screen_name;
    NSString *profile_image_url = tweet[@"user"][@"profile_image_url"];
    [cell.profile_image_view setImageWithURL: [NSURL URLWithString:profile_image_url]];
    CALayer * l = [cell.profile_image_view layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    cell.text_label.text = tweet[@"text"];
    
    cell.timestamp_label.text = [self retrivePostTime:tweet[@"created_at"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row pressed %d", indexPath.row);
    
}

-(NSString*)retrivePostTime:(NSString*)postDate{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *userPostDate = [df dateFromString:postDate];
    
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:userPostDate];
    
    NSTimeInterval theTimeInterval = distanceBetweenDates;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSString *returnDate;
    if ([conversionInfo month] > 0) {
        returnDate = [NSString stringWithFormat:@"%ldmth ago",(long)[conversionInfo month]];
    }else if ([conversionInfo day] > 0){
        returnDate = [NSString stringWithFormat:@"%ldd ago",(long)[conversionInfo day]];
    }else if ([conversionInfo hour]>0){
        returnDate = [NSString stringWithFormat:@"%ldh ago",(long)[conversionInfo hour]];
    }else if ([conversionInfo minute]>0){
        returnDate = [NSString stringWithFormat:@"%ldm ago",(long)[conversionInfo minute]];
    }else{
        returnDate = [NSString stringWithFormat:@"%lds ago",(long)[conversionInfo second]];
    }
    return returnDate;
}

-(void)setTableMentions:(TwitterClient *) client{
    [client mentionsTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"loaded mentions timeline with success");
        self.currentResult = responseObject;
        [self clearUser];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"mentions timeline response error");
    }];

}

-(void)setTableTimeline:(TwitterClient *) client{
    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"loaded home timeline with success");
        self.currentResult = responseObject;
        [self clearUser];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"homeTimeline response error");
    }];
    
}

-(void)setTableProfile:(TwitterClient *) client{
    [client userTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"loaded user timeline with success");
        
        self.currentResult = responseObject;
        [self loadUser];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"user timeline response error");
    }];
    
}

- (void)loadUser {
    TwitterClient *client = [TwitterClient instance];

    User *currentUser = [User currentUser];
    
    [client getUserWithID:currentUser.screen_name success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *user = [responseObject objectAtIndex:0];
        self.fullnameLabel.text = user[@"name"];
        
        NSString *profile_image_url = user[@"profile_image_url"];
        [self.userPhotoView setImageWithURL: [NSURL URLWithString:profile_image_url]];

        NSString *background_image_url = user[@"profile_background_image_url"];
        [self.userPosterImageView setImageWithURL:[NSURL URLWithString:background_image_url]];
        
        // Get the Layer of any view
        CALayer * l = [self.userPhotoView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];
    
}

- (void)clearUser {
    self.fullnameLabel.text =@"";
    self.userPhotoView.image = nil;
    self.userPosterImageView.image = nil;
}


@end
