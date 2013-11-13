//
//  MainViewController.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 26/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "MainViewController.h"
#import "PickerView.h"
#import "Currencies.h"
#import "NumberPad.h"


@interface MainViewController () <PickerViewDelegate>

@property (nonatomic, weak) IBOutlet PickerView *topPicker;
@property (nonatomic, weak) IBOutlet PickerView *bottomPicker;
@property (nonatomic, weak) IBOutlet UILabel *fromCurrencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *toCurrencyLabel;
@property (nonatomic, strong) NumberPad *numberPad;

@end


@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberPad = [NumberPad instance];
    self.topPicker.selected = YES;
    
    self.fromCurrencyLabel.font = [self.fromCurrencyLabel.font fontWithSize:13];
    self.toCurrencyLabel.font = [self.toCurrencyLabel.font fontWithSize:13];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currenciesUpdated)
                                                 name:CurrenciesUpdatedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.topPicker reloadData];
    [self.bottomPicker reloadData];
    [self pickerViewCurrencyDidChange:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.topPicker resignFirstResponder];
    [self.bottomPicker resignFirstResponder];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CurrenciesUpdatedNotification
                                                  object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)currenciesUpdated
{
    [self.topPicker reloadData];
    [self.bottomPicker reloadData];
}

- (IBAction)dismissKeyboard
{
    [self.topPicker dismissKeyboard];
    [self.bottomPicker dismissKeyboard];
}

- (void)pickerViewDidResignFirstResponder:(PickerView *)pickerView
{
    if (pickerView == self.bottomPicker)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.numberPad.bottom = 0.0f;
        } completion:^(BOOL finished) {
            [self.numberPad removeFromSuperview];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.numberPad.top = self.view.bounds.size.height;
        } completion:^(BOOL finished) {
            [self.numberPad removeFromSuperview];
        }];
    }
}

- (void)pickerViewDidAcceptFirstResponder:(PickerView *)pickerView
{
    [self.view addSubview:self.numberPad];
    self.numberPad.textField = pickerView.inputField;
    if (pickerView == self.bottomPicker)
    {
        self.numberPad.bottom = 0.0f;
        [UIView animateWithDuration:0.4 animations:^{
            self.numberPad.top = 0.0f;
        }];
    }
    else
    {
        self.numberPad.top = self.view.bounds.size.height;
        [UIView animateWithDuration:0.4 animations:^{
            self.numberPad.bottom = self.view.bounds.size.height;
        }];
    }
    
    if (pickerView == self.topPicker)
    {
        self.bottomPicker.selected = NO;
    }
    else
    {
        self.topPicker.selected = NO;
    }
    
    //update labels
    [self pickerViewCurrencyDidChange:pickerView];
}

- (void)pickerViewCurrencyDidChange:(PickerView *)pickerView
{
    NSString *from = self.topPicker.currency.name;
    NSString *to = self.bottomPicker.currency.name;
    if (self.bottomPicker.selected)
    {
        NSString *temp = from;
        from = to;
        to = temp;
    }
    self.fromCurrencyLabel.text = from;
    self.toCurrencyLabel.text = to;
}

- (void)pickerViewValueDidChange:(PickerView *)pickerView
{
    if (pickerView == self.topPicker)
    {
        self.bottomPicker.euroValue = pickerView.euroValue;
    }
    else
    {
        self.topPicker.euroValue = pickerView.euroValue;
    }
}
    
@end
