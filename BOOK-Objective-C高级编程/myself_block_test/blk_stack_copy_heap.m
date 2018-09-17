typedef int (^blk_t)(int);

blk_t func(int rate) {
    return ^(int count){ return rate * count;};
}
