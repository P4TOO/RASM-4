//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	editString.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	
//
// Input:
//		x0 - address of headPtr
//		x1 - address of currentNode
//		x2 - targetIndex
//		x3 - address of newString
//		
// Output:
//		string will be modified and stored back to corresponding node
//*****************************************************************
	.global editString
	.data
szNotFound:	.asciz	"Not Found!\n"
	.text
editString:
	STR X19, [SP, #-16]!	//PUSH
	STR X20, [SP, #-16]!	//PUSH
	STR X21, [SP, #-16]!	//PUSH
	STR X22, [SP, #-16]!	//PUSH
	STR X30, [SP, #-16]!	//PUSH LR
	
	//conserve parameters
	mov x19, x0		//x19 = *headPtr
	mov x20, x1		//x20 = *currentNode
	mov x21, x2		//x21 = targetIndex
	mov x22, x3		//x22 = *newString
	
	//Set parameters indexSearch
	mov x0, x19		//x0 = *headPtrs
	mov x1, x20		//x1 = *currentNode
	mov x2, x21		//x2 = targetIndex
	bl indexSearch
	
	cmp x3,#0
	beq notFound
	//Pointers will point to pointer being searched
	//Make a copy kdBuf into a newly malloc'd string
	mov x0, x22
	bl String_copy

	//currentNode->data = new string (store the new string at the adress
	//								of the old string
	mov x1, x20			//x1 = address of currentNode
	ldr x1, [x1]		//x1 = currentNode
	str x0, [x1]		//X0 has the address of the new string from String_copy
						//Now, we just stored that address
						//into currentNode
						
	b editDone
notFound:
	ldr x0,=szNotFound
	bl putstring
editDone:
	LDR X30, [SP], #16		//POP LR
	LDR X22, [SP], #16		//POP
	LDR X21, [SP], #16		//POP
	LDR X20, [SP], #16		//POP
	LDR X19, [SP], #16		//POP
	ret
