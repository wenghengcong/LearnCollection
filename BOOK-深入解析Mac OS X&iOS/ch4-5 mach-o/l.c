#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <malloc/malloc.h>

//标准的interpose数据结构
typedef struct interpose_s{
    void *new_func;
    void *orig_fnc;
}interpose_t;

//我们的原型
void *my_malloc(int size);//对应真实的malloc函数
void my_free(void *);//对应真实的free函数

static const interpose_t interposing_functions[] \
__attribute__ ((section ("__DATA,__interpose"))) = {{(void *)my_free,(void *)free},{(void *)my_malloc,(void *)malloc}};

void *my_malloc (int size){
    //在我们的函数中，要访问真正的malloc()函数，因为不想自己管理整个堆，所以就调用了原来的malloc()
    void *returned = malloc(size);
    //调用malloc_printf是因为printf中会调用malloc(),产生无限递归调用。
    malloc_printf("+ %p %d\n",returned,size);
    return (returned);
}

void my_free(void *freed){
    malloc_printf("- %p\n",freed);
    free(freed);
}

int main(int argc, const char * argv[]) {
    // 释放内存——打印出地址，然后调用真正的free()
    printf("Hello, World!\n");
    return 0;
}