//
//  identify_smith_numbers.c
//  Challenges
//
//  Created by whc on 15/5/12.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#include "identify_smith_numbers.h"
/**



 //https://www.hackerrank.com/challenges/identify-smith-numbers
 /**
 *  获取一个数中所有数字的和
 *  例如：19，返回1+9=10
 */
long long int getAllDigitsSumOfNumber(long long int num)
{
    long long int sum = 0;
    while (num) {
        sum += num%10;
        num = num/10;
    }
    return sum;
}


/**
 *  获取一个数中所有因子（除去1和本身）的和
 *  注意的是：假如一个因子大于9，那么这个因子是要拆分成该因子所有数字的和的，例如，11，就是1+1=2，加入到总和中
 */
long long int getAllFactorsSumOfNumber(long long int num)
{
    long long int sum =0;
    while (num%2 == 0) {
        sum += 2;
        num = num/2;
    }
    
    for (long long int i = 3; i < sqrt(num); i = i+2) {
        while (num%i == 0) {
            if(i > 9)
            {
                sum=sum+getAllDigitsSumOfNumber(i);
            }else
            {
                sum+=i;
            }
            num = num/i;
            
        }
    }
    
    if (num > 9) {
        long long int tmp = getAllDigitsSumOfNumber(num);
        sum=sum+tmp;
    }else
    {
        sum=sum+num;
    }
    
    return sum;
}

/**
 *  打印一个数的所有因子
 */
void primeFactors(int n)
{
    // Print the number of 2s that divide n
    while (n%2 == 0)
    {
        printf("%d ", 2);
        n = n/2;
    }
    
    // n must be odd at this point.  So we can skip one element (Note i = i +2)
    for (int i = 3; i <= sqrt(n); i = i+2)
    {
        // While i divides n, print i and divide n
        while (n%i == 0)
        {
            printf("%d ", i);
            n = n/i;
        }
    }
    
    // This condition is to handle the case whien n is a prime number
    // greater than 2
    if (n > 2)
        printf ("%d ", n);
}

/*
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"输入数字：");
        long long int num;
        scanf("%lld",&num);
        if(num==1)
        {
            printf("0");
            return 0;
        }
        if (getAllDigitsSumOfNumber(num)==getAllFactorsSumOfNumber(num)) {
            printf("1");
        }else
        {
            printf("0");
        }
    }
    return 0;
}
*/