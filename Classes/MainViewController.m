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
#import "ViewUtils.h"
#import "Settings.h"


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
    
    //set up number pad
    self.numberPad = [NumberPad instance];
    self.numberPad.layer.rasterizationScale = 2;
    
    //set up labels
    self.fromCurrencyLabel.font = [self.fromCurrencyLabel.font fontWithSize:13];
    self.toCurrencyLabel.font = [self.toCurrencyLabel.font fontWithSize:13];
    
    //update pickers
    [self.topPicker reloadData];
    [self.bottomPicker reloadData];
    
    //restore state
    self.topPicker.selectedIndex = [Settings sharedInstance].topPickerIndex;
    self.bottomPicker.selectedIndex = [Settings sharedInstance].bottomPickerIndex;
    self.topPicker.selected = ![Settings sharedInstance].bottomPickerSelected;
    self.bottomPicker.selected = [Settings sharedInstance].bottomPickerSelected;
    if (self.topPicker.selected)
    {
        self.topPicker.currencyValue = [Settings sharedInstance].currencyValue;
        [self.bottomPicker setValue:self.topPicker.currencyValue forCurrency:self.topPicker.currency];
    }
    else
    {
        self.bottomPicker.currencyValue = [Settings sharedInstance].currencyValue;
        [self.topPicker setValue:self.bottomPicker.currencyValue forCurrency:self.bottomPicker.currency];
    }
    
    //observe currency updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currenciesUpdated)
                                                 name:CurrenciesUpdatedNotification
                                               object:nil];
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
    [self updateCurrencyLabels];
    if (self.topPicker.selected)
    {
        [self.bottomPicker setValue:self.topPicker.currencyValue forCurrency:self.topPicker.currency];
    }
    else
    {
        [self.topPicker setValue:self.bottomPicker.currencyValue forCurrency:self.bottomPicker.currency];
    }
    
    //persist state
    [Settings sharedInstance].topPickerIndex = self.topPicker.selectedIndex;
    [Settings sharedInstance].bottomPickerIndex = self.bottomPicker.selectedIndex;
}

- (void)updateCurrencyLabels
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

- (void)pickerViewDidAcceptFirstResponder:(PickerView *)pickerView inputField:(id)inputField
{
    [self.view addSubview:self.numberPad];
    self.numberPad.inputField = inputField;
    if (pickerView == self.bottomPicker)
    {
        self.numberPad.layer.shouldRasterize = NO;
        self.numberPad.bottom = 0.0f;
        [UIView animateWithDuration:0.4 animations:^{
            
            self.numberPad.top = 0.0f;
            
        } completion:^(BOOL finished) {
            
            self.numberPad.layer.shouldRasterize = YES;
            self.numberPad.layer.rasterizationScale = 2;
        }];
    }
    else
    {
        self.numberPad.layer.shouldRasterize = NO;
        self.numberPad.top = self.view.bounds.size.height;
        [UIView animateWithDuration:0.4 animations:^{
            
            self.numberPad.bottom = self.view.bounds.size.height;
            
        } completion:^(BOOL finished) {
            
            self.numberPad.layer.shouldRasterize = YES;
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
    
    //persist state
    [Settings sharedInstance].bottomPickerSelected = (pickerView == self.bottomPicker);
}

- (void)pickerViewCurrencyDidChange:(PickerView *)pickerView
{
    [self updateCurrencyLabels];
    
    //persist state
    if (pickerView == self.topPicker)
    {
        [Settings sharedInstance].topPickerIndex = pickerView.selectedIndex;
    }
    else
    {
        [Settings sharedInstance].bottomPickerIndex = pickerView.selectedIndex;
    }
}

- (void)pickerViewValueDidChange:(PickerView *)pickerView
{
    //sync values
    if (pickerView == self.topPicker)
    {
        [self.bottomPicker setValue:pickerView.currencyValue forCurrency:pickerView.currency];
    }
    else
    {
        [self.topPicker setValue:pickerView.currencyValue forCurrency:pickerView.currency];
    }
    
    //persist state
    [Settings sharedInstance].currencyValue = pickerView.currencyValue;
}

@end
