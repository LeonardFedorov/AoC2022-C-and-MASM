INCLUDELIB kernel32.lib

GetProcessHeap PROTO; Get the handle of the processes' default assigned heap
HeapAlloc PROTO; Allocate memory within the heap#

.DATA

	StackStore QWORD ?
	HeapHandle QWORD ?
	CountStore QWORD ?

	charOffset EQU 30h
		
.CODE	

; Process a single number placed in RCX, returning a pointer to where the string can be found in RAX
; String is preceeded by a QWORD stating its length and is not zero-terminated
NumberToString PROC

	;Move the input number to a safe place so that we can use RCX for other things
	MOV R10, RCX

	PUSH 0
	MOV RCX, 1

	; Handle zero separately
	CMP R10, 0
	JNE NonZero
		;Add zero char to stack and incremente char count by 1
		PUSH charOffset
		INC RCX

	JMP Finalise

	NonZero:
		
		; Put 10 into a register so it can be divided by
		MOV R9, 10

		; Move the value to process into RAX. 
		MOV RAX, R10
		; Clear R11 as this will be used to count when to comma
		XOR R11, R11
		
		TheLoop:
			; If the residual RAX value is 0, then we're done processing
			CMP RAX, 0
			JZ Finalise

			; If we have counted out 3 numbers since the last comma, write a comma
			CMP R11, 3
			JL DoChar

			PUSH 44
			INC RCX
			XOR R11, R11

			JMP TheLoop

			DoChar:

				; Clear RDX as this will otherwise be treated as the upperhalf of the division otherwise
				XOR RDX, RDX

				;Perform the division, and put the remainder as a char to the stack
				DIV R9
				ADC RDX, charOffset
				PUSH RDX

				INC RCX
				INC R11

				JMP TheLoop

	Finalise:

		;Store the count in R11 as RCX is volatile during Win32 calls
		MOV CountStore, RCX	
		
		;Store the current stack pointer so it can be restored later
		MOV StackStore, RSP

		;Offset stack pointer to 16 bit alignment
		AND SPL, 240

		CALL GetProcessHeap
		MOV HeapHandle, RAX

		;Get a memory slot to store the string
		SUB RSP, 32

			MOV RCX, heapHandle
			MOV RDX, 8
			MOV	R8, CountStore

			CALL HeapAlloc
			;Leave the memory pointer in RAX as this is the final output anyway

		;Move the stack pointer back where it was before the Win32 calls
		MOV RSP, StackStore

		;Clear RCX so we can count
		XOR RCX, RCX

		PopString:

			POP RDX
			MOV [RAX + RCX], DL
			INC RCX

			CMP RCX, CountStore
			JB	PopString
	
	RET

NumberToString ENDP

END