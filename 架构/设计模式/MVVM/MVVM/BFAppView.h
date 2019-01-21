//
//  BFAppView.h
//  MVVM
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BFAppView, BFAppViewModel;

@protocol BFAppViewDelegate <NSObject>
@optional
- (void)appViewDidClick:(BFAppView *)appView;
@end

@interface BFAppView : UIView
@property (weak, nonatomic) BFAppViewModel *viewModel;
@property (weak, nonatomic) id<BFAppViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
