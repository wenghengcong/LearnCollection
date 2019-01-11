//
//  DetailViewController.h
//  UICollectionViewLearn
//
//  Created by WengHengcong on 2016/11/8.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

