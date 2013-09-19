//
//  TWViewController.m
//  TOWClient
//
//  Created by John Doran on 19/09/2013.
//  Copyright (c) 2013 TW. All rights reserved.
//

#import "TWViewController.h"
#import "TWGameStatusView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TWViewController{
  float _pullOffset;
  MCSession *_session;
  MCNearbyServiceAdvertiser *_adviser;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configureNetwork];
  [self configureScrollView];
  
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(submitToController) userInfo:nil repeats:YES];
}

- (void)configureNetwork{
  MCPeerID *peerId = [[MCPeerID alloc]initWithDisplayName:@"johnwildoran@gmail.com"];
  
  _session = [[MCSession alloc]initWithPeer:peerId securityIdentity:@[] encryptionPreference:MCEncryptionNone];
  _session.delegate = self;
  
  _adviser = [[MCNearbyServiceAdvertiser alloc]initWithPeer:peerId discoveryInfo:@{} serviceType:@"ropegame"];
  _adviser.delegate = self;
  [_adviser startAdvertisingPeer];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  [self performSelector:@selector(test) withObject:nil afterDelay:2];
}

- (void)test{
  [self.gameStatusView setupNewGameWithPlayerInTeamA:YES];
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


// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData*)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
  
  
  [_session nearbyConnectionDataForPeer:peerID withCompletionHandler:^(NSData *connectionData, NSError *error) {
    [_session connectPeer:peerID withNearbyConnectionData:connectionData];
  }];
  
  invitationHandler(YES, _session);

}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
  NSLog(@"session");
}

- (void)session:(MCSession *)session didReceiveResourceAtURL:(NSURL *)resourceURL fromPeer:(MCPeerID *)peerID
{
  NSLog(@"session");
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream*)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
  NSLog(@"session");
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
  NSLog(@"REVIEVED FORM REMOTE SESSION %@", [NSString stringWithUTF8String:data.bytes]);
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
  [_pullScrollView.layer setContents:(id)[UIImage imageNamed:@"GrassBG.png"].CGImage];
  UIImageView *ropeImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"RopeTile.png"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
  [ropeImageView setFrame:CGRectMake(44, 0, 233, 4000)];
  [_pullScrollView addSubview:ropeImageView];
}

@end
