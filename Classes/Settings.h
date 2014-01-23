//
//  Settings.h
//  Concurrency
//
//  Created by Nick Lockwood on 22/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "BaseModel.h"


@interface Settings : BaseModel

@property (nonatomic, assign) BOOL bottomPickerSelected;
@property (nonatomic, assign) NSUInteger topPickerIndex;
@property (nonatomic, assign) NSUInteger bottomPickerIndex;
@property (nonatomic, assign) double currencyValue;

@end
