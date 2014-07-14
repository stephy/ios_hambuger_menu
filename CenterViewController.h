//
//  CenterViewController.h
//  Hamburger
//
//  Created by Stephani Alves on 7/12/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "User.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface CenterViewController : UIViewController <MenuViewControllerDelegate>

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic, strong) id responseObject;
@end
