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


@interface AppDelegate () <CubeControllerDataSource>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CubeController *controller = (CubeController *)self.window.rootViewController;
    controller.dataSource = self;
    controller.view.backgroundColor = [UIColor whiteColor];
    
    double speed = 1.5;
    NSTimeInterval delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        CubeController *controller = (CubeController *)self.window.rootViewController;
        UIScrollView *scrollView = [controller.view.subviews firstObject];
        
        [UIView animateWithDuration:0.5 / speed animations:^{
            
            scrollView.contentOffset = CGPointMake(80, 0);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.7 / speed animations:^{
                
                scrollView.contentOffset = CGPointMake(-50, 0);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 / speed animations:^{
                    
                    scrollView.contentOffset = CGPointMake(20, 0);
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.5 / speed animations:^{
                        
                        scrollView.contentOffset = CGPointZero;
                    }];
                }];
            }];
        }];
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

@end
