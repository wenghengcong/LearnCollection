//
//  find_digits.c
//  Challenges
//
//  Created by whc on 15/5/7.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#include "find_digits.h"

//web  https://www.hackerrank.com/challenges/find-digits

/**
 *  返回一个数的位数
 *
 *  @param n <#n description#>
 *
 *  @return <#return value description#>
 */
long int calNumDigits(long int n)
{
    long int numOfDigit = 1;
    while (n/10) {
        n/=10;
        numOfDigit++;
    }
    
    return numOfDigit;
}

/**
 *  返回存放一个数n的各个数字的数组
 *
 *  @param n
 *
 */
void divideNum(long int n,long int arr[],long int arrayLength)
{
    long int temp;
    for (long int i = 0; i < arrayLength; i++) {
        temp = n%10;
        arr[arrayLength-i-1] = temp;
        n = n/10;
    }
}


long int find_digit(long int n)
{
    long int digits = 0;
    long int numOfN = calNumDigits(n);
    long int arr[numOfN];
    divideNum(n, arr, numOfN);
    
    for (long int i = 0; i < numOfN; i++) {
        if (arr[i]==0) {
            continue;
        }
        if ( n % arr[i] == 0) {
            digits++;
        }
    }
    
    return digits;
}