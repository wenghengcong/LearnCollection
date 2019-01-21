//
//  BFPersonPresenter.h
//  MVP
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 主要承担MVC中C的职责
 1. 进行数据获取，获取后渲染视图
 2. 监听视图的操作（点击、触摸等），并且对Model进行更改
 3. 针对Controll中的逻辑，进行封装
 */
@interface BFPersonPresenter : NSObject

- (instancetype)initWithCotroller:(UITableViewController *)controller;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
