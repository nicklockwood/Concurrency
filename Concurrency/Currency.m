//
//  Currency.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 30/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "Currency.h"
#import "Currencies.h"


#define SET_STRING_IF_NOT_EMPTY(target, string) if([string length]) (target) = (string)
#define STRING_IF_NOT_EMPTY(string) ([string length])? (string): nil


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

- (void)setWithDictionary:(NSDictionary *)dict
{
    _code = STRING_IF_NOT_EMPTY(dict[@"code"]);
    _symbol = STRING_IF_NOT_EMPTY(dict[@"symbol"]);
    _name = STRING_IF_NOT_EMPTY(dict[@"name"]);
    _rate = [dict[@"rate"] doubleValue];
    _enabled = [dict[@"enabled"] boolValue];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    SET_STRING_IF_NOT_EMPTY(dict[@"code"], _code);
    SET_STRING_IF_NOT_EMPTY(dict[@"symbol"], _symbol);
    SET_STRING_IF_NOT_EMPTY(dict[@"name"], _name);
    dict[@"rate"] = @(_rate);
    dict[@"enabled"] = @(_enabled);
    return dict;
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

@end
