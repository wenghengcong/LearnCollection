//
//  DataType.c
//  CLearn
//
//  Created by 翁恒丛 on 2018/11/8.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#include "DataType.h"

void logDataTypeMemorySize()
{
    printf("在64位机器中：\n");
    printf("        char类型----%lu个字节\n",sizeof(char));
    printf("       short类型----%lu个字节\n",sizeof(short));
    printf("         int类型----%lu个字节\n",sizeof(int));
    printf("        long类型----%lu个字节\n",sizeof(long));
    printf("unsigned int类型----%lu个字节\n",sizeof(unsigned int));
    printf("       float类型----%lu个字节\n",sizeof(float));
    printf("      double类型----%lu个字节\n",sizeof(double));
    printf(" long double类型----%lu个字节\n",sizeof(long double));
    printf("-------------------指针----4个字节---------------------\n");
    char *p0;
    short *p1;
    int *p2;
    long *p3;
    unsigned int *p4;
    float *p5;
    double *p6;
    long double *p7;
    printf("        char类型指针----%lu个字节\n",sizeof(p0));
    printf("       short类型指针----%lu个字节\n",sizeof(p1));
    printf("         int类型指针----%lu个字节\n",sizeof(p2));
    printf("        long类型指针----%lu个字节\n",sizeof(p3));
    printf("unsigned int类型指针----%lu个字节\n",sizeof(p4));
    printf("       float类型指针----%lu个字节\n",sizeof(p5));
    printf("      double类型指针----%lu个字节\n",sizeof(p6));
    printf(" long double类型指针----%lu个字节\n",sizeof(p7));
}


