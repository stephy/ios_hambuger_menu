//
//  TweetCell.m
//  Twitter
//
//  Created by Stephani Alves on 6/29/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)replyButton:(id)sender {
    NSLog(@"reply %@", sender);
}

- (IBAction)retweetButton:(id)sender {
    NSLog(@"retweet");
}

- (IBAction)favoriteButton:(id)sender{
    NSLog(@"favorite");
}

@end
