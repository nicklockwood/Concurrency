//
//  Currency.h
//  CurrencyConverter
//
//  Created by Nick Lockwood on 30/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "BaseModel.h"

@interface Currency : BaseModel

@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *symbol;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) double rate;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

+ (instancetype)nullCurrency;

- (double)valueInEuros:(double)value;
- (double)valueFromEuros:(double)euroValue;
- (double)value:(double)value convertedToCurrency:(Currency *)currency;
- (NSString *)localisedStringFromValue:(double)value;

@end
