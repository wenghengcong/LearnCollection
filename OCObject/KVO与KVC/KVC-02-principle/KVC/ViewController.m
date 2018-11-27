//
//  ViewController.m
//  KVC
//
//  Created by WengHengcong on 2018/11/27.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "BFPerson.h"
#import "BFBook.h"

@interface ViewController ()

@property (nonatomic, strong) BFPerson *person;

@property (nonatomic, strong) BFBook *book;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.book = [[BFBook alloc] init];
    self.person = [[BFPerson alloc] init];

    [self setValue];
    [self getValue];
}

- (void)setValue
{
    //setValue
    [self.person setValue:@"weng" forKey:@"name"];
    [self.person setValue:@(28) forKey:@"age"];
    [self.person setValue:self.book forKey:@"book"];
    
    [self.person setValue:@"iOS Hole" forKeyPath:@"book.title"];
    [self.book setValue:@(11232322029) forKeyPath:@"publishTime"];
    [self.person setValue:self.book forKeyPath:@"book"];
    
    NSLog(@"person: name - %@, age - %ld",
          self.person.name,
          (long)self.person.age);
    NSLog(@"person's book：book title - %@, book publictate time - %f",
          self.person.book.title,
          self.person.book.publishTime
          );
}

- (void)getValue
{
    NSString *personName = [self.person valueForKey:@"name"];
    NSInteger personAge = [[self.person valueForKeyPath:@"age"] integerValue];
    
    BFBook *book = [self.person valueForKey:@"book"];
    NSString *bookTitle1 = [book valueForKeyPath:@"title"];
    NSString *bookTitle2 = [self.person valueForKeyPath:@"book.title"];
    
    double publishTime1 = [[book valueForKey:@"publishTime"] doubleValue];
    double publishTime2 = [[self.person valueForKeyPath:@"book.publishTime"] doubleValue];
    
    NSLog(@"personName: %@, age: %lu", personName, personAge);
    
    NSLog(@"book title: %@ %@, publish time: %f %f",
          bookTitle1, bookTitle2,
          publishTime1, publishTime2
          );
}

@end
