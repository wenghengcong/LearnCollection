//
//  ViewController.m
//  CopyLearn
//
//  Created by WengHengcong on 18/08/2017.
//  Copyright © 2017 JS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.

    

    
        //    NSMutableArray *mArray = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        //    NSArray *arrayCppy = [mArray copy];
        //    NSLog(@"mArray:%p recount: %ld",mArray ,[mArray retainCount]);
        //    NSLog(@"array:%p recount: %ld",arrayCppy,[arrayCppy retainCount]);
        //    NSLog(@"object of mArray[0]:%p ,retaincount:%ld",mArray[0],[mArray[0] retainCount]);
        //    NSLog(@"object of arrayCopy[0]:%p ,retaincount:%ld",arrayCppy[0],[arrayCppy[0] retainCount]);
    
        //    NSMutableArray *mArray = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        //    NSMutableArray *mMArrayCopy = [mArray mutableCopy];
        //    NSLog(@"mArray:%p recount: %ld",mArray ,[mArray retainCount]);
        //    NSLog(@"mMArrayCopy:%p recount: %ld",mMArrayCopy,[mMArrayCopy retainCount]);
        //    NSLog(@"object of mArray[0]:%p ,retaincount:%ld",mArray[0],[mArray[0] retainCount]);
        //    NSLog(@"object of mMArrayCopy[0]:%p ,retaincount:%ld",mMArrayCopy[0],[mMArrayCopy[0] retainCount]);
        //
    
        //    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        //    NSArray *deepCopyArray=[[NSArray alloc] initWithArray:array copyItems:YES];
        //    NSLog(@"array:%p recount: %ld",array ,[array retainCount]);
        //    NSLog(@"deepCopyArray:%p recount: %ld",deepCopyArray,[deepCopyArray retainCount]);
        //    NSLog(@"object of array[0]:%p ,retaincount:%ld",array[0],[array[0] retainCount]);
        //    NSLog(@"object of deepCopyArray[0]:%p ,retaincount:%ld",deepCopyArray[0],[deepCopyArray[0] retainCount]);
        //
        //    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        //    NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData: [NSKeyedArchiver archivedDataWithRootObject:array]];
        //    NSLog(@"array:%p recount: %ld",array ,[array retainCount]);
        //    NSLog(@"trueDeepCopyArray:%p recount: %ld",trueDeepCopyArray,[trueDeepCopyArray retainCount]);
        //    NSLog(@"object of array[0]:%p ,retaincount:%ld",array[0],[array[0] retainCount]);
        //    NSLog(@"object of trueDeepCopyArray[0]:%p ,retaincount:%ld",trueDeepCopyArray[0],[trueDeepCopyArray[0] retainCount]);
    [self constantCopy];
    
}

