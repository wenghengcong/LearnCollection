//
//  BFPersonCell.m
//  MVC-Apple
//
//  Created by WengHengcong on 2019/1/18.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "BFPersonCell.h"

@implementation BFPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPerson:(BFPerson *)person
{
    _person = person;
    self.textLabel.text = _person.name;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%d", _person.age];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
