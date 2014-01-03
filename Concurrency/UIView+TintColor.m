//
//  UIView+TintColor.m
//  Concurrency
//
//  Created by Nick Lockwood on 03/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "UIView+TintColor.h"
#import <objc/runtime.h>


@implementation UIView (TintColor)

+ (void)load
{
    if (![self instancesRespondToSelector:@selector(tintColor)])
    {
        Method m = class_getInstanceMethod(self, @selector(CCC_tintColor));
        class_addMethod(self, @selector(tintColor), method_getImplementation(m), method_getTypeEncoding(m));
        m = class_getInstanceMethod(self, @selector(CCC_setTintColor:));
        class_addMethod(self, @selector(setTintColor:), method_getImplementation(m), method_getTypeEncoding(m));
    }
}

- (UIColor *)CCC_tintColor
{
    return [UIColor colorWithRed:0 green:122.0/255 blue:1 alpha:1];
}

- (void)CCC_setTintColor:(UIColor *)color
{
    //does nothing
}

@end
