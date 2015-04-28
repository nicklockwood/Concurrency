//
//  PickerView.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 27/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "PickerView.h"
#import "iCarousel.h"
#import "Currencies.h"
#import "PickerCellView.h"


@interface PickerView () <iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSArray *currencies;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) IBOutlet NumberField *inputField;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UIView *spacerView;

@end


@implementation PickerView

- (void)setUp
{
    [self loadContentsWithNibName:nil bundle:nil];
    self.carousel.vertical = YES;
    self.carousel.type = iCarouselTypeCylinder;
    self.carousel.centerItemWhenSelected = NO;
    self.carousel.perspective = 0;
    
    self.inputField.font = [self.inputField.font fontWithSize:30];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.inputField];
    
    [self reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected)
    {
        self.inputField.doubleValue = self.currencyValue;
        self.inputField.backgroundColor = [UIColor whiteColor];
    }
    [self.overlayView crossfadeWithDuration:0.4 completion:^{
        
        if (!selected)
        {
            self.inputField.text = @"";
            self.inputField.backgroundColor = nil;
        }
    }];
    self.overlayView.alpha = selected? 1.0f: 0.0f;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    self.carousel.currentItemIndex = selectedIndex;
}

- (NSUInteger)selectedIndex
{
    return self.carousel.currentItemIndex;
}

- (IBAction)dismissKeyboard
{
    [self.inputField resignFirstResponder];
}

- (IBAction)reloadData
{
    //update currencies
    NSMutableArray *currencies = [NSMutableArray array];
    if ([[Currencies sharedInstance].enabledCurrencies count])
    {
        while ([currencies count] < 6)
        {
            [currencies addObjectsFromArray:[Currencies sharedInstance].enabledCurrencies];
        }
    }
    else
    {
        while ([currencies count] < 6)
        {
            [currencies addObject:[Currency nullCurrency]];
        }
    }
    self.currencies = currencies;
    
    //reload cells
    if (self.carousel.numberOfItems == [self numberOfItemsInCarousel:self.carousel])
    {
        [self.carousel.indexesForVisibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.carousel reloadItemAtIndex:[obj integerValue] animated:NO];
        }];
    }
    else
    {
        [self.carousel reloadData];
    }
    
    //update selected currency
    Currency *oldCurrency = self.currency;
    [self updateCurrency];
    
    //scroll to previously selected currency (if appropriate)
    NSInteger index = [self.currencies indexOfObject:oldCurrency];
    if (index != NSNotFound && oldCurrency != self.currencies[self.carousel.currentItemIndex])
    {
        [self.carousel scrollToItemAtIndex:index animated:NO];
    }
}

- (void)updateCurrency
{
    _currency = [self.currencies count]? self.currencies[self.selectedIndex]: nil;
}

- (void)setCurrencyValue:(double)currencyValue
{
    [self setCurrencyValue:currencyValue updateField:YES];
}

- (void)setCurrencyValue:(double)currencyValue updateField:(BOOL)update
{
    if (_currencyValue != currencyValue)
    {
        _currencyValue = currencyValue;
        if (update && self.selected) self.inputField.doubleValue = _currencyValue;
        [self reloadData];
    }
}

- (void)setValue:(double)value forCurrency:(Currency *)currency
{
    self.currencyValue = [currency value:value convertedToCurrency:self.currency];
}

- (BOOL)resignFirstResponder
{
    return [self.inputField resignFirstResponder];
}

- (void)textDidChange
{
    [self setCurrencyValue:[self.inputField.text doubleValue] updateField:NO];
    [self.delegate pickerViewValueDidChange:self];
}

- (void)textFieldDidBeginEditing:(NumberField *)textField
{
    self.selected = YES;
    [textField performSelectorOnMainThread:@selector(selectAll:) withObject:nil waitUntilDone:NO];
     
    [self.delegate pickerViewDidAcceptFirstResponder:self inputField:self.inputField];
}

- (BOOL)textFieldShouldReturn:(NumberField *)textField
{
    [self resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(NumberField *)textField
{
    textField.doubleValue = textField.doubleValue;
    self.currencyValue = textField.doubleValue;
    [self.delegate pickerViewValueDidChange:self];
    [self.delegate pickerViewDidResignFirstResponder:self];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.currencies count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(PickerCellView *)view
{
    if (!view)
    {
        view = [[[PickerCellView nib] instantiateWithOwner:self options:nil] firstObject];
    }
    
    Currency *currency = self.currencies[index];
    double value = [self.currency value:self.currencyValue convertedToCurrency:currency];
    [view configureWithCurrency:currency value:value];

    view.width = self.spacerView.width;
    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    Currency *oldCurrency = self.currency;
    [self updateCurrency];
    
    if (self.selected)
    {
        [self.delegate pickerViewValueDidChange:self];
        [self.carousel.indexesForVisibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.carousel reloadItemAtIndex:[obj integerValue] animated:NO];
        }];
    }
    else
    {
        self.currencyValue = [oldCurrency value:self.currencyValue convertedToCurrency:self.currency];
    }
    [self.delegate pickerViewCurrencyDidChange:self];
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index
{
    return NO;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionCount:
        {
            return 16;
        }
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMax:
        {
            return 0.0f;
        }
        case iCarouselOptionFadeRange:
        {
            return 2.5f;
        }
        default:
        {
            return value;
        }
    }
}

@end
