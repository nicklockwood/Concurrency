//
//  UIViewController+Gradient.m
//  Concurrency
//
//  Created by Nick Lockwood on 10/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "UIViewController+Gradient.h"

@implementation UIViewController (Gradient)

- (void)addGradientLayer
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25);
    layer.startPoint = CGPointZero;
    layer.endPoint = CGPointMake(0.0f, 1.0f);
    layer.colors = @[(__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor,
                     (__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.9f].CGColor,
                     (__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f].CGColor];
    
    [self.view.layer addSublayer:layer];
}

@end
