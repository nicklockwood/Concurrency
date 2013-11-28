//
//  NumberField.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 26/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "NumberField.h"
#import "NumberPad.h"

@implementation NumberField

- (void)setUp
{
    self.inputView = [[UIView alloc] init];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self setUp];
    }
    return self;
}

- (void)insertText:(NSString *)text
{
    NSString *previousText = self.text;
    
    UITextRange *selection = [self selectedTextRange];
    [super insertText:text];
    if ([[self.text stringByReplacingOccurrencesOfString:@"^[0-9]+(\\.[0-9]{0,2})?$" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self.text length])] length] > 0 || [self.text doubleValue] > 99999999.99)
    {
        self.text = previousText;
        [self setSelectedTextRange:selection];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(cut:) ||
        action == @selector(copy:) ||
        action == @selector(paste:) ||
        action == @selector(select:))
    {
        return [super canPerformAction:action withSender:sender];
    }
    return NO;
}

@end
