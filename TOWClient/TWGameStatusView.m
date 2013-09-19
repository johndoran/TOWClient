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
@property (nonatomic, strong) UIImageView *rope;
@property (nonatomic, strong) UIImageView *marker;
@property (nonatomic, strong) UIImageView *player;
@property (nonatomic, strong) UILabel *teamA;
@property (nonatomic, strong) UILabel *teamB;

@property (nonatomic) CGFloat result;
@property (nonatomic) BOOL playerInTeamA;
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
      [self createPlayer];
      
      self.result = 0.5;
    }
    return self;
}

- (void)layoutSubviews{
  [super layoutSubviews];
  
  [self.teamA setFrame:CGRectMake(5, (self.frame.size.height - self.teamA.frame.size.height)/2, self.teamA.frame.size.width, self.teamA.frame.size.height)];
  [self.rope setFrame:CGRectMake(10 + self.teamA.frame.size.width, (self.frame.size.height - self.rope.frame.size.height)/2, self.frame.size.width - (20 + self.teamA.frame.size.width + self.teamB.frame.size.width), self.rope.frame.size.height)];
  [self.teamB setFrame:CGRectMake(15 + self.teamA.frame.size.width + self.rope.frame.size.width, (self.frame.size.height - self.teamA.frame.size.height)/2, self.teamB.frame.size.width, self.teamB.frame.size.height)];
  [self.marker setFrame:CGRectMake(self.rope.frame.origin.x + self.result*self.rope.frame.size.width, (self.frame.size.height - 20)/2, 5, 20)];
}

#pragma mark - View Methods

- (void)createPlayer{
  self.player = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playerIcon.png"]];
  [self addSubview:self.player];
  [self.player setAlpha:0.0];
}

- (void)createRope{
  self.rope = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progressRope.png"]];
  [self addSubview:self.rope];
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
  self.marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redFlag.png"]];
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

- (void)assignPlayerToTeam:(BOOL)playerInTeamA{
  self.playerInTeamA = playerInTeamA;
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.player setAlpha:0.0];
  } completion:^(BOOL finished){
    if (self.playerInTeamA){
      [self.player setFrame:CGRectMake(self.teamA.center.x - (self.player.frame.size.width)/2, self.teamA.frame.origin.y + self.teamA.frame.size.height + 5, self.player.frame.size.width, self.player.frame.size.height)];
    }else{
      [self.player setFrame:CGRectMake(self.teamB.center.x - (self.player.frame.size.width)/2, self.teamB.frame.origin.y + self.teamB.frame.size.height + 5, self.player.frame.size.width, self.player.frame.size.height)];
    }
    [UIView animateWithDuration:0.3 animations:^{
      [self.player setAlpha:1.0];
    }];
  }];
}

- (void)setupNewGameWithPlayerInTeamA:(BOOL)playerInTeamA{
  [self assignPlayerToTeam:playerInTeamA];
  [self updateResultOfGame:0.5];
}

@end
