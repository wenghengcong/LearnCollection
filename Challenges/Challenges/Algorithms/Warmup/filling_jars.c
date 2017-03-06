//
//  filling_jars.c
//  Challenges
//
//  Created by whc on 15/5/7.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

//web https://www.hackerrank.com/challenges/filling-jars
#include "filling_jars.h"

/**
 *  给罐子数组中从编号a到b的罐子每个罐子加入k个糖果
 *
 *  @param a   数组中编号为a的罐子
 *  @param b   数组中编号为b的罐子
 *  @param k   每次假如的糖果k
 *  @param arr 存放罐子的数组
 */
void fillJar(long long  int a,long long int b, long long  k,long long int arr[])
{
    //为了数组对应罐子编号，-1
    a -= 1;
    b -= 1;
    if (a > b) {
        return;
    }else if (a==b)
    {
        arr[a] += k;
    }else
    {
        for (long long int i = a; i <= b; i++) {
            arr[i] += k;
        }
    }
}

/**
 *  返回每个罐子的平均数
 *
 *  @param arrayLength <#arrayLength description#>
 *  @param arr         <#arr description#>
 *
 *  @return <#return value description#>
 */
long long int returnAvgJar(long long  int arrayLength,long long int arr[])
{
    long long int sum;
    for (long long int i=0; i < arrayLength; i++) {
        sum += arr[i];
    }
    return sum/arrayLength;
}


//另外一种极为简单的方案
void mainFunction()
{
    long long int jarNum,cycle;
    scanf("%lld %lld",&jarNum,&cycle);
    
    //cycle次加入糖果
    long long int sum=0;
    
    for(long long int i = 0 ;i < cycle ;i++)
    {
        long long int a,b,k;
        scanf("%lld %lld %lld",&a,&b,&k);
        sum += (b-a+1)*k;
    }
    
    long long int avg = sum/jarNum;
    printf("%lld\n",avg);

}