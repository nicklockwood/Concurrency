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
        //remove the search bar background view on iOS 6
        [[self.subviews firstObject] removeFromSuperview];
    }

    //use "return" button on keyboard because blue button looks fugly, especially on iOS 7
    ((UITextField *)[self viewOfClass:[UITextField class]]).returnKeyType = UIReturnKeyDefault;
}
    
@end
