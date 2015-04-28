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
#import "CubeController+Wiggle.h"
#import "UIViewController+Gradient.h"
#import "Currencies.h"
#import "ViewUtils.h"


@interface AppDelegate () <CubeControllerDataSource, CubeControllerDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) id visibleAlert;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set window tint (does nothing on iOS 6)
    self.window.tintColor = [UIColor colorWithRed:100.0f/255 green:200.0f/255 blue:100.0f/255 alpha:1];

    //set up cube controller
    CubeController *controller = (CubeController *)self.window.rootViewController;
    controller.dataSource = self;
    controller.delegate = self;
    controller.view.backgroundColor = [UIColor whiteColor];
    
    //add window gradient
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [controller addGradientLayer];
    });
    
    //add tap gesture for cancelling wiggle animation
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
    gesture.delegate = self;
    [controller.view addGestureRecognizer:gesture];
    
    //wiggle the cube controller
    [controller wiggleWithCompletionBlock:^(BOOL finished) {
        [controller.view removeGestureRecognizer:gesture];
    }];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.window.rootViewController.view.frame = self.window.bounds;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [gestureRecognizer.view removeGestureRecognizer:gestureRecognizer];
    [(CubeController *)self.window.rootViewController cancelWiggle];
    return NO;
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
    UIResponder *field = [cubeController.view firstResponder];
    if ([field respondsToSelector:@selector(setSelectedTextRange:)])
    {
        //prevents weird misalignment of selection handles
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
    }
}

- (void)cubeControllerDidEndScrollingAnimation:(CubeController *)cubeController
{
    if (cubeController.currentViewControllerIndex == 1 &&
        [[Currencies sharedInstance].enabledCurrencies count] == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.visibleAlert)
            {
                NSString *title = @"No Currencies Selected";
                NSString *message = @"Please select at least two currencies in order to use the converter.";
                NSString *button = @"OK";
                
                if ([UIAlertController class])
                {
                    self.visibleAlert = [UIAlertController alertControllerWithTitle:title
                                                                            message:message
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                    
                    [self.visibleAlert addAction:[UIAlertAction actionWithTitle:button style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        self.visibleAlert = nil;
                    }]];
                    
                    [self.window.rootViewController presentViewController:self.visibleAlert animated:YES completion:NULL];
                }
                else
                {
                    self.visibleAlert = [[UIAlertView alloc] initWithTitle:title
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:button
                                                         otherButtonTitles:nil];
                    [self.visibleAlert show];
                }
            }
        });
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == self.visibleAlert)
    {
        self.visibleAlert = nil;
    }
}

@end
