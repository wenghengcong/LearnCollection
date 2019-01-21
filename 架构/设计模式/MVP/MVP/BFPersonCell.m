//
//  BFPersonCell.m
//  MVP
//
//  Created by WengHengcong on 2019/1/21.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPersonCell.h"

@implementation BFPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setName:(NSString *)name age:(int)age
{
    self.textLabel.text = name;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%d", age];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedPerson:)]) {
        [self.delegate didSelectedPerson:self];
    }
}

@end
