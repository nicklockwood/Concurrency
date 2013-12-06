//
//  PickerCellView.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 27/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "PickerCellView.h"


@interface PickerCellView ()

@property (nonatomic, weak) IBOutlet UILabel *symbolLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end


@implementation PickerCellView

+ (UINib *)nib
{
    static UINib *nib = nil;
    if (!nib)
    {
        nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    }
    return nib;
}

+ (CGFloat)height
{
    return 40;
}

- (void)configureWithCurrency:(Currency *)currency value:(double)value
{
    self.symbolLabel.text = currency.symbol ?: currency.code ?: @"-";
    self.symbolLabel.font = [self.symbolLabel.font fontWithSize:currency.symbol? 30: 17];
    self.valueLabel.text = [NSString stringWithFormat:@"%0.2f", value];
    self.valueLabel.font = [self.valueLabel.font fontWithSize:30];
}

@end
