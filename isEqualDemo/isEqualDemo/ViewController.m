//
//  ViewController.m
//  isEqualDemo
//
//  Created by WengHengcong on 4/12/16.
//  Copyright © 2016 WengHengcong. All rights reserved.
//

#import "ViewController.h"
#import "JSAnimal.h"
#import "JSDog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self testNSStringIsEqual];
//    [self testClassIsEqualWitiNoOverride];
    [self testCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testNSStringIsEqual
{
    NSString *foo = @"Badger 123";
    NSString *bar = [NSString stringWithFormat:@"Badger %i",123];
    NSString *bar2 = [NSString stringWithFormat:@"Badger 123"];
    
    BOOL equalA = (foo == bar);
    BOOL equalB = [foo isEqual:bar];
    BOOL equalC = [foo isEqualToString:bar];
    
    BOOL equalD = [bar isEqual:bar2];
    BOOL equalE = [bar isEqualToString:bar2];
    
    NSLog(@"NSString:%d-%d-%d-%d-%d",equalA,equalB,equalC,equalD,equalE);   //NO,YES,YES
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>]
    [dic setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>]
}

- (void)testClassIsEqualWitiNoOverride
{
    //以下比较鉴于未重写isEqaual:方法
    JSAnimal *ani = [[JSAnimal alloc]init];

    JSDog *dog = [[JSDog alloc]init];
    dog.age = 3;
    dog.name = @"haha";
    dog.weight = 14;
    dog.furColor = @"red";

    BOOL equalA = (ani == dog);
    BOOL equalB = [ani isEqual:dog];
    
    NSLog(@"Class:%d-%d",equalA,equalB);    //NO,NO

    JSDog *anotherDog = dog;
    BOOL equalC = (anotherDog == dog);
    BOOL equalD = [anotherDog isEqual:dog];
    NSLog(@"Class:%d-%d",equalC,equalD);    //YES,YES
    
    
    JSDog *reallyAnotherDog = [[JSDog alloc]init];
    reallyAnotherDog.age = 3;
    reallyAnotherDog.name = @"haha";
    reallyAnotherDog.weight = 14;
    reallyAnotherDog.furColor = @"red";
 
    BOOL equalE = (reallyAnotherDog == dog);
    BOOL equalF = [reallyAnotherDog isEqual:dog];
    NSLog(@"Class:%d-%d",equalE,equalF);    //NO,NO
    
}

- (void)testClassIsEqualWitiOverride
{
    //以下比较鉴于未重写isEqaual:方法
    JSAnimal *ani = [[JSAnimal alloc]init];
    
    JSDog *dog = [[JSDog alloc]init];
    dog.age = 3;
    dog.name = @"haha";
    dog.weight = 14;
    dog.furColor = @"red";
    
    BOOL equalA = (ani == dog);
    BOOL equalB = [ani isEqual:dog];
    
    NSLog(@"Class:%d-%d",equalA,equalB);    //NO,NO
    
    JSDog *anotherDog = dog;
    BOOL equalC = (anotherDog == dog);
    BOOL equalD = [anotherDog isEqual:dog];
    NSLog(@"Class:%d-%d",equalC,equalD);    //YES,YES
    
    
    JSDog *reallyAnotherDog = [[JSDog alloc]init];
    reallyAnotherDog.age = 3;
    reallyAnotherDog.name = @"haha";
    reallyAnotherDog.weight = 14;
    reallyAnotherDog.furColor = @"red";
    
    BOOL equalE = (reallyAnotherDog == dog);
    BOOL equalF = [reallyAnotherDog isEqual:dog];
    NSLog(@"Class:%d-%d",equalE,equalF);    //NO,YES

    //注意：假如furColor dog和reallyAnotherDog都是nil，那么nil和nil是不相等的，所以重写的时候要注意这种情况；
}

- (void)testCollection
{
    NSMutableSet *set = [NSMutableSet set];
    
    //1.
    NSMutableArray *arrayA = [@[@1,@2] mutableCopy];
    [set addObject:arrayA];
    NSLog(@"set = %@",set);
    
    //2.
    NSMutableArray *arrayB = [@[@1,@2] mutableCopy];
    [set addObject:arrayB];
    NSLog(@"set = %@",set);
    
    //3.
    NSMutableArray *arrayC = [@[@1] mutableCopy];
    [set addObject:arrayC];
    NSLog(@"set = %@",set);
    
    //4.
    [arrayC addObject:@2];
    NSLog(@"set = %@",set);

    //5.
    NSSet *setB = [set copy];
    NSLog(@"setB = %@",setB);

}

@end
