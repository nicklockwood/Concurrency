//
//  PickerView.h
//  CurrencyConverter
//
//  Created by Nick Lockwood on 27/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"


@class PickerView;


@protocol PickerViewDelegate <NSObject>

- (void)pickerViewDidAcceptFirstResponder:(PickerView *)pickerView;
- (void)pickerViewDidResignFirstResponder:(PickerView *)pickerView;
- (void)pickerViewCurrencyDidChange:(PickerView *)pickerView;
- (void)pickerViewValueDidChange:(PickerView *)pickerView;

@end


@interface PickerView : UIView

@property (nonatomic, weak) IBOutlet id<PickerViewDelegate> delegate;

@property (nonatomic, weak, readonly) UITextField *inputField;
@property (nonatomic, copy, readonly) Currency *currency;
@property (nonatomic, assign) double euroValue;
@property (nonatomic, assign) BOOL selected;

- (void)setValue:(double)value forCurrency:(Currency *)currency;

- (IBAction)dismissKeyboard;
- (IBAction)reloadData;

@end
