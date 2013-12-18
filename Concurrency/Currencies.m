//
//  Currencies.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 27/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "Currencies.h"
#import "XMLDictionary.h"


NSString *const CurrenciesUpdatedNotification = @"CurrenciesUpdatedNotification";
static NSString *const UpdateURL = @"http://themoneyconverter.com/rss-feed/EUR/rss.xml";


@implementation Currencies
{
    NSMutableDictionary *_currenciesByCode;
}

+ (void)load
{
    //auto-initialize
    [self performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
}

- (void)setWithDictionary:(NSDictionary *)dict
{
    //set last updated date
    NSDate *date = dict[@"lastUpdated"];
    if (_lastUpdated && [_lastUpdated timeIntervalSinceDate:date] >= 0)
    {
        //merge enabled
        for (NSDictionary *entry in dict[@"currencies"])
        {
            Currency *currency = [self currencyForCode:entry[@"code"]];
            [currency setValue:entry[@"enabled"] forKey:@"enabled"];
        }
        return;
    }
    _lastUpdated = date;
    
    //set currencies
    _allCurrencies = [[Currency instancesWithArray:dict[@"currencies"]] sortedArrayUsingComparator:^NSComparisonResult(Currency *a, Currency *b) {
        
        return [a.name caseInsensitiveCompare:b.name];
    }];
    
    //set currencies by code
    _currenciesByCode = [NSMutableDictionary dictionaryWithObjects:_allCurrencies forKeys:[_allCurrencies valueForKeyPath:@"code"]];
    
    //download update
    [self update];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (Currency *)currencyForCode:(NSString *)code
{
    return _currenciesByCode[code];
}

- (NSArray *)enabledCurrencies
{
    return [_allCurrencies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"enabled=YES"]];
}

- (void)updateWithBlock:(void (^)(void))block
{
    NSURL *URL = [NSURL URLWithString:UpdateURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *xmlDict = [NSDictionary dictionaryWithXMLData:data];
        if (xmlDict)
        {
            for (NSDictionary *entry in [xmlDict valueForKeyPath:@"channel.item"])
            {
                NSString *code = [[entry[@"title"] componentsSeparatedByString:@"/"] firstObject];
                if (!code) continue;
                
                NSString *description = [entry[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (![description hasPrefix:@"1 Euro = "]) continue;
                
                description = [description substringFromIndex:9];
                NSArray *parts = [description componentsSeparatedByString:@" "];
                NSString *rate = [[parts firstObject] stringByReplacingOccurrencesOfString:@"," withString:@""];
                if ([rate doubleValue] < 0.000001) continue;
                
                Currency *currency = [self currencyForCode:code];
                if (!currency)
                {
                    currency = [Currency instance];
                    [currency setValue:code forKey:@"code"];
                    _currenciesByCode[code] = currency;
                }
                
                NSString *name = [[parts subarrayWithRange:NSMakeRange(1, [parts count] - 1)] componentsJoinedByString:@" "];
                if (name) [currency setValue:name forKey:@"name"];
                [currency setValue:rate forKey:@"rate"];
            }
            
            _lastUpdated = [NSDate date];
            _allCurrencies = [[_currenciesByCode allValues] sortedArrayUsingComparator:^NSComparisonResult(Currency *a, Currency *b) {
                
                return [a.name caseInsensitiveCompare:b.name];
            }];
            
            [self save];
        }
        
        if (block) block();
    }];
}

- (void)update
{
    [self updateWithBlock:NULL];
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)atomically
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrenciesUpdatedNotification object:self];
    NSMutableArray *currencies = [_allCurrencies valueForKeyPath:@"dictionaryRepresentation"];
    return [@{@"lastUpdated": _lastUpdated, @"currencies": currencies} writeToFile:path atomically:atomically];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
