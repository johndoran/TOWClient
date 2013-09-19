//
//  TWCountDownView.h
//  TOWClient
//
//  Created by Ignacio Delgado on 19/09/2013.
//  Copyright (c) 2013 TW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWCountDownView : UIView

- (void)startCountDownAndExecuteWhenFinish:(void (^)(void))onFinish;

@end
