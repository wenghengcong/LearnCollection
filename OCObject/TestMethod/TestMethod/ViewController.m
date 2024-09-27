//
//  ViewController.m
//  TestMethod
//
//  Created by Nemo on 2024/9/21.
//

#import "ViewController.h"
#import "TestMethod.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     <NSMethodSignature: 0x8f177d05a62f079f>
         number of arguments = 3
         frame size = 224
         is special struct return? NO
         return value: -------- -------- -------- --------
             type encoding (v) 'v'
             flags {}
             modifiers {}
             frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
             memory {offset = 0, size = 0}
         argument 0: -------- -------- -------- --------
             type encoding (@) '@'
             flags {isObject}
             modifiers {}
             frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
             memory {offset = 0, size = 8}
         argument 1: -------- -------- -------- --------
             type encoding (:) ':'
             flags {}
             modifiers {}
             frame {offset = 8, offset adjust = 0, size = 8, size adjust = 0}
             memory {offset = 0, size = 8}
         argument 2: -------- -------- -------- --------
             type encoding (d) 'd'
             flags {isFloat}
             modifiers {}
             frame {offset = 80, offset adjust = 0, size = 16, size adjust = -8}
             memory {offset = 0, size = 8}
     */
    NSMethodSignature *floatSin = [[TestMethod class] instanceMethodSignatureForSelector:@selector(testFloat:)];
    /*
     <NSMethodSignature: 0x8f177d05a62f47c7>
         number of arguments = 3
         frame size = 224
         is special struct return? NO
         return value: -------- -------- -------- --------
             type encoding (v) 'v'
             flags {}
             modifiers {}
             frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
             memory {offset = 0, size = 0}
         argument 0: -------- -------- -------- --------
             type encoding (@) '@'
             flags {isObject}
             modifiers {}
             frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
             memory {offset = 0, size = 8}
         argument 1: -------- -------- -------- --------
             type encoding (:) ':'
             flags {}
             modifiers {}
             frame {offset = 8, offset adjust = 0, size = 8, size adjust = 0}
             memory {offset = 0, size = 8}
         argument 2: -------- -------- -------- --------
             type encoding (q) 'q'
             flags {isSigned}
             modifiers {}
             frame {offset = 16, offset adjust = 0, size = 8, size adjust = 0}
             memory {offset = 0, size = 8}
     */
    NSMethodSignature *intSig = [[TestMethod class] instanceMethodSignatureForSelector:@selector(testInt:)];
    
    NSLog(@"%@", floatSin);
    NSLog(@"%@", intSig);

    TestMethod *testM = [[TestMethod alloc] init];
    [testM testFloat:33];
    [testM testInt:22];
    
    SEL floatSEL = @"";
}


@end
