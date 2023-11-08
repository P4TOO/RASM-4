//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	getChar.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Returns current character pointed to
//
// Input:
//		x0 - contains fd
//		x1 - contains *buf
// Output:
//		char *buf
//*****************************************************************
	.global getChar
	.data
	.text
getChar:
	//STR X30, [SP, #-16]!		//PUSH LR
	mov x2, #1
	
	//ssize_t read(int fd, void *buf, size_t count)
	//		x0 read(x0, x1, x2)
	mov x8, #63		//READ
	svc 0			//Does the LR change
	
	//POPPED IN REVERSE ORDER (LIFO)
	//LDR X30, [SP], #16
	
	ret
