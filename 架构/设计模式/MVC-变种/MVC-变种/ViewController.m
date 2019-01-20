//
//  ViewController.m
//  MVC-变种
//
//  Created by WengHengcong on 2019/1/18.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPersonCell.h"

@interface ViewController ()
{
    NSMutableArray *_personsData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPersonsData];
}

- (void)loadPersonsData
{
    _personsData = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        BFPerson *person = [[BFPerson alloc] init];
        person.name = [NSString stringWithFormat:@"%@", [self randomString]];
        person.age = i + 10;
        [_personsData addObject:person];
    }
    
    //reload view
    [self.tableView reloadData];
}

- (NSString *)randomString
{
    int kNumber = arc4random() % 10 + 2;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = arc4random() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"personCell";
    BFPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BFPersonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    BFPerson *person = _personsData[indexPath.row];
    //下面两句，就是与MVC-Apple版本最大的区别
//    cell.textLabel.text = person.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", person.age];
    
    // MVC变种，将打破Controller进行Model与View之间的唯一中间人
    // View将拥有Model，这一举措将会减轻C的负担，同时也会增加耦合
    cell.person = person;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > _personsData.count) return;
    BFPerson *person = _personsData[indexPath.row];
    NSLog(@"select person: %@ %d", person.name, person.age);
}


@end

