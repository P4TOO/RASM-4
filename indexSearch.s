//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	indexSearch.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Given targetIndex iterate through linked list and find node that 
//	matches
//
// Input:
//		x0 - address of headPtr
//		x1 - address of currentNode
//		x2 - targetIndex
// Output:
//		(pointers set to node that matches index)
//		x3 - Index where node was found
//		x4 - tailCurrent
//*****************************************************************
	.global indexSearch
	.data
chLF:			.byte 0xa
szFound:	.asciz	"Found!\n"
	.text
indexSearch:
	STR X19, [SP, #-16]!	//PUSH
	STR X20, [SP, #-16]!	//PUSH
	STR X21, [SP, #-16]!	//PUSH
	STR X22, [SP, #-16]!	//PUSH
	STR X23, [SP, #-16]!	//PUSH
	STR X30, [SP, #-16]!	//PUSH LR
	
	//conserve paramters
	mov x19, x0		//x19 = *headPtr
	mov x20, x1		//x20 = *currentNode
	mov x21, x2		//x21 = targetIndex
	mov x22, #0		//x22(currentIndex) = 0
	sub x6, x21, #1	//Used to keep track of tailCurrent 
					//(x6 = targetIndex - 1)
		
	//x0 contains address headPtr
	ldr x0,[x0]				//x0 = *x0
	
	//x1 contains address currentNode
	//currentNode = headPtr
	str x0,[x1]
	
iterateList:
	//While (currentNode != NULL)
	cmp x0, #0
	b.eq iterateDone
	
	add x22,x22,#1
	cmp x22,x21
	beq found
	
	cmp x6, x22				//If (x6(targetTail) != x22(currentIndex))
	bne notTail				//Skip to notTail
	//ldr x5,[x0]	
	mov x23,x0				//This is the tailCurrent
notTail:
	//currentNode = currentNode->next
	mov x1, x20				//x1 = currentNode
	ldr x1,[x1]				//x1 = *x1
	
	add x1,x1,#8
	ldr x1,[x1]			//Iterate/point to new node
	
	mov x0, x20				//currentNode = next
	str x1,[x0]				//x0*(currentNode) = x1
	
	mov x0,x1				//x0 = x1
	
	b iterateList
iterateDone:
	cmp x22, x21
	beq found
	mov x22, #0
found:
	mov x3, x22		//Index where node was found (If 0 notfound)
	mov x4, x23		//x4 = tailCurrent
	
	LDR X30, [SP], #16		//POP LR
	LDR X23, [SP], #16		//POp
	LDR X22, [SP], #16		//POP
	LDR X21, [SP], #16		//POP
	LDR X20, [SP], #16		//POP
	LDR X19, [SP], #16		//POP
	ret
