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
  float previousOffset;
  MCSession *_session;
  MCBrowserViewController *_browserViewController;
  TWCountDownView *countDownView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view setBackgroundColor:[UIColor clearColor]];
  [self showEmailPromptWithString:@"What is your email bro?"];
  [self createCountDownView];
  [self configureScrollView];
}

-(void)configureNetworkAndGame:(NSString*)emailAddress;
{
  MCPeerID *peerId = [[MCPeerID alloc]initWithDisplayName:emailAddress];
  
  _session = [[MCSession alloc]initWithPeer:peerId];
  _session.delegate = self;
  
  _browserViewController = [[MCBrowserViewController alloc]initWithServiceType:@"ropegame" session:_session];
  _browserViewController.delegate = self;
  
  [self presentViewController:_browserViewController animated:YES completion:nil];
}

#pragma mark - scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  _offsetValue.text = [NSString stringWithFormat:@"%f", _pullOffset + scrollView.contentOffset.y];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
  if (bottomEdge >= scrollView.contentSize.height) {
    _pullOffset += scrollView.contentOffset.y;
    _pullScrollView.contentOffset = CGPointMake(0, 0);
  }
  
  _pullOffset += scrollView.contentOffset.y - previousOffset;
  previousOffset = scrollView.contentOffset.y;
}

- (void)submitToController
{
  if (_pullOffset > 0){
    [_session sendData:[NSKeyedArchiver archivedDataWithRootObject:@{@"operationid":@3 , @"value" : @(_pullOffset)}]
               toPeers:_session.connectedPeers
              withMode:MCSessionSendDataUnreliable
                 error:nil];
    
    _pullOffset = 0;
    previousOffset = 0;
    
    NSLog(@"submitting offset %f", _pullOffset + _pullScrollView.contentOffset.y);
  }
}

#pragma mark - session delegate
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
}

- (void)session:(MCSession *)session didReceiveResourceAtURL:(NSURL *)resourceURL fromPeer:(MCPeerID *)peerID
{
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream*)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
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
  
  dispatch_async(dispatch_get_main_queue(), ^{

    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSNumber *operation = (NSNumber*)[dict objectForKey:@"operationid"];
    switch (operation.intValue) {
      case 0:
        [_browserViewController dismissViewControllerAnimated:YES completion:nil];
        [self displayTeamAfterConnection:(NSNumber*)[dict objectForKey:@"value"]];
        break;
      case 1:
        [self startGame:[dict objectForKey:@"value"]];
        break;
      case 2:
        [self updateUserProgress:(NSNumber*)[dict objectForKey:@"value"]];
        break;
      case 4:
        [self endGame:(NSNumber*)[dict objectForKey:@"value"]];
        break;
      default:
        break;
    }

  });

}

#pragma mark - callback methods
-(void)displayTeamAfterConnection:(NSNumber*) value
{
  [self.gameStatusView setupNewGameWithPlayerInTeamA:value.intValue == 1 ? YES : NO];
}

-(void)startGame:(NSString*) value
{
  [countDownView setAlpha:1.0];
  [countDownView startCountDownAndExecuteWhenFinish:^{
    [countDownView setAlpha:0.0];
    [self.pullScrollView setUserInteractionEnabled:YES];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(submitToController) userInfo:nil repeats:YES];
  }];
}

-(void)updateUserProgress:(NSNumber*)value
{
  [self.gameStatusView updateResultOfGame:value.floatValue];
}

-(void)endGame:(NSNumber*)value
{
  [self.gameStatusView updateResultOfGame:value.intValue == 1 ? 0.0 : 1.0];
  
  [self.pullScrollView setUserInteractionEnabled:NO];
  [countDownView setAlpha:1.0];
  if((self.gameStatusView.playerInTeamA && value.intValue == 1) || (!self.gameStatusView.playerInTeamA && value.intValue == 2)){
    [countDownView finishedAndYouWon:YES];
  }else{
    [countDownView finishedAndYouWon:NO];
  }
}


#pragma mark - modal
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
  [_browserViewController dismissViewControllerAnimated:YES completion:nil];
}

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

#pragma mark email prompt
- (void)showEmailPromptWithString:(NSString*)message
{
  UIAlertView *emailInputView = [[UIAlertView alloc]initWithTitle:message message:@"" delegate:self  cancelButtonTitle:nil otherButtonTitles:@"Play", nil];
  emailInputView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [emailInputView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
  if([title isEqualToString:@"Play"])
  {
    UITextField *username = [alertView textFieldAtIndex:0];
    if([username.text isEqualToString:@""]){
      [self showEmailPromptWithString:@"Please not a blank one :("];
    }else{
      [self configureNetworkAndGame:username.text];
    }
  }
}

#pragma mark - Private Methods
- (void)createCountDownView{
  countDownView = [[TWCountDownView alloc] initWithFrame:self.pullScrollView.frame];
  [self.view addSubview:countDownView];
  [self.view bringSubviewToFront:countDownView];
  [countDownView setAlpha:0.0];
}

- (void)configureScrollView{
  _pullScrollView.delegate = self;
  [_pullScrollView setUserInteractionEnabled:NO];
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
