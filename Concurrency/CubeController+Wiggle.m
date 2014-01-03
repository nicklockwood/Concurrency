//
//  CubeController+Wiggle.m
//  Concurrency
//
//  Created by Nick Lockwood on 02/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "CubeController+Wiggle.h"
#import <objc/runtime.h>


@interface CubeController (Wiggle_Private)

@property (nonatomic, getter = isWiggleCancelled) BOOL wiggleCancelled;

@end


@implementation CubeController (Wiggle)

- (void)wiggle
{
    double speed = 1.5;
    double amplitude = 1.0;
    self.wiggleCancelled = NO;
    
    [UIView animateWithDuration:0.5 / speed delay:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
        self.scrollView.contentOffset = CGPointMake(80 * amplitude, 0);
        
    } completion:^(BOOL finished) {
        
        if (!finished || self.wiggleCancelled) return;
        [UIView animateWithDuration:0.7 / speed delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.scrollView.contentOffset = CGPointMake(-50 * amplitude, 0);
            
        } completion:^(BOOL finished) {
            
            if (!finished || self.wiggleCancelled) return;
            [UIView animateWithDuration:0.5 / speed delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                
                self.scrollView.contentOffset = CGPointMake(20 * amplitude, 0);
                
            } completion:^(BOOL finished) {
                
                if (!finished || self.wiggleCancelled) return;
                [UIView animateWithDuration:0.7 / speed delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    
                    self.scrollView.contentOffset = CGPointZero;
                    
                } completion:NULL];
            }];
        }];
    }];
}

- (void)setWiggleCancelled:(BOOL)wiggleCancelled
{
    objc_setAssociatedObject(self, @selector(isWiggleCancelled), @(wiggleCancelled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isWiggleCancelled
{
    return [objc_getAssociatedObject(self, @selector(isWiggleCancelled)) boolValue];
}

- (void)cancelWiggle
{
    self.wiggleCancelled = YES;
}

@end
