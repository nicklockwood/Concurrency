//
//  NumberPad.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 26/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "NumberPad.h"


@interface NumberPad () <UIGestureRecognizerDelegate>

@end


@implementation NumberPad

+ (instancetype)instance
{
    return [self instanceWithNibName:nil bundle:nil owner:nil];
}

- (UIColor *)tintColor
{
    return [UIApplication sharedApplication].delegate.window.tintColor;
}

- (void)awakeFromNib
{
    [(UIButton *)[self viewWithTag:12] setTitleColor:self.tintColor forState:UIControlStateNormal];
}

- (IBAction)pressedButton:(UIButton *)sender
{
    [self.inputField insertText:sender.titleLabel.text];
}

- (IBAction)pressedDelete
{
    [self.inputField deleteBackward];
}

- (IBAction)heldDelete
{
    self.inputField.text = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //prevents accidental side-swipe when keyboard is open
    return YES;
}

@end
