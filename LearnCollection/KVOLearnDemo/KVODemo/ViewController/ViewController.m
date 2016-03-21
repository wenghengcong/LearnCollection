//
//  ViewController.m
//  KVODemo
//
//  Created by whc on 15/8/4.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Book.h"
#import "SetterValueObject.h"

@interface ViewController ()

@property (strong ,nonatomic)Person         *MrWeng;
@property (strong ,nonatomic)Book           *book;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.setPriceTF.keyboardType  = UIKeyboardTypeNumberPad;
    
    
    //set value
    self.MrWeng = [[Person alloc]init];
    self.book = [[Book alloc]init];

    [self.MrWeng setValue:self.book forKey:@"book"];
    //复合路径用setValue:forKeyPath:
    [self.MrWeng setValue:@"维基百科" forKeyPath:@"book.bookName"];
    [self.book setValue:@"10000" forKey:@"price"];
    [self.book setValue:[NSDate date] forKey:@"publishTime"];
    
    //value for key
    self.bookNameLabel.text = [self.book valueForKey:@"bookName"];
    self.bookPriceLabel.text = [[self.book valueForKey:@"price"] stringValue];
    NSDate *publishDate = [self.book valueForKey:@"publishTime"];
    self.bookPublishLabel.text = [NSString stringWithFormat:@"%@",publishDate];
    
    //value的搜索顺序
    //不管是读取getter还是setter，均按照：setter(getter)-> _name变量 -> name变量
    SetterValueObject *testSetterValueOreder =  [[SetterValueObject alloc]init];
    [testSetterValueOreder setValue:@"namevalue" forKey:@"name"];
//    NSLog(@"name:%@ \n_name:%@",testSetterValueOreder->name,testSetterValueOreder->_name);

    //键值监听,我很关心价格，价格一变，立即提醒
    [self.book  addObserver:self forKeyPath:@"price" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //触发监听方法
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"价格变了" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)sureClick:(id)sender {
    
    [self.view resignFirstResponder];
    [self.setPriceTF resignFirstResponder];
    [self.setNameTF resignFirstResponder];
    [self.setPublistTF resignFirstResponder];
    
    //此处改变价格
    NSString *priceText = self.setPriceTF.text;
    self.book.price = [priceText integerValue];
}

- (void)dealloc {
    /**
     *  移除监听
     */
    [self.book removeObserver:self forKeyPath:@"price"];
    
}


@end
