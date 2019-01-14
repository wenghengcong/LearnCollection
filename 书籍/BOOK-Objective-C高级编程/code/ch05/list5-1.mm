int main()
{
	void (^blk)(void) = ^{printf("Block\n");};
	blk();
	return 0;
}