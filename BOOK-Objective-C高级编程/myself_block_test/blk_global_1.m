int main(int argc, char const *argv[])
{
    typedef int (^blk_t)(int);
	for (int i = 0; i < 10; ++i)
	{
        blk_t blk = ^(int count){return i * count;};
	}
	return 0;
}
