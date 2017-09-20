//
//  Ball.h
//  BouncingBall
//
//  Created by Junjie      Li on 2017-02-24.
//  Copyright © 2017 Junjie      Li. All rights reserved.
//

#ifndef Ball_h
#define Ball_h
#endif /* Ball_h */


#import <UIKit/UIKit.h>

typedef enum {TANGIBLE, INTANGIBLE} ball_state;

@interface Ball : UIView
@property (readonly) ball_state state;
- (void) returnToTangible;


@property double xSpeed;
@property double ySpeed;

@property (readonly) bool beingDragged;

@end
