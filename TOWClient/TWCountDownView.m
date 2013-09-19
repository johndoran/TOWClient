//
//  TWCountDownView.m
//  TOWClient
//
//  Created by Ignacio Delgado on 19/09/2013.
//  Copyright (c) 2013 TW. All rights reserved.
//

#import "TWCountDownView.h"

@interface TWCountDownView()
typedef void (^onFinishBlock)();
@property (nonatomic, strong) UILabel *hugeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) onFinishBlock block;
@end

@implementation TWCountDownView{
  NSInteger countValue;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
      [self createHugeLabel];
    }

    return self;
}

- (void)layoutSubviews{
  [super layoutSubviews];
  
  [self.hugeLabel setFrame:self.bounds];
}

#pragma mark - Public Methods

- (void)startCountDownAndExecuteWhenFinish:(void (^)(void))onFinish{
  countValue = 3;
  [self.hugeLabel setFont:[UIFont systemFontOfSize:200]];
  [self.hugeLabel setText:[NSString stringWithFormat:@"%i",countValue]];
  self.block = onFinish;
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.hugeLabel setAlpha:1.0];
  } completion:^(BOOL finished){
    if (self.timer){
      [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
  }];
}

- (void)updateCounter{
  if (countValue > 1){
    countValue--;
    [self.hugeLabel setText:[NSString stringWithFormat:@"%i",countValue]];
  }else if (countValue == 1){
    countValue--;
      [self.hugeLabel setFont:[UIFont systemFontOfSize:120]];
    [self.hugeLabel setText:@"Pull!"];
  }else{
    [self finishCountDown];
  }
}

- (void)finishCountDown{
  if (self.timer){
    [self.timer invalidate];
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.hugeLabel setAlpha:0.0];
  } completion:^(BOOL finished){
    if (self.block){
      self.block();
    }
  }];
  
}

#pragma mark - Private Methods

- (void)createHugeLabel{
  self.hugeLabel = [UILabel new];
  [self.hugeLabel setFont:[UIFont systemFontOfSize:200]];
  [self.hugeLabel setTextColor:[UIColor whiteColor]];
  [self.hugeLabel setAlpha:0.0];
  [self.hugeLabel setTextAlignment:NSTextAlignmentCenter];
  [self.hugeLabel sizeToFit];
  [self addSubview:self.hugeLabel];
}

@end
