//
//  SampleTableViewController.m
//  DRPLoadingSpinner
//
//  Created by Justin Hill on 10/15/16.
//  Copyright © 2016 Justin Hill. All rights reserved.
//

#import "SampleTableViewController.h"
#import "DRPRefreshControl.h"

NSString * const ReuseIdentifier = @"ReuseIdentifier";

@interface SampleTableViewController ()

@property (strong) DRPRefreshControl *drpRefreshControl;

@end

@implementation SampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak SampleTableViewController *weakSelf = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
    self.drpRefreshControl = [[DRPRefreshControl alloc] init];
    [self.drpRefreshControl addToTableViewController:self refreshBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.drpRefreshControl endRefreshing];
        });
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[[NSNumberFormatter alloc] init] stringFromNumber:@(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.drpRefreshControl beginRefreshing];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
