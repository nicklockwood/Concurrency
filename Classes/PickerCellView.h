//
//  PickerCellView.h
//  CurrencyConverter
//
//  Created by Nick Lockwood on 27/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"

@interface PickerCellView : UIView

+ (UINib *)nib;
+ (CGFloat)height;
- (void)configureWithCurrency:(Currency *)currency value:(double)value;

@end
