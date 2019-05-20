//
//  DetailViewController.m
//  LifeCycle
//
//  Created by WengHengcong on 3/3/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

#pragma mark- life cycle

- (void)loadView {
    
    [super loadView];
    NSLog(@"DetailVC loadView");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    NSLog(@"DetailVC viewDidLoad");

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"MasterVC init");
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"DetailVC viewWillAppear");

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSLog(@"DetailVC viewDidAppear");

}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
//    NSLog(@"DetailVC viewWillLayoutSubviews");

}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
//    NSLog(@"DetailVC viewDidLayoutSubviews");

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    NSLog(@"DetailVC viewWillDisappear");
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    NSLog(@"DetailVC viewDidDisappear");
    
}

- (void)viewWillUnload {
    
    [super viewWillUnload];
    NSLog(@"DetailVC viewWillUnload");

}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    NSLog(@"DetailVC viewDidUnload");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"DetailVC didReceiveMemoryWarning");

}

@end
