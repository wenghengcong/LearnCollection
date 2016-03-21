//
//  DetailViewController.h
//  LearnCollection
//
//  Created by WengHengcong on 3/21/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

