//
//  ViewController.m
//  MVC-Apple
//
//  Created by WengHengcong on 2019/1/18.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"
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
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", person.age];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > _personsData.count) return;
    BFPerson *person = _personsData[indexPath.row];
    NSLog(@"select person: %@ %d", person.name, person.age);
}


@end
