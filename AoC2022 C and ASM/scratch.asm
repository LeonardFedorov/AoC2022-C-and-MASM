.DATA	

	TestStringData BYTE "hello world", 0

.Code

 StringTest PROC
	
	LEA RAX, TestStringData

	RET

StringTest ENDP


END