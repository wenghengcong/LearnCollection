//
//  the time in words.c
//  Challenges
//
//  Created by whc on 15/5/12.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#include "the time in words.h"

/*  NSArray *hours = [NSArray arrayWithObjects:@"zero",@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine",@"ten",@"eleven",@"twelve", nil];
 
 NSMutableArray *minutes = [NSMutableArray arrayWithObjects:
 @"zero",@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine",@"ten",
 @"eleven",@"twelve",@"thirteen",@"fourteen",@"quarter",@"sixteen",@"seventeen",@"eighteen",@"nineteen",@"twenty",
 
 @"twenty one",@"twenty two",@"twenty three",@"twenty four",@"twenty five",@"twenty six",@"twenty seven",@"twenty eight",@"twenty nine",
 @"half",@"twenty nine",@"twenty eight",@"twenty seven",@"twenty six",@"twenty five",@"twenty four",@"twenty three",@"twenty two",@"twenty one",@"twenty",
 @"nineteen",@"eighteen",@"seventeen",@"sixteen",@"quarter",@"fourteen",@"thirteen",@"twelve",@"eleven",@"ten",@"nine",@"eight",@"seven",@"six",@"five",@"four",@"three",@"two",@"one",nil];
 
 // insert code here...
 NSLog(@"输入数字：");
 int hour,minute;
 scanf("%d %d",&hour,&minute);
 
 if((hour<1)||(hour>12)||(minute<0)||(minute>=60))
 {
 printf("请重新输入：");
 scanf("%d %d",&hour,&minute);
 }
 
 if (hour==12) {
 hour=1;
 }
 
 if (minute==0) {
 NSLog(@"%@ o'clock",hours[hour]);
 }else if((minute==15)||(minute==30))
 {
 NSLog(@"%@ past %@",minutes[minute],hours[hour]);
 }else if(minute==45)
 {
 NSLog(@"%@ to %@",minutes[minute],hours[hour+1]);
 }else if(minute < 30)
 {
 if (minute == 1) {
 NSLog(@"%@ minute past %@",minutes[minute],hours[hour]);
 }else
 NSLog(@"%@ minutes past %@",minutes[minute],hours[hour]);
 }else if(minute>30)
 {
 NSLog(@"%@ minutes to %@",minutes[minute],hours[hour+1]);
 }
*/