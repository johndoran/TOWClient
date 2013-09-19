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
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configureScrollView];
  
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(submitToController) userInfo:nil repeats:YES];
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

  NSLog(@"pull offset %f", _pullOffset + scrollView.contentOffset.y);
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
