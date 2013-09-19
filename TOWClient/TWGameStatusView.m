//
//  GameStatusView.m
//  pullTheRope
//
//  Created by Ignacio Delgado on 19/09/2013.
//  Copyright (c) 2013 MTT. All rights reserved.
//

#import "TWGameStatusView.h"
#import <QuartzCore/QuartzCore.h>

@interface TWGameStatusView()
@property (nonatomic, strong) UIView *rope;
@property (nonatomic, strong) UIView *marker;
@property (nonatomic, strong) UILabel *teamA;
@property (nonatomic, strong) UILabel *teamB;

@property (nonatomic) CGFloat result;
@end

@implementation TWGameStatusView

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
    if (self) {
      [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
      [self createRope];
      [self createTeamA];
      [self createTeamB];
      [self createMarker];
      
      self.result = 0.5;
    }
    return self;
}

- (void)layoutSubviews{
  [super layoutSubviews];
  
  [self.teamA setFrame:CGRectMake(5, (self.frame.size.height - self.teamA.frame.size.height)/2, self.teamA.frame.size.width, self.teamA.frame.size.height)];
  [self.rope setFrame:CGRectMake(10 + self.teamA.frame.size.width, (self.frame.size.height - 10)/2, self.frame.size.width - (20 + self.teamA.frame.size.width + self.teamB.frame.size.width), 10)];
  [self.teamB setFrame:CGRectMake(15 + self.teamA.frame.size.width + self.rope.frame.size.width, (self.frame.size.height - self.teamA.frame.size.height)/2, self.teamB.frame.size.width, self.teamB.frame.size.height)];
  [self.marker setFrame:CGRectMake(self.rope.frame.origin.x + self.result*self.rope.frame.size.width, (self.frame.size.height - 20)/2, 5, 20)];
}

#pragma mark - View Methods

- (void)createRope{
  self.rope = [self createViewWithColor:[UIColor whiteColor]];
  [self addSubview:self.rope];
}

- (UIView *)createViewWithColor:(UIColor *)color{
  UIView *view = [UIView new];
  [view setBackgroundColor:color];
  [view.layer setBorderWidth:1.0];
  [view.layer setBorderColor:[UIColor blackColor].CGColor];
  return view;
}

- (void)createTeamA{
  self.teamA = [self createLabelWithText:@"A" color:[UIColor blueColor]];
  [self addSubview:self.teamA];
}

- (void)createTeamB{
  self.teamB = [self createLabelWithText:@"B" color:[UIColor redColor]];
  [self addSubview:self.teamB];
}

- (UILabel *)createLabelWithText:(NSString *)text color:(UIColor *)color{
  UILabel *label = [UILabel new];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[UIFont systemFontOfSize:40]];
  [label setTextColor:color];
  [label setText:text];
  [label sizeToFit];
  
  return label;
}

- (void)createMarker{
  self.marker = [self createViewWithColor:[UIColor redColor]];
  [self addSubview:self.marker];
}

#pragma mark - Public Methods

- (void)updateResultOfGame:(CGFloat)result{
  NSAssert(result >= 0 && result <= 1, @"Result of the game must be value between 0 and 1");
  self.result = result;
  [UIView animateWithDuration:0.3 animations:^{
    [self.marker setFrame:CGRectMake(self.rope.frame.origin.x + self.result*self.rope.frame.size.width, (self.frame.size.height - 20)/2, 5, 20)];
  }];
}

@end
