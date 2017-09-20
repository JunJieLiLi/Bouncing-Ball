//
//  ViewController.m
//  BouncingBall
//
//  Created by Junjie      Li on 2017-02-24.
//  Copyright © 2017 Junjie      Li. All rights reserved.
//

#include "Ball.h"
#import "ViewController.h"

@interface ViewController ()
@property NSTimer * redrawTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.redrawTimer = [NSTimer scheduledTimerWithTimeInterval:(time_rate) target:(self) selector:(@selector(redraw:)) userInfo:(NULL) repeats:(YES)];
    
    Ball * ball = [[Ball alloc] initWithFrame:CGRectMake(10,20,square_length,square_length)];     // create the balls
    Ball * ball2 = [[Ball alloc] initWithFrame:CGRectMake(40,100,square_length,square_length)];
    
    
    [self.view addSubview:ball];                // add the balls for testing
    [self.view addSubview:ball2];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector  // call long press gesture, select method addNewBall, target is it's root view self
(addNewBall:)];
    
    [self.view addGestureRecognizer:longPress];
}

- (void) applyFriction: (Ball *) ball {        // add the friction to the velocity to make it stop
    
    if (ball.xSpeed > 0) {
        ball.xSpeed -= Friction;               // positive , minus friction
    }
    
    if (ball.xSpeed<0){
        ball.xSpeed += Friction                // negative , plus friction until it getting 0
    }
    
    if (ball.ySpeed > 0) {
        ball.ySpeed -= Friction;
    }
    
    if (ball.ySpeed < 0) {
        ball.ySpeed += Friction;
    }
    
}

- (bool) checkForOverlapBetweenBall1: (Ball*) b1 andBall2: (Ball*) b2 {     // check two balls do not overlap each other
    
    return CGRectIntersectsRect(b1.frame, b2.frame);
}

- (void) addNewBall:(UILongPressGestureRecognizer*) gestureRecognizer {     // for the long press , adding a new ball, and check the x and y coordinates of the new ball(can not over the edges)

    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint loc = [gestureRecognizer locationInView:self.view];
        
        CGFloat rectOriginX = loc.x - square_length / 2;                    // find the original points x and y for the new adding ball
        CGFloat rectOriginY = loc.y - square_length / 2;
        
       
        CGFloat leftEdge = self.view.bounds.origin.x;                        // Prevent creation of a ball over an edge
        CGFloat rightEdge = self.view.bounds.origin.x + self.view.bounds.size.width;
        CGFloat topEdge = self.view.bounds.origin.y;
        CGFloat bottomEdge = self.view.bounds.origin.y + self.view.bounds.size.height;
        CGFloat offset = 0.5;
        
        
        if (rectOriginX <= leftEdge) {                                      // Check left and right
            rectOriginX = leftEdge + offset;
        }
        
        else if (rectOriginX + square_length >= rightEdge) {
            rectOriginX = rightEdge - square_length - offset;
        }
        
       
        if (rectOriginY <= topEdge) {                                         // Check top and bottom
            rectOriginY = topEdge + offset;
        }
        
        else if (rectOriginY + square_length >= bottomEdge) {
            rectOriginY = bottomEdge - square_length - offset;
        }
        
        
        CGRect ballRect = CGRectMake(rectOriginX, rectOriginY,square_length,square_length);
        
       
        for (id obj in self.view.subviews) {                                   // Prevent creation of a ball that overlaps with another ball
            
            if ([obj isMemberOfClass: [Ball class]]) {
                
                Ball * existingBall = (Ball *) obj;                            // casting ball class
                
                if (CGRectIntersectsRect(ballRect, existingBall.frame)) {      // Overlap detected, do not add a ball here at the moment
                    return;
                }
                
            }
        }
        
        Ball * newBall = [[Ball alloc] initWithFrame:ballRect];
        [self.view addSubview:newBall];
    }
    
    
}

