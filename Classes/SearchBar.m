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
    
    //use "return" on iOS 7 because blue button looks fugly
    UIReturnKeyType returnKeyType = UIReturnKeyDefault;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)
    {
        //remove the background view
        [[self.subviews firstObject] removeFromSuperview];
        
        //set textfield return key to "done" as this looks OK with blue theme
        returnKeyType = UIReturnKeyDone;
    }

    //set return key type
    ((UITextField *)[self viewOfClass:[UITextField class]]).returnKeyType = returnKeyType;
}
    
@end
