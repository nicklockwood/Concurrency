//
//  Currencies.h
//  CurrencyConverter
//
//  Created by Nick Lockwood on 27/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Currency.h"


extern NSString *const CurrenciesUpdatedNotification;


@interface Currencies : BaseModel

@property (nonatomic, copy, readonly) NSArray *allCurrencies;
@property (nonatomic, copy, readonly) NSArray *enabledCurrencies;
@property (nonatomic, strong, readonly) NSDate *lastUpdated;

- (Currency *)currencyForCode:(NSString *)code;
- (NSArray *)currenciesMatchingSearchString:(NSString *)searchString;
- (void)updateWithBlock:(void (^)(void))block;
- (void)update;

@end