- (void) redraw:(NSTimer *)timer {
    
    
    for (int i = 0; i < [self.view.subviews count]; i++) {
        id ballArray = [self.view.subviews objectAtIndex:i];
        
        if (([ballArray isMemberOfClass: [Ball class]])) {
            
            Ball * thisBall = (Ball*) ballArray;
            
            if (thisBall.beingDragged) continue;
            
            CGPoint centerBeforeMoving = thisBall.center;             //[thisBall moveOverTime:(time_rate)];
           
            CGPoint newCenter = CGPointMake(thisBall.center.x + time_rate * thisBall.xSpeed, thisBall.center.y + time_rate * thisBall.ySpeed);                                     //  make a ball moving in the rootView (time*speed+x or y is the final position )
            thisBall.center = newCenter;
            
            float rightEdgeX = self.view.bounds.origin.x + self.view.bounds.size.width;
            
            float bottomEdgeY = self.view.bounds.origin.y + self.view.bounds.size.height;
            
            BOOL hitLeftEdge = thisBall.frame.origin.x <= self.view.bounds.origin.x;       // Check for collision with edges and the balls should not go over the edges
            
            BOOL hitTopEdge = thisBall.frame.origin.y <= self.view.bounds.origin.y;
            
            BOOL hitRightEdge = thisBall.frame.origin.x + thisBall.frame.size.width >= self.view.bounds.origin.x + self.view.bounds.size.width;
            
            BOOL hitBottomEdge = thisBall.frame.origin.y + thisBall.frame.size.height >= self.view.bounds.origin.y + self.view.bounds.size.height;
            
            CGFloat offsetFromEdge = 0.1;
            
            CGFloat xCoord = thisBall.center.x;
            
            CGFloat yCoord = thisBall.center.y;
            
            
            if (hitLeftEdge) {                                        //check the left edge
                
                xCoord = offsetFromEdge + thisBall.frame.size.width / 2;
                thisBall.xSpeed = -1 * thisBall.xSpeed;
            }
            
            if (hitRightEdge) {                                         // check the right edge
                
                xCoord = rightEdgeX - thisBall.frame.size.width / 2  - offsetFromEdge;
                thisBall.xSpeed = -1 * thisBall.xSpeed;
            }
            
            if (hitTopEdge) {                                           // check the top edge
                
                yCoord = offsetFromEdge + thisBall.frame.size.height / 2;
                thisBall.ySpeed = -1 * thisBall.ySpeed;
            }
            
            if (hitBottomEdge) {                                        // check the bottom edge
                
                yCoord = bottomEdgeY - thisBall.frame.size.height / 2 - offsetFromEdge;
                thisBall.ySpeed = -1 * thisBall.ySpeed;
            }
            
            CGPoint adjustedCenter = CGPointMake(xCoord, yCoord);
            thisBall.center = adjustedCenter;
            
            int otherBallIndex = 0;                                     // Check for collision with all other balls
            Ball * otherBall;
            
            while (otherBallIndex < [self.view.subviews count]) {
                
                if (i == otherBallIndex) {
                    otherBallIndex++;
                    continue;
                }
                
                id nextballArray = [self.view.subviews objectAtIndex:otherBallIndex];
                
                if (([nextballArray isMemberOfClass: [Ball class]])) {
                    
                    otherBall = (Ball*) nextballArray;
                    
                    if (otherBall.state == INTANGIBLE) {
                        
                        otherBallIndex++;
                        continue;
                    }
                    
                    bool overlap = [self checkForOverlapBetweenBall1:thisBall andBall2:otherBall];
                    
                    if (overlap) {
                        
                        break;
                    }
                }
                
                otherBallIndex++;
                
            }
            
            if (otherBallIndex < [self.view.subviews count]) { // there was an overlap
                
                if (thisBall.state == TANGIBLE) {
                    
                    otherBall = (Ball *) [self.view.subviews objectAtIndex:otherBallIndex];
                    thisBall.center = centerBeforeMoving; // put it back to prevent overlap
                    [self collisionBetweenBall1:thisBall AndBall2:otherBall];
                }
                
            }
            
            else {                  // No overlap, so if this ball was intangible, it now has space to become tangible again
                
                
                if (thisBall.state == INTANGIBLE) {
                    [thisBall returnToTangible];
                }
            }
            
            [self applyFriction:thisBall];
        }
        
    }
    
    
    
    
}



- (void) collisionBetweenBall1: (Ball*) firstBall AndBall2: (Ball*) secondBall {            //formula for collison
    double collisionAngle = atan2( fabs(firstBall.center.y - secondBall.center.y), fabs(firstBall.center.x - secondBall.center.x));
    
    double v1 = sqrt(   pow(firstBall.xSpeed, 2) + pow(firstBall.ySpeed, 2)   );
    double v2 = sqrt(   pow(secondBall.xSpeed, 2) + pow(secondBall.ySpeed, 2)   );
    
    double d1 = atan2(firstBall.ySpeed, firstBall.xSpeed);
    double d2 = atan2(secondBall.ySpeed, secondBall.xSpeed);
    
    double v1x = v1 * cos(d1 - collisionAngle);
    double v1y = v1 * sin(d1 - collisionAngle);
    double v2x = v2 * cos(d2 - collisionAngle);
    double v2y = v2 * sin(d2 - collisionAngle);
    
    double f1x = v2x;
    double f2x = v1x;
    
    double v1_final = sqrt ( f1x * f1x + v2y * v2y  );
    double v2_final = sqrt ( f2x * f2x + v1y * v1y  );
    
    double d1_final = atan2(v2y, f1x) + collisionAngle;
    double d2_final = atan2(v1y, f2x) + collisionAngle;
    
    firstBall.xSpeed = v1_final * cos(d1_final);
    firstBall.ySpeed = v1_final * sin(d1_final);
    
    secondBall.xSpeed = v2_final * cos(d2_final);
    secondBall.ySpeed = v2_final * sin(d2_final);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
