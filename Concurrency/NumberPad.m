//
//  NumberPad.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 26/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "NumberPad.h"

@implementation NumberPad

+ (instancetype)instance
{
    NumberPad *instance = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    instance.layer.shouldRasterize = YES;
    instance.layer.rasterizationScale = 2;
    return instance;
}

- (IBAction)pressedButton:(UIButton *)sender
{
    [self.textField insertText:sender.titleLabel.text];
}

- (IBAction)pressedDelete
{
    [self.textField deleteBackward];
}

- (IBAction)heldDelete
{
    self.textField.text = nil;
}

@end
