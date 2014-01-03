//
//  CurrencyCell.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 01/07/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "CurrencyCell.h"
#import "ColorUtils.h"


@interface CurrencyCell ()

@property (nonatomic, weak) IBOutlet UILabel *symbolLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end


@implementation CurrencyCell

+ (UIColor *)tintColor
{
    return [[[UIApplication sharedApplication] delegate] window].tintColor;
}

+ (instancetype)dequeueInstanceWithTableView:(UITableView *)tableView
{
    static UINib *nib = nil;
    if (!nib) nib = [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
    CurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifier]];
    if (!cell)
    {
        cell = [[nib instantiateWithOwner:nil options:nil] firstObject];
        cell.selectedBackgroundView.backgroundColor = [self tintColor];
        cell.tintColor = [self tintColor];
    }
    return cell;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.tintColor = highlighted? [UIColor whiteColor]: [[self class] tintColor];
}

- (void)configureWithCurrency:(Currency *)currency
{
    self.symbolLabel.text = currency.symbol ?: currency.code ?: @"-";
    self.symbolLabel.font = [self.symbolLabel.font fontWithSize:currency.symbol? 30: 17];
    self.nameLabel.text = currency.name ?: @"-";
    self.nameLabel.text = currency.name;
    self.accessoryType = currency.enabled? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    self.backgroundColor = currency.enabled? [[[self class] tintColor] colorWithBrightness:2.4]: [UIColor whiteColor];
}

@end
