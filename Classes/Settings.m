//
//  Settings.m
//  Concurrency
//
//  Created by Nick Lockwood on 22/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "Settings.h"


@implementation Settings
{
    BOOL _saveScheduled;
}

+ (BMFileFormat)saveFormat
{
    return BMFileFormatUserDefaults;
}

- (void)setUp
{
    //add observers for properties, so we can save automatically
    for (NSString *key in [[self class] codablePropertyKeys])
    {
        [self addObserver:self forKeyPath:key options:(NSKeyValueObservingOptions)0 context:NULL];
    }
}

- (void)tearDown
{
    //remove observers
    for (NSString *key in [[self class] codablePropertyKeys])
    {
        [self removeObserver:self forKeyPath:key];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(__unused NSDictionary *)change context:(__unused void *)context
{
    if (!_saveScheduled)
    {
        _saveScheduled = YES;
        [self performSelectorOnMainThread:@selector(save) withObject:nil waitUntilDone:NO];
    }
}

- (BOOL)save
{
    _saveScheduled = NO;
    return [super save];
}

@end
