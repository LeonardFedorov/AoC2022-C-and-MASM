#include <stdio.h>

extern long long StringTest(long long ptr);
extern char *NumberToString(long long number);

extern void Day1(long long fileHandle, char* output[]);

extern long long GetProcessHeap();
extern long long HeapFree(long long handle, int flags, long long pointer);

extern long long CreateFileA(char* filename, int access, int sharemode, int security, int creationmode, int flags, long long template);

int main() {

	long long HeapHandle = GetProcessHeap();

	long long file = CreateFileA("C:\\Day1Input.txt",
								 0x80000000, //Generic Read
								 1, //Share Read Access
								 0, //Null security attributes
								 3, //Open Existing only
								 128, //File Attribute normal
								 0 //No file template
								);

	char *result[2];

	char test1 = 'a';
	char test2 = 'b';

	result[0] = &test1;
	result[1] = &test2;

	Day1(file, result);

	printf(result[0]);
	printf(" and ");
	printf(result[1]);

	return 0;

}