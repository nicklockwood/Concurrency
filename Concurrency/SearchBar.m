//
//  SearchBar.m
//  Concurrency
//
//  Created by Nick Lockwood on 03/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)
    {
        //remove the background view
        [[self.subviews firstObject] removeFromSuperview];
        
        //set textfield return key to "done"
        for (UITextField *textfield in self.subviews)
        {
            if ([textfield isKindOfClass:[UITextField class]])
            {
                textfield.returnKeyType = UIReturnKeyDone;
                break;
            }
        }
    }
    else
    {
        //on iOS 7 there's an extra wrapper view
        for (UITextField *textfield in [[self.subviews firstObject] subviews])
        {
            if ([textfield isKindOfClass:[UITextField class]])
            {
                //use "return" on iOS 7 because blue button looks fugly
                textfield.returnKeyType = UIReturnKeyDefault;
                break;
            }
        }
    }
}
    
@end
