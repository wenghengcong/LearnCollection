int main() {
	int dmy = 256;
	int val = 10;
	const char *fmt = "val = %d\n";
	void (^blk)(void) = ^{printf(fmt, val);};
	return 0;
}
