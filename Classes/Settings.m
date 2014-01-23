//
//  Settings.m
//  Concurrency
//
//  Created by Nick Lockwood on 22/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "Settings.h"


@interface BaseModel (Private)

//bit hacky that we're exposing this in this way
//a future version of BaseModel will expose this
+ (NSArray *)BM_propertyKeys;

@end


@implementation Settings
{
    BOOL _saveScheduled;
    BOOL _observersAdded;
}

- (void)setUp
{
    //add observers for properties, so we can save automatically
    for (NSString *key in [[self class] BM_propertyKeys])
    {
        //set value from user defaults
        id value = [[NSUserDefaults standardUserDefaults] valueForKey:key];
        if (value) [self setValue:value forKey:key];
        
        //observe setters
        [self addObserver:self forKeyPath:key options:(NSKeyValueObservingOptions)0 context:NULL];
    }
    _observersAdded = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(__unused NSDictionary *)change context:(__unused void *)context
{
    [[NSUserDefaults standardUserDefaults] setObject:[self valueForKey:keyPath] forKey:keyPath];
    if (!_saveScheduled)
    {
        _saveScheduled = YES;
        [self performSelectorOnMainThread:@selector(save) withObject:nil waitUntilDone:NO];
    }
}

- (void)save
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    _saveScheduled = NO;
}

- (void)dealloc
{
    if (_observersAdded)
    {
        for (NSString *key in [[self class] BM_propertyKeys])
        {
            //remove observers
            [self removeObserver:self forKeyPath:key];
        }
    }
}

@end
