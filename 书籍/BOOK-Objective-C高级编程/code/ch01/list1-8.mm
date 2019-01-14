int __CFDoExternRefOperation(uintptr_t op, id obj) {
	CFBasicHashRef table = get hashtable from obj;
	int count;
	switch (op) {
	case OPERATION_retainCount:
		count = CFBasicHashGetCountOfKey(table, obj);
		return count;
	case OPERATION_retain:
		CFBasicHashAddValue(table, obj);
		return obj;
	case OPERATION_release:
		count = CFBasicHashRemoveValue(table, obj);
		return 0 == count;
	}
}