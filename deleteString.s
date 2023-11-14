//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	deleteString.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Given a linked list and targetIndex of the string to be deleted use
// indexSearch to find node and then delete the string and node (reduce
//	nodeCount).
//
// Input:
//		x0 - address of headPtr
//		x1 - address of currentNode
//		x2 - targetIndex
//		x3 - address of tailPtr
//		x4 - nodeCount
//
//		
// Output:
//		x3 - updated nodeCount
//*****************************************************************
	.global deleteString
	.data
szEmpty:		.asciz	"Cannot delete from an empty list\n"
szItemNotFound:	.asciz	"The item to be deleted is not in the list\n"
tailCurrent:	.quad 0 //NULL
	.text
deleteString:
	STR X19, [SP, #-16]!	//PUSH
	STR X20, [SP, #-16]!	//PUSH
	STR X21, [SP, #-16]!	//PUSH
	STR X22, [SP, #-16]!	//PUSH
	STR X23, [SP, #-16]!	//PUSH
	STR X24, [SP, #-16]!	//PUSH
	STR X25, [SP, #-16]!	//PUSH
	STR X30, [SP, #-16]!	//PUSH LR
	
	//conserve parameters
	mov x19, x0		//x19 = *headPtr
	mov x20, x1		//x20 = *currentNode
	mov x21, x2		//x21 = targetIndex
	mov x22, x3		//x22 = *tailPtr
	mov x23, x4		//x23 = nodeCount
	
	
	//Set parameters indexSearch
	mov x0, x19		//x0 = *headPtrs
	mov x1, x20		//x1 = *currentNode
	mov x2, x21		//x2 = targetIndex
	bl indexSearch
	ldr x1,=tailCurrent
	str x4,[x1]		//tailCurrent = node before
	
	cmp x3,#0		//indexSearch returns x3 to the index where it was
	beq notFound	//found
	
	//trailCurrent->next = current->next
	ldr x5,[x20]			//x5 = **currentNode
	ldr x1,=tailCurrent		//x1 = *tailCurrent
	str x5,[x1]				// **tailCurrent = **currentNode
	sub x23,x23,#1			//nodeCount--
	
	ldr x1,=tailCurrent		//x1 = *tailCurrent
	ldr x1,[x1]				//x1 = tailCurrent
	str x1,[x22]			//tail = tailCurrent
	
	ldr x0,[x20]
	ldr x0,[x0]
	bl free					//Delete currentNode
	
	b editDone
notFound:
	ldr x0,=szItemNotFound
	bl putstring
editDone:
	mov x3, x23
	
	LDR X30, [SP], #16		//POP LR
	LDR X25, [SP], #16		//POP
	LDR X24, [SP], #16		//POP
	LDR X23, [SP], #16		//POP
	LDR X22, [SP], #16		//POP
	LDR X21, [SP], #16		//POP
	LDR X20, [SP], #16		//POP
	LDR X19, [SP], #16		//POP
	ret
