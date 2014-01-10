//
//  Currency.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 30/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "Currency.h"
#import "Currencies.h"

@interface Currency ()

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation Currency

+ (instancetype)nullCurrency
{
    static Currency *currency = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currency = [[Currency alloc] init];
    });
    
    return currency;
}

- (void)setCode:(NSString *)code
{
    _code = code;
    [self configureNumberFormatter];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = [symbol length]? symbol: nil;
}

- (double)valueInEuros:(double)value
{
    return _rate? (value / _rate): 0.0;
}

- (double)valueFromEuros:(double)euroValue
{
    return euroValue * _rate;
}

- (double)value:(double)value convertedToCurrency:(Currency *)currency
{
    return [currency valueFromEuros:[self valueInEuros:value]];
}

- (NSString *)localisedStringFromValue:(double)value
{
    if (self.numberFormatter) {
        return [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    }
    return nil;
}

- (NSUInteger)hash
{
    return [_code hash];
}

- (BOOL)isEqual:(Currency *)object
{
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return [object.code isEqualToString:self.code];
}

- (void)save
{
    [[Currencies sharedInstance] save];
}

- (void)configureNumberFormatter
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSLocale localeIdentifierFromComponents:@{NSLocaleCurrencyCode: self.code}]];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:locale];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@""]; // Since the currency symbol is displayed separately
    self.numberFormatter = numberFormatter;
}

@end
