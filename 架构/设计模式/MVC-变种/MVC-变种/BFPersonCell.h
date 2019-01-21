//
//  BFPersonCell.h
//  MVC-Apple
//
//  Created by WengHengcong on 2019/1/18.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPerson.h"

NS_ASSUME_NONNULL_BEGIN

@class BFPersonCell, BFPerson;

@protocol BFPersonCellDelegate <NSObject>
@optional
- (void)didSelectedPerson:(BFPersonCell *)cell;
@end

@interface BFPersonCell : UITableViewCell

@property (nonatomic, strong) BFPerson *person;
@property (nonatomic, weak) id delegate;

@end

NS_ASSUME_NONNULL_END
