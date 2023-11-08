//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	readFile.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Uses getline() to read every string from file and runs addString()
// to create a new node for each string in a linked list
//
// Input:
//		x0 - contains the iFD
//		x1 - contains address of headPtr
//		x2 - contains address of newNode
//      x3 - contains nodeCount
//		x4 - contains address of tailPtr
//		
// Output:
//		x3 - contains nodeCount (Updates it inside addStringKey())
//		
//*****************************************************************
	.global readFile
	.data
fileBuf:	.skip 21
iFD:		.byte 0
	.text
readFile:
	STR X19, [SP, #-16]!	//PUSH 
	STR X20, [SP, #-16]!	//PUSH 
	STR X21, [SP, #-16]!	//PUSH 
	STR X22, [SP, #-16]!	//PUSH 
	STR X23, [SP, #-16]!	//PUSH 
	STR X30, [SP, #-16]!	//PUSH LR
	
	//Consrve parameters
	mov x20,x1		//x20 = address headPtr
	mov x21,x2		//x21 = address newNode
	mov x22,x3		//x22 = nodeCount
	mov x23,x4		//x23 = address tailPtr
	
	//At this point x0 contains, the fd
	// ----- code goes here
	//Save x0 to iFD
	// --------------- 1st string
	ldr x4, =iFD
	strb w0, [x4]
	
top1:
	ldr x0,=iFD
	ldrb w0,[x0]
	ldr x1,=fileBuf
	ldr x2,=iFD
	//do{
	//
	bl getLine
	cmp x0,#0
	beq	last	//}while we keep getting data

	//ldr x0,=fileBuf
	//bl putstring
	//Set parameters to call addStringKey()
	mov x0,x20		//x0 = address headPtr
	mov x1,x21		//x1 = address newNode
	ldr x2,=fileBuf	//x2 = address fileBuf
	mov x3,x22		//x3 = nodeCount
	mov x4,x23		//x4 = address tailPtr
	bl addStringKey
	mov x22,x3		//x22 = updated nodeCount
	
	ldr x0,=fileBuf
	mov x1,#0
	str x1,[x0]
	
	ldr x0,=iFD
	ldrb w0,[x0]	//X0 = iFD
	
	b top1
	
last:
	//X0 needs to have the file handle in it.
	ldr x0,=iFD
	ldrb w0,[x0]	//x0 = iFD

	mov x3, x22		//x3(nodeCount) = x22(updatedCount)
	
	LDR X30, [SP], #16	//POP	LR
	LDR X23, [SP], #16	//POP
	LDR X22, [SP], #16	//POP
	LDR X21, [SP], #16	//POP
	LDR X20, [SP], #16	//POP
	LDR X19, [SP], #16	//POP
	RET
