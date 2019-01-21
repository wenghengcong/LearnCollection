//
//  BFAppViewModel.m
//  MVVM
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFAppViewModel.h"
#import "BFApp.h"
#import "BFAppView.h"

@interface BFAppViewModel() <BFAppViewDelegate>

/**
 注意：标记为weak，否则会产生循环引用
 */
@property (weak, nonatomic) UIViewController *controller;

/**
 view model里面的属性和model里一致
 */
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *image;
@end

@implementation BFAppViewModel

- (instancetype)initWithController:(UIViewController *)controller
{
    if (self = [super init]) {
        self.controller = controller;
        
        // 创建View
        BFAppView *appView = [[BFAppView alloc] init];
        appView.frame = CGRectMake(100, 100, 100, 150);
        appView.delegate = self;
        appView.viewModel = self;
        [controller.view addSubview:appView];
        
        // 加载模型数据
        BFApp *app = [[BFApp alloc] init];
        app.name = @"QQ";
        app.image = @"QQ";
        
        // 设置数据，一旦设置，view就会更新，因为view监听了viewmodel的相关属性的改变
        self.name = app.name;
        self.image = app.image;
    }
    return self;
}

#pragma mark - MJAppViewDelegate
- (void)appViewDidClick:(BFAppView *)appView
{
    NSLog(@"viewModel 监听了 appView 的点击");
}

@end
