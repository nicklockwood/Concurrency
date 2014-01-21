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

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *footer;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, copy) NSArray *currencies;
@property (nonatomic, copy) NSString *searchString;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.hidden = YES; //hide control initially
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    //set up data
    [self update];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //show refresh control as soon as scrolling begins
    self.refreshControl.hidden = NO;
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
