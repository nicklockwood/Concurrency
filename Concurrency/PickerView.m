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
@property (nonatomic, weak) IBOutlet iCarousel *carousel;
@property (nonatomic, weak) IBOutlet UITextField *inputField;
@property (nonatomic, weak) IBOutlet UIView *overlayView;

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

- (void)textDidChange
{
    [self setValue:[self.inputField.text doubleValue] forCurrency:self.currency];
    [self.delegate pickerViewValueDidChange:self];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected)
    {
        double value = [self.currency valueFromEuros:self.euroValue];
        self.inputField.text = [NSString stringWithFormat:@"%0.2f", value];
    }
    [self.overlayView crossfadeWithDuration:0.4 completion:^{
        
        if (!selected)
        {
            self.inputField.text = @"";
        }
    }];
    self.overlayView.alpha = selected? 1.0f: 0.0f;
}

- (IBAction)dismissKeyboard
{
    [self.inputField resignFirstResponder];
}

- (IBAction)reloadData
{
    Currency *currency = self.currency;
    
    NSMutableArray *currencies = [NSMutableArray array];
    if ([[Currencies sharedInstance].enabledCurrencies count])
    {
        while ([currencies count] < 6)
        {
            [currencies addObjectsFromArray:[Currencies sharedInstance].enabledCurrencies];
        }
    }
    self.currencies = currencies;
    
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
    
    NSInteger index = [self.currencies indexOfObject:currency];
    if (index != NSNotFound && currency != self.currencies[self.carousel.currentItemIndex])
    {
        [self.carousel scrollToItemAtIndex:index animated:NO];
    }
}

- (Currency *)currency
{
    return [self.currencies count]? self.currencies[self.carousel.currentItemIndex]: nil;
}

- (void)setValue:(double)value forCurrency:(Currency *)currency
{
    self.euroValue = [currency valueInEuros:value];
}

- (void)setEuroValue:(double)euroValue
{
    if (_euroValue != euroValue)
    {
        _euroValue = euroValue;
        [self reloadData];
    }
}

- (BOOL)resignFirstResponder
{
    return [self.inputField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.selected = YES;
    [textField performSelectorOnMainThread:@selector(selectAll:) withObject:nil waitUntilDone:NO];
     
    [self.delegate pickerViewDidAcceptFirstResponder:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setValue:[textField.text doubleValue] forCurrency:self.currency];
    textField.text = [NSString stringWithFormat:@"%0.2f", [textField.text doubleValue]];
    [self.delegate pickerViewValueDidChange:self];
    [self.delegate pickerViewDidResignFirstResponder:self];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.currencies count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(PickerCellView *)view
{
    if (!view)
    {
        view = [[PickerCellView nib] instantiateWithOwner:self options:nil][0];
    }
    
    Currency *currency = self.currencies[index];
    double value = [currency valueFromEuros:self.euroValue];
    [view configureWithCurrency:currency value:value];

    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (self.selected)
    {
        [self setValue:[self.inputField.text doubleValue] forCurrency:self.currency];
        [self.delegate pickerViewValueDidChange:self];
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
