//
//  Ball.m
//  BouncingBall
//
//  Created by Junjie      Li on 2017-02-24.
//  Copyright © 2017 Junjie      Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"
#import "math.h"

@implementation Ball

NSTimeInterval  before_last_time;
NSTimeInterval last_time;
CGPoint before_last_location;
CGPoint last_location;
double new_xSpeed = 0;
double new_ySpeed = 0;
bool touchesDidMove;
float maxSpeed = 500;           // set the max speed when flicked speed is faster than the max speed

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setRandomBackgroundColor];
        self.layer.cornerRadius = self.frame.size.width/2; // draw a circle
        self.xSpeed = 25;// initial the value of the velocity of x component
        self.ySpeed = 25;// initial the value of the velocity of y component
        self.exclusiveTouch = YES; // to prevent superview from handling touches on the ball
        // implement the deleting the ball, use double tapping
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delete_Ball:)];
        doubleTap.numberOfTapsRequired = 2;
        
        touchesDidMove = false;
        [self addGestureRecognizer:doubleTap];
        
        [self returnToTangible];
        
    }
    return self;
}

- (void) delete_Ball: (UITapGestureRecognizer*) gestureRecognizer {      // double tap, it will remove its superview
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [self removeFromSuperview];
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{   // when touch begins , the initial speed should be 0

    touchesDidMove = false;
    new_xSpeed = self.xSpeed;
    new_ySpeed = self.ySpeed;
    self.xSpeed = 0;
    self.ySpeed = 0;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {      // when touches move,the ball is dragable
    
    touchesDidMove = true;
    _beingDragged = true;
    [self becomeIntangible];
    UITouch *aTouch = [touches anyObject];
    
    CGPoint newCenter= [aTouch locationInView:self.superview];
    self.center = newCenter;
    self.center = [aTouch locationInView:self.superview];
    before_last_location = last_location;
    before_last_time = last_time;
    last_location = [aTouch locationInView:self.superview];
    last_time = [aTouch timestamp];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    _beingDragged = false;
    if (!touchesDidMove) {
        
        self.xSpeed = new_xSpeed;
        self.ySpeed = new_ySpeed;
        return;
    }
    
    double deltaX = last_location.x - before_last_location.x;   // calculate the velocity from the last position to recent position
    double deltaY = last_location.y - before_last_location.y;
    double deltaTime = last_time - before_last_time;
    
    float xFlickSpeed = deltaX / deltaTime;
    float yFlickSpeed = deltaY / deltaTime;
    
    if (fabsf(xFlickSpeed) > fabsf(maxSpeed)) {
        
        // Assign the max speed instead of the flick speed
        
        if (xFlickSpeed <= 0) {
            self.xSpeed = -1 * fabsf(maxSpeed);
        }
        
        else {
            self.xSpeed = fabsf(maxSpeed);
        }
        
    }
    
    else {
        
        self.xSpeed = xFlickSpeed;     // Assign the flick speed
    }
    
    if (fabsf(yFlickSpeed) > fabsf(maxSpeed)) {
        
        if (yFlickSpeed <= 0) {
            self.ySpeed = -1 * fabsf(maxSpeed);
        }
        
        else {
            self.ySpeed = fabsf(maxSpeed);
        }
    }
    
    else {
        self.ySpeed = yFlickSpeed;
    }
}



- (void) becomeIntangible {   // when the ball is touched, which is intangible now, change the alpha for the color
    self.alpha = 0.3;
    _state = INTANGIBLE;
}

- (void) returnToTangible {     // when the ball is untouched, the alpha of color is same as the original one

    self.alpha = 1;
    _state = TANGIBLE;
    
}


- (void) setRandomBackgroundColor {   // random color for each ball
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );      //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;       //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;       //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.backgroundColor = color;
}

@end
