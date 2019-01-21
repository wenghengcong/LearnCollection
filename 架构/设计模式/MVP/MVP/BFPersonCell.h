//
//  BFPersonCell.h
//  MVP
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BFPersonCell, BFPerson;

@protocol BFPersonCellDelegate <NSObject>
@optional
- (void)didSelectedPerson:(BFPersonCell *)cell;
@end


/**
 要解除与Model的耦合，此处只能通过特定的传入进行渲染
 */
@interface BFPersonCell : UITableViewCell

- (void)setName:(NSString *)name age:(int)age;
@property (nonatomic, weak) id delegate;
@end

NS_ASSUME_NONNULL_END
