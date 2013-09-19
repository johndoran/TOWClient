//
//  TWViewController.m
//  TOWClient
//
//  Created by John Doran on 19/09/2013.
//  Copyright (c) 2013 TW. All rights reserved.
//

#import "TWViewController.h"
#import "TWGameStatusView.h"

@implementation TWViewController{
  float _pullOffset;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _pullScrollView.delegate = self;
  [_pullScrollView setContentSize:CGSizeMake(320, 4000)];
  _pullScrollView.contentOffset = CGPointMake(0, 0);
  [_pullScrollView setBackgroundColor:[UIColor redColor]];
  
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(submitToController) userInfo:nil repeats:YES];

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

@end
