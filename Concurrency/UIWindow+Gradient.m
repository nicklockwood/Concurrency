//
//  UIWindow+Gradient.m
//  Concurrency
//
//  Created by Nick Lockwood on 10/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "UIWindow+Gradient.h"

@implementation UIWindow (Gradient)

- (void)addGradientLayer
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, 320, 25);
    layer.startPoint = CGPointZero;
    layer.endPoint = CGPointMake(0.0f, 1.0f);
    layer.colors = @[(__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor,
                     (__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.9f].CGColor,
                     (__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f].CGColor];
    
    [self.layer addSublayer:layer];
}

@end
