; An array is perfect if it contains values starting from zero
; and incrementing by 1, with no value appearing twice
; For example: 0, 2, 1 is perfect
; While 0, 2, 3 is not perfect, 0, 1, 1 is not perfect 

include 'win32a.inc'

format PE console
entry start

section '.data' data readable writeable
	array		db 9, 8, 0, 2, 5, 6, 3, 4, 1, 7 ; perfect
	;array		db 9, 8, 0, 2, 5, 6, 3, 44, 1, 70 ; Array is no good
	array_len 	dd $-array
	bad_array	db "Array is no good", 13, 10, 0
	good_array	db "Perfect", 13, 10, 0
	
section '.text' code readable executable
; ======================================

check:
	; pointer to array, array_len, value to find
    push	ebp
	mov		ebp, esp
	
	; adding place in the stak for the local value, that we will return by the end of the function
	sub		esp, 4 
		
	; We want to make sure we do not change the value within the function so we push it to the stack
	push	ebx	  ;value to find 
	push	ecx	  ; length of the array
	push	array ;the address of the array
	
	;into the function: We will use with registers
	mov		eax, [ebp+8]  		; value to find
	mov		ecx, [ebp+12]		; length of the array
	mov		ebx, [ebp + 16] 	; address of array 
	mov		dword [ebp-4], 0	; local varuble
	xor		edx, edx
.loop:
	mov		dl, byte [ebx+ecx-1]; array[atrlen(array)-1],    ecx = array_len and then --.
	cmp		edx, eax
	je		.found
	loop	.loop
.not_found:
	mov		dword [ebp-4], 0
	jmp		.done
.found:
	mov		dword [ebp-4], 1
.done:
	; the 'Return reg' According to both methods 'CDCEL' and 'STDCALL' are agree of the reg EAX! so the return value will mov in the eax register
	mov		eax, [ebp-4] ;1 or 0 (found or not)
	pop		edx		;  address of array
	pop		ecx		; length of the array
	pop		ebx		; value to find
	add     esp, 4  ; Raise the pointer to be after the local variable in the stack, meaning it will Increase  EBP
 	pop		ebp
	ret		12		; Read the return address (for eip), copy to EIP • Increase ESP • Jump to EIP
	
start:
	mov		ecx, [array_len]
	xor		ebx, ebx
check_element:
	push	array		        ; array address
	push	[array_len]			; array length
	push	ebx			        ; value to search
	call	check
	cmp		eax, 0
	je		bad
	inc		ebx
	loop	check_element
good:
	mov		esi, good_array
	call	print_str
	jmp		done
bad:
	mov 	esi, bad_array
	call	print_str
	
done:
	push	0
	call	[ExitProcess]

include 'training.inc'

