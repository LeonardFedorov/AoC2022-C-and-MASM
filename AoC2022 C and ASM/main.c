#include <stdio.h>

extern long long StringTest(long long ptr);
extern char *NumberToString(long long number);

extern long long GetProcessHeap();
extern long long HeapFree(long long handle, int flags, long long pointer);

int main() {

	long long HeapHandle = GetProcessHeap();

	long long testNumber = 123456;

	char *result;

	result = NumberToString(testNumber);

	printf(result);

	HeapFree(HeapHandle, 0, result);

	return 0;

}