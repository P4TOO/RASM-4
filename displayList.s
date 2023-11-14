//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	displayList.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Iterates & outputs linked list containing string inside of console
//
// Input:
//		x0 - contains address of headPtr
//		x1 - contains address of currentNode
//		
//*****************************************************************
	.global displayList
	.data
chLF:			.byte 0xa
szEmpty:		.asciz	"The list is empty\n"
	.text
displayList:
	STR x20, [SP, #-16]!	//PUSH
	STR X30, [SP, #-16]!	//PUSH LR
	
	mov x20, x1		//x20 = *currentNode (conserve currentNode)
		
	//x0 contains address headPtr
	ldr x0,[x0]				//x0 = *x0
	cmp x0, #0				//If headPtr == null
	beq empty				//List is Empty!
	
	//x1 contains address currentNode
	//currentNode = headPtr
	str x0,[x1]
	
iterateList:
	//While (currentNode != NULL)
	cmp x0, #0
	b.eq iterateDone
	
	ldr x0,[x0]			//x0 = currentNode->string
	bl putstring
	
	ldr x0,=chLF		//print "\n"
	bl putch
	
	//currentNode = currentNode->next
	mov x1, x20				//x1 = currentNode
	ldr x1,[x1]				//x1 = *x1
	
	add x1,x1,#8
	ldr x1,[x1]			//Iterate/point to new node
	
	mov x0, x20				//currentNode = next
	str x1,[x0]				//x0*(currentNode) = x1
	
	mov x0,x1				//x0 = x1
	
	b iterateList
	
empty:
	//Print "The list is empty\n" 
	ldr x0,=szEmpty
	bl putstring
	
iterateDone:
	LDR X30, [SP], #16		//POP LR
	LDR X20, [SP], #16		//POP
	ret
