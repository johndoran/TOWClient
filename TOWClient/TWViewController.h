//
//  TWViewController.h
//  TOWClient
//
//  Created by John Doran on 19/09/2013.
//  Copyright (c) 2013 TW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWGameStatusView;

@import MultipeerConnectivity;

@interface TWViewController : UIViewController<UIScrollViewDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet TWGameStatusView *gameStatusView;
@property (weak, nonatomic) IBOutlet UIScrollView *pullScrollView;
@property (weak, nonatomic) IBOutlet UILabel *offsetValue;

@end
