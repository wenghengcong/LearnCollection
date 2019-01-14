//
//  UIPickerViewUsage.m
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/9.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "UIPickerViewUsage.h"

@interface UIPickerViewUsage()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,strong)NSArray                *priceArr;  //double
@property (nonatomic,strong)UIPickerView            *pricePickerView;

@end

@implementation UIPickerViewUsage

static CGFloat pickerViewH = 200;

#pragma mark- pickerview
/***  创建pickerView*/
- (void)pvu_creatPickView{
    
    [JSBDeviceInfo screenWidth];
    self.pricePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,320-pickerViewH, 320, pickerViewH)];
    //    self.pricePickerView.backgroundColor = [UIColor redColor];
    self.pricePickerView.delegate = self;
    self.pricePickerView.dataSource = self;
    self.pricePickerView.showsSelectionIndicator = YES;
    self.pricePickerView.hidden = YES;
    [self.view addSubview:self.pricePickerView];
    
}
/***  选择后更新对应的显示view*/
- (void)pvu_updatePriceLabelWith:(CGFloat)price {
    
}

/***  重载pickerview*/
- (void)pvu_reloadPickerView {
    
    [self.pricePickerView reloadAllComponents];
}

#pragma mark- UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.priceArr.count;
}



#pragma mark- UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *priceStr = self.priceArr[row];
    return priceStr;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *attriDit = [NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName,[UIColor blueColor], nil];
    NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"0.01" attributes:attriDit];
    return str;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dic = self.priceArr[row];
    CGFloat price = [[[dic allValues]firstObject] floatValue];
    self.pricePickerView.hidden = YES;
    
    [self pvu_updatePriceLabelWith:price];

}

@end
