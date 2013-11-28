//
//  AppDelegate.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 26/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "AppDelegate.h"
#import "CubeController.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
#import "iRate.h"
#import "Currencies.h"


@interface AppDelegate () <CubeControllerDataSource, CubeControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL wiggleCancelled;

@end


@implementation AppDelegate

+ (void)initialize
{
    [iRate sharedInstance].promptAgainForEachNewVersion = NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set up cube controller
    CubeController *controller = (CubeController *)self.window.rootViewController;
    controller.dataSource = self;
    controller.delegate = self;
    controller.view.backgroundColor = [UIColor whiteColor];
    
    //add tap gesture for cancelling wiggle animation
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    gesture.delegate = self;
    [controller.view addGestureRecognizer:gesture];
    
    //wiggle the cube controller
    double speed = 1.5;
    double amplitude = 1.0;
    UIScrollView *scrollView = [controller.view.subviews firstObject];
    if (!_wiggleCancelled)
    {
        [UIView animateWithDuration:0.5 / speed delay:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            scrollView.contentOffset = CGPointMake(80 * amplitude, 0);
            
        } completion:^(BOOL finished) {
            
            if (!finished || _wiggleCancelled) return;
            [UIView animateWithDuration:0.7 / speed delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                
                scrollView.contentOffset = CGPointMake(-50 * amplitude, 0);
                
            } completion:^(BOOL finished) {
                
                if (!finished || _wiggleCancelled) return;
                [UIView animateWithDuration:0.5 / speed delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    
                    scrollView.contentOffset = CGPointMake(20 * amplitude, 0);
                    
                } completion:^(BOOL finished) {
                    
                    if (!finished || _wiggleCancelled) return;
                    [UIView animateWithDuration:0.7 / speed delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                        scrollView.contentOffset = CGPointZero;
                        
                    } completion:NULL];
                }];
            }];
        }];
    }
    
    //create subtle gradient behind status bar
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, 320, 25);
        layer.startPoint = CGPointZero;
        layer.endPoint = CGPointMake(0.0f, 1.0f);
        layer.colors = @[(__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor,
                         (__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.9f].CGColor,
                         (__bridge id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f].CGColor];
        [self.window.layer addSublayer:layer];
    });
    
    return YES;
}

- (NSInteger)numberOfViewControllersInCubeController:(CubeController *)cubeController
{
    return 2;
}

- (UIViewController *)cubeController:(CubeController *)cubeController
               viewControllerAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            return [[MainViewController alloc] init];
        }
        case 1:
        {
            return [[SettingsViewController alloc] init];
        }
    }
    return nil;
}

- (void)cubeControllerCurrentViewControllerIndexDidChange:(CubeController *)cubeController
{
    id field = [cubeController.view firstResponder];
    if ([field respondsToSelector:@selector(setSelectedTextRange:)])
    {
        [field setValue:nil forKey:@"selectedTextRange"];
    }
    [field resignFirstResponder];
}

- (void)cubeControllerDidEndDecelerating:(CubeController *)cubeController
{
    if (cubeController.currentViewControllerIndex == 0 &&
        [[Currencies sharedInstance].enabledCurrencies count] == 0)
    {
        [cubeController scrollToViewControllerAtIndex:1 animated:YES];
        
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [[[UIAlertView alloc] initWithTitle:@"No Currencies Selected" message:@"Please select at least two currencies in order to use the converter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        });
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [gestureRecognizer.view removeGestureRecognizer:gestureRecognizer];
    _wiggleCancelled = YES;
    return NO;
}

@end
