//
//  GameStatusView.h
//  pullTheRope
//
//  Created by Ignacio Delgado on 19/09/2013.
//  Copyright (c) 2013 MTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWGameStatusView : UIView

@property (nonatomic) BOOL playerInTeamA;

- (void)updateResultOfGame:(CGFloat)result;
- (void)setupNewGameWithPlayerInTeamA:(BOOL)playerInTeamA;

@end
