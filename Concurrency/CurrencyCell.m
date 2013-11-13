//
//  CurrencyCell.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 01/07/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "CurrencyCell.h"


@interface CurrencyCell ()

@property (nonatomic, weak) IBOutlet UILabel *symbolLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end


@implementation CurrencyCell

+ (UINib *)nib
{
    static UINib *nib = nil;
    if (!nib)
    {
        nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    }
    return nib;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

- (void)configureWithCurrency:(Currency *)currency
{
    self.symbolLabel.text = [currency.symbol length]? currency.symbol: currency.code;
    self.symbolLabel.font = [self.symbolLabel.font fontWithSize:[currency.symbol length]? 30: 17];
    self.nameLabel.text = currency.name;
    self.accessoryType = currency.enabled? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
}

@end