- (void)constantCopy {
        //    NSString *str = [NSString stringWithFormat:@"123"];
        //    NSString *cpstr = [str copy];//浅拷贝，str:123 ,cpstr:123
        //    cpstr = @"12345";
        //    NSLog(@"STR:%@ address %p recount = %ld",str,str,[str retainCount]);
        //    NSLog(@"CPstr:%@ address %p recount = %ld",cpstr,cpstr,[cpstr retainCount]);
        //
        //    NSString *str = [NSString stringWithFormat:@"123"];
        //    NSMutableString *cpstr = [str mutableCopy];//深拷贝，str:1 ,cpstr:15
        //    NSLog(@"STR:%@ address %p recount = %ld",str,str,[str retainCount]);
        //    NSLog(@"CPstr:%@ address %p recount = %ld",cpstr,cpstr,[cpstr retainCount]);
    
        //    NSMutableString *str = [NSMutableString stringWithFormat:@"123"];
        //    NSString *cpstr = [str copy];//深拷贝，str:123 ,cpstr:123
        //    NSLog(@"STR:%@ address %p recount = %ld",str,str,[str retainCount]);
        //    NSLog(@"CPstr:%@ address %p recount = %ld",cpstr,cpstr,[cpstr retainCount]);
    
        //    NSMutableString *str = [NSMutableString stringWithFormat:@"123"];
        //    NSMutableString *str = @"123";
        //    NSMutableString *cpstr = [str mutableCopy];//深拷贝，str:123 ,cpstr:123
        //    [cpstr insertString:@"0" atIndex:0];
        //    NSLog(@"STR:%@ address %p recount = %ld",str,str,[str retainCount]);
        //    NSLog(@"CPstr:%@ address %p recount = %ld",cpstr,cpstr,[cpstr retainCount]);
    
    
        //copy返回不可变对象，mutablecopy返回可变对象
//    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
//    NSArray *arrayCopy = [array copy];
//        //arrayCopy1是和array同一个NSArray对象（指向相同的对象），包括array里面的元素也是指向相同的指针
//    NSLog(@"object of array[0]:%p ,retaincount:%ld",array[1],[array[1] retainCount]);
//    NSLog(@"object of arrayCopy[0]:%p ,retaincount:%ld",arrayCopy[1],[arrayCopy[1] retainCount]);
    
        //        NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        //        NSMutableArray *mArrayCopy = [array mutableCopy];
        //        //mArrayCopy是array的可变副本，指向的对象和array不同，但是其中的元素和array1中的元素指向的是同一个对象。mArrayCopy还可以修改自己的对象
        //        NSLog(@"object of array[0]:%p ,retaincount:%ld",array[1],[array[1] retainCount]);
        //        NSLog(@"object of mArrayCopy[0]:%p ,retaincount:%ld",mArrayCopy[1],[mArrayCopy[1] retainCount]);
    
        //        NSMutableArray *mArray = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        //        NSArray *arrayCppy = [mArray copy];
        //        NSLog(@"object of mArray[0]:%p ,retaincount:%ld",mArray[1],[mArray[1] retainCount]);
        //        NSLog(@"object of arrayCopy[0]:%p ,retaincount:%ld",arrayCppy[1],[arrayCppy[1] retainCount]);
    
        //        NSMutableArray *mArray = [NSMutableArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
        //        NSMutableArray *mMArrayCopy = [mArray mutableCopy];
        //        NSLog(@"object of mArray[0]:%p ,retaincount:%ld",mArray[1],[mArray[1] retainCount]);
        //        NSLog(@"object of mMArrayCopy[0]:%p ,retaincount:%ld",mMArrayCopy[1],[mMArrayCopy[1] retainCount]);
        //
//    
//    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@[@"b"],@"c",nil];
//    NSArray *deepCopyArray=[[NSArray alloc] initWithArray:array copyItems:YES];
//    NSLog(@"array:%p recount: %ld",array ,[array retainCount]);
//    NSLog(@"deepCopyArray:%p recount: %ld",deepCopyArray,[deepCopyArray retainCount]);
//    NSLog(@"object of array[0]:%p ,retaincount:%ld",array[0],[array[0] retainCount]);
//    NSLog(@"object of deepCopyArray[0]:%p ,retaincount:%ld",deepCopyArray[0],[deepCopyArray[0] retainCount]);
//    NSLog(@"object of array[1]:%p ,retaincount:%ld",array[1],[array[1] retainCount]);
//    NSLog(@"object of deepCopyArray[1]:%p ,retaincount:%ld",deepCopyArray[1],[deepCopyArray[1] retainCount]);
    
    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
    NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData: [NSKeyedArchiver archivedDataWithRootObject:array]];
    NSLog(@"array:%p recount: %ld",array ,[array retainCount]);
    NSLog(@"trueDeepCopyArray:%p recount: %ld",trueDeepCopyArray,[trueDeepCopyArray retainCount]);
    NSLog(@"object of array[0]:%p ,retaincount:%ld",array[0],[array[0] retainCount]);
    NSLog(@"object of trueDeepCopyArray[0]:%p ,retaincount:%ld",trueDeepCopyArray[0],[trueDeepCopyArray[0] retainCount]);
    NSLog(@"object of array[1]:%p ,retaincount:%ld",array[1],[array[1] retainCount]);
    NSLog(@"object of trueDeepCopyArray[1]:%p ,retaincount:%ld",trueDeepCopyArray[1],[trueDeepCopyArray[1] retainCount]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end
