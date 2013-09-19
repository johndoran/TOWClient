//
//  TWViewController.m
//  TOWClient
//
//  Created by John Doran on 19/09/2013.
//  Copyright (c) 2013 TW. All rights reserved.
//

#import "TWViewController.h"
#import "TWGameStatusView.h"
#import "TWCountDownView.h"
#import <QuartzCore/QuartzCore.h>


@implementation TWViewController{
  float _pullOffset;
  MCSession *_session;
  MCBrowserViewController *_browserViewController;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor clearColor]];

  [self configureScrollView];
  
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(submitToController) userInfo:nil repeats:YES];
 
  [self performSelector:@selector(configureNetworkAndGame) withObject:nil afterDelay:1.5];
}

-(void)configureNetworkAndGame
{
  MCPeerID *peerId = [[MCPeerID alloc]initWithDisplayName:@"test"];
  
  _session = [[MCSession alloc]initWithPeer:peerId];
  _session.delegate = self;
  
  _browserViewController = [[MCBrowserViewController alloc]initWithServiceType:@"ropegame" session:_session];
  _browserViewController.delegate = self;
  
  [self presentViewController:_browserViewController animated:YES completion:nil];
}


- (void)test{
  [self.gameStatusView setupNewGameWithPlayerInTeamA:YES];
  [self.pullScrollView setUserInteractionEnabled:NO];
  
  [self performSelector:@selector(startNewGame) withObject:nil afterDelay:2];
}

- (void)startNewGame{
  TWCountDownView *countDownView = [[TWCountDownView alloc] initWithFrame:self.pullScrollView.frame];
  [self.view addSubview:countDownView];
  [self.view bringSubviewToFront:countDownView];
  
  [countDownView startCountDownAndExecuteWhenFinish:^{
    [countDownView removeFromSuperview];
    [self.pullScrollView setUserInteractionEnabled:YES];
  }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  _offsetValue.text = [NSString stringWithFormat:@"%f", _pullOffset + scrollView.contentOffset.y];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
  if (bottomEdge >= scrollView.contentSize.height) {
    _pullOffset += scrollView.contentOffset.y;
    _pullScrollView.contentOffset = CGPointMake(0, 0);
  }
}

- (void)submitToController
{
  NSLog(@"submitting offset %f", _pullOffset + _pullScrollView.contentOffset.y);
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
  NSLog(@"session");
}

- (void)session:(MCSession *)session didReceiveResourceAtURL:(NSURL *)resourceURL fromPeer:(MCPeerID *)peerID
{
  NSLog(@"session");
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream*)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
  NSLog(@"session");
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
  // 0 connected - should get the team
  // 1 startgame - trigger countdown
  // 2 playerprogress - 0 - 1
  // 3 user progress - scroll offset
  // 4 end game - end game
  
  // dict keys
  // operationID
  // value
  
  NSString *dataString = [NSString stringWithUTF8String:data.bytes];
  
  NSDictionary *sessionDict = [dataString propertyList];
  NSLog(@"%@", sessionDict);

  int operation = (int)[sessionDict objectForKey:@"operationID"];
  switch (operation) {
    case 0:
      [self displayTeamAfterConnection:[sessionDict objectForKey:@"value"]];
      break;
    case 1:
      [self startGame:[sessionDict objectForKey:@"value"]];
      break;
    case 2:
      [self updateUserProgress:[sessionDict objectForKey:@"value"]];
      break;
    case 4:
      [self endGame:[sessionDict objectForKey:@"value"]];
      break;
    default:
      break;
  }
  
}

#pragma mark - callback methods
-(void)displayTeamAfterConnection:(NSString*) value
{
  
}

-(void)startGame:(NSString*) value
{
  
}

-(void)updateUserProgress:(NSString*) value
{
  
}

-(void)endGame:(NSString*) value
{
  
}


#pragma mark - modal
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
  [_browserViewController dismissViewControllerAnimated:YES completion:nil];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
  [_browserViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
  [_session disconnect];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)configureScrollView{
  _pullScrollView.delegate = self;
  [_pullScrollView setContentSize:CGSizeMake(320, 4000)];
  _pullScrollView.contentOffset = CGPointMake(0, 0);
  _pullScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
  
  [_pullScrollView setTransform:CGAffineTransformMakeRotation(M_PI)];
  [_pullScrollView setBackgroundColor:[UIColor clearColor]];
  UIImageView *ropeImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"RopeTile.png"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
  [ropeImageView setFrame:CGRectMake(44, 0, 233, 4000)];
  [_pullScrollView addSubview:ropeImageView];
}

@end
