//
//  FirstViewController.m
//  JLRoutes
//
//  Created by 翁恒丛 on 2018/10/24.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "FirstViewController.h"
#import "JLRoutes.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)touchAction:(id)sender {
    
    //匹配/user/view/:userID"
    NSURL *viewUserURL = [NSURL URLWithString:@"myapp://user/view/joeldev"];
    [JLRoutes routeURL:viewUserURL];
    
    //匹配/user/view/:userID"
    NSURL *viewUserURL1 = [NSURL URLWithString:@"abtest://user/view/joeldev"];
    [JLRoutes routeURL:viewUserURL1];
    
    //匹配/user/view/:userID"
    NSURL *viewUserURL2 = [NSURL URLWithString:@"/user/view/joeldev"];
    [JLRoutes routeURL:viewUserURL2];
    
    //不匹配/user/view/:userID"
    NSURL *viewUserURL3 = [NSURL URLWithString:@"myapp://user/good/joeldev"];
    [JLRoutes routeURL:viewUserURL3];
}

@end
