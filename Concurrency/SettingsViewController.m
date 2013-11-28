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


@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *footer;

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
    }
    
    [self.tableView registerNib:[CurrencyCell nib] forCellReuseIdentifier:[CurrencyCell reuseIdentifier]];
    self.tableView.tableFooterView = self.footer;
    [self updateFooter];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Currencies sharedInstance].allCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[CurrencyCell reuseIdentifier] forIndexPath:indexPath];
    [cell configureWithCurrency:[Currencies sharedInstance].allCurrencies[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Currency *currency = [Currencies sharedInstance].allCurrencies[indexPath.row];
    currency.enabled = !currency.enabled;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [currency save];
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

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    [[Currencies sharedInstance] updateWithBlock:^{
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        [self updateFooter];
    }];
}

@end
