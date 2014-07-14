//
//  MenuViewController.m
//  Hamburger
//
//  Created by Stephani Alves on 7/12/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MenuViewController.h"
#import "CenterViewController.h"
#import "MenuCell.h"
#import "TwitterClient.h"
#import "User.h"

@interface MenuViewController ()
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userPosterView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuOptions;
@end

@implementation MenuViewController



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
    
    self.menuOptions = @[@"Profile",@"Timeline", @"Mentions", @"logout"];
    //show current user
    [self loadUser];
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    //set row height
    self.tableView.rowHeight = 46;
    
}

- (void)loadUser {
    TwitterClient *client = [TwitterClient instance];
    
    User *currentUser = [User currentUser];
    
    NSMutableString *screen_name = [[NSMutableString alloc]init];
    [screen_name appendString:@"@"];
    [screen_name appendString:currentUser.screen_name];
    
    self.screenNameLabel.text = screen_name;
    
    [client getUserWithID:currentUser.screen_name success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *user = [responseObject objectAtIndex:0];
        self.fullNameLabel.text = user[@"name"];
        
        NSString *profile_image_url = user[@"profile_image_url"];
        [self.userPosterView setImageWithURL: [NSURL URLWithString:profile_image_url]];
        
        // Get the Layer of any view
        CALayer * l = [self.userPosterView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//table view
//number of rows
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows you want in this table view
    return [self.menuOptions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    //NSLog(@"table view indexpath.row = %d", indexPath.row);
    MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.menuLabel.text = [self.menuOptions objectAtIndex:indexPath.row];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor =[UIColor colorWithRed:0.557 green:0.263 blue:0.984 alpha:1]; /*#8e43fb*/
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row pressed %d", indexPath.row);
    [_delegate loaded:indexPath.row];
    
}

@end
