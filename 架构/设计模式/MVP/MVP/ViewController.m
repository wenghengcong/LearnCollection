//
//  ViewController.m
//  MVP
//
//  Created by WengHengcong on 2019/1/18.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPersonPresenter.h"

@interface ViewController ()
@property (nonatomic, strong) BFPersonPresenter *presenter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.presenter = [[BFPersonPresenter alloc] initWithCotroller:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.presenter tableView:self.tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [self.presenter tableView:self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.presenter tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}
@end

