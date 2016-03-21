//
//  ViewController.h
//  KVODemo
//
//  Created by whc on 15/8/4.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookPublishLabel;

@property (weak, nonatomic) IBOutlet UITextField *setNameTF;

@property (weak, nonatomic) IBOutlet UITextField *setPriceTF;

@property (weak, nonatomic) IBOutlet UITextField *setPublistTF;

- (IBAction)sureClick:(id)sender;

@end

