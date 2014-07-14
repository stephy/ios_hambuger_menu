//
//  TweetCell.h
//  Twitter
//
//  Created by Stephani Alves on 6/29/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *screen_name_label;
@property (strong, nonatomic) IBOutlet UIImageView *profile_image_view;
@property (strong, nonatomic) IBOutlet UILabel *text_label;
@property (strong, nonatomic) IBOutlet UILabel *timestamp_label;
@property (strong, nonatomic) IBOutlet UILabel *retweetLabel;
- (IBAction)replyButton:(id)sender;
- (IBAction)retweetButton:(id)sender;
- (IBAction)favoriteButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@end
