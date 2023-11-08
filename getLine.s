//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	getLine.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Will attempt to read a line in the file and store into ptr provided
// Pre-requisites:
// x0 contains fd
// x1 contains *buf
// Returns:
//******************************************************************
	.global getLine
	.data
szEOF:		.asciz "Reached the End of File\n"
szERROR:		.asciz "FILE READ ERROR\n"
	.text
getLine:
	STR X30, [SP, #-16]!		//PUSH LR
	mov x19, x0		//x19 = address iFD
	
top:
	bl getChar
	ldrb w2,[x1]
	
	cmp w2,#0xa		//Is this character a LF?
	beq eoline
	
	cmp w0,#0x0		//nothing read from file
	beq eof
	
	//cmp w0,#0x0
	//blt error
	
	//good
	//move fileBuf pointer to by 1
	add x1,x1,#1
	
	mov x0, x19	  //x0 = address iFD //reload file descriptor
	ldrb w0,[x0]
	b top
	
eoline:
	add x1,x1,#1	//We are going to make fileBuf into a c-string
	mov w2,#0		// by store null at the end of fileBuf (i.e. "Cat int hat.\0")
	strb w2,[x1]
	b skip
eof:
	mov x19,x0
	ldr x0,=szEOF
	//bl putstring
	mov x0,x19
	b skip
	
error:
	mov x19, x0
	ldr x0, =szERROR
	bl putstring
	mov x0,x19
	b skip
	
skip:
	//Popped in reverse order (LIFO)
	ldr x30, [SP], #16		//POP
	
	ret
