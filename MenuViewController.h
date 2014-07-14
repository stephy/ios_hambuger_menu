//
//  MenuViewController.h
//  Hamburger
//
//  Created by Stephani Alves on 7/12/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>

@required
- (void)loaded:(int)tag;

@end

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id<MenuViewControllerDelegate> delegate;

@end
