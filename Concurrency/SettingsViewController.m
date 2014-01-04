//
//  SettingsViewController.m
//  CurrencyConverter
//
//  Created by Nick Lockwood on 30/06/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "SettingsViewController.h"
#import "Currencies.h"
#import "CurrencyCell.h"
#import "ViewUtils.h"


@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UILabel *footer;
@property (nonatomic, copy) NSArray *currencies;
@property (nonatomic, copy) NSString *searchString;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        
        //yuck! this horrible hack is needed to avoid a jitter during wiggle animation
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.tableView.contentOffset = CGPointMake(0, -20);
        });
    }
    
    self.tableView.tableFooterView = self.footer;
    [self update];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyCell *cell = [CurrencyCell dequeueInstanceWithTableView:tableView];
    [cell configureWithCurrency:self.currencies[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Currency *currency = self.currencies[indexPath.row];
    currency.enabled = !currency.enabled;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [currency save];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchString = searchText;
    [self update];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    [[Currencies sharedInstance] updateWithBlock:^{
        [self update];
    }];
}
     
- (void)update
{
    self.currencies = [[Currencies sharedInstance] currenciesMatchingSearchString:self.searchString];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    [self updateFooter];
}

- (void)updateFooter
{
    static NSDateFormatter *formatter = nil;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterMediumStyle;
    }
    
    NSString *date = [formatter stringFromDate:[Currencies sharedInstance].lastUpdated];
    self.footer.text = [NSString stringWithFormat:@"Last Updated: %@", date];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![touch.view isSubviewOfView:self.tableView.tableHeaderView])
    {
        [self.tableView.tableHeaderView resignFirstResponder];
    }
    return NO;
}

@end
