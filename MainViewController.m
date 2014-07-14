//
//  MainViewController.m
//  Hamburger
//
//  Created by Stephani Alves on 7/12/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MainViewController.h"
#import "CenterViewController.h"
#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>


#define CENTER_TAG 1
#define TIMELINE_TAG 2
#define MENTIONS_TAG 3
#define MENU_PANEL_TAG 4
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () <MenuViewControllerDelegate, CenterViewControllerDelegate>

@property (nonatomic, strong) MenuViewController *menuVC;
@property (nonatomic, assign) BOOL showingMenuPanel;
@property (nonatomic, strong) CenterViewController *centerViewController;

@end

@implementation MainViewController

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
    [self setupViewWithResponseObject:self.responseObject];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Delegate Actions

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getMenuView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _centerViewController.menuButton.tag = 0;
                         }
                     }];
    
}

- (void)resetMainView
{
    // remove left view and reset variables, if needed
    if (_menuVC != nil)
    {
        [self.menuVC.view removeFromSuperview];
        self.menuVC = nil;
        
        _centerViewController.menuButton.tag = 1;
        self.showingMenuPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
    
}


- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
}


#pragma mark -
#pragma mark Setup View

- (void)setupViewWithResponseObject:(id)responseObject{
    // setup center view
    self.centerViewController = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    self.centerViewController.responseObject = responseObject;
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    
    
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    
    [_centerViewController didMoveToParentViewController:self];

}

- (UIView *)getMenuView{
    NSLog(@"getMenuView callled");
    if (_menuVC == nil) {
        self.menuVC = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        self.menuVC.view.tag = MENU_PANEL_TAG;
        self.menuVC.delegate = _centerViewController;
        
        [self.view addSubview:self.menuVC.view];
        
        [self addChildViewController:_menuVC];
        [_menuVC didMoveToParentViewController:self];
        
        _menuVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingMenuPanel = YES;
    
    //add view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    UIView *view = self.menuVC.view;
    return view;
}


- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset{
    
    if (value){
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setShadowOpacity:0.8];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }else{
        [_centerViewController.view.layer setCornerRadius:0.0f];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}




@end
