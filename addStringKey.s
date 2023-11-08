//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	addStringKey.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Purpose to store string in new node of linked list and return
// updated nodeCount
//
// Input:
//		x0 - contains address of headPtr
//		x1 - contains address of newNode
//		x2 - contains address of kdBuf
//		x3 - contains nodeCount (keeping track of nodes)
//      x4 - contains address of tailPtr
//
// Output:
//		x3 - contains nodeCount
//		
//*****************************************************************
	.global addStringKey
	.data
	.text
addStringKey:
	STR X19, [SP, #-16]!	//PUSH LR
	STR X20, [SP, #-16]!	//PUSH LR
	STR X21, [SP, #-16]!	//PUSH LR
	STR X22, [SP, #-16]!	//PUSH LR
	STR X23, [SP, #-16]!	//PUSH LR
	STR X30, [SP, #-16]!	//PUSH LR
	
	//					NODE
	// --------------------------------------------------------------
	// |		*DATA				|			*NEXT				|
	// | 00 00 00 00 00 00 00 00	| 00 00 00 00 00 00 00 00		|
	//---------------------------------------------------------------

	mov x19, x0		//x19 = headPtr
	mov x20, x1		//x20 = newNode
	mov x21, x2		//x21 = kdBuf
	mov x22, x3		//x22 = nodeCount (Reassign to x3 before returning)
	mov x23, x4		//x23 = tailPtr
	
	//newNode = new nodeType (create the new node)
	mov x0, #16
	bl malloc

	mov x1, x20		//x1 = address newNode
	str x0,[x1]		//newNode = address retunred by malloc
	//--------------- END CREATE NEW NODE ------------------------------

	//Make a copy kdBuf into a newly malloc'd string
	mov x0, x21		//x0 = address kdBuf
	bl String_copy

	//newNode->data = new string (store the new string at the adress
	//								of the new string)
	mov x1, x20			//x1 = address of newNode
	ldr x1, [x1]		//x1 = newNode
	str x0, [x1]		//X0 has the address of the new string from String_copy
						//Now, we just stored that address
						//into newNode
						
	//nedNode->data = nullptr (set the link field of newNode to nullptr)
	mov x3,#0			//NULL
	add x1,x1,#8		//Make X1 -> Next Field
	str x3,[x1]			//Store NULL into the next FIELD
	
	//THE INSERTION PART
	
	//if (headPtr == nullptr)	if the list is empty, newNode is both the
	//						first and last node
	mov x0, x19			//x0 = address headPtr
	ldr x0,[x0]			//x0 = headPtr
	cbnz x0, NOTEMPTY	//option 1
	
	//CMP x0,#0			//option 2
	//b.ne NOTEMPTY
	//{
	
	mov x1, x20		//x1 = address newNode
	ldr x1,[x1]		//x1 = newNode
	
	mov x0, x19		//x0 = address headPtr
	str x1,[x0]		//headPtr = newNode
	mov x0, x23		//x0 = address tailPtr	
	str x1,[x0]		//tailPtr = newNode
	
	add x22,x22,#1	//Increase nodeCount
	
	b addStringKeyEnd
	//}
NOTEMPTY:
	//else //the list is not empty, insert newNode after last
	//{
	//tailPtr->next = newNode	//insert newNode after next
	mov x0, x23		//x0 = address of the tail variable
	ldr x0,[x0]		//x0 = tailPtr(address last node)
	mov x1, x20		//x1 = address of the newNode variables
	ldr x1,[x1]		//x1 = newNode (address of the new node)
	
	str x1,[x0,#8]	//tail->next = newNode
	
	//tail = newNode	//make tail point to the actual
	//					last node in the list
	mov x0, x23		//reload the tailPtr variable
	str x1,[x0]
	//}
	
	//count++	//increment count
	add x22, x22, #1
	
addStringKeyEnd:
	mov x3, x22		//x3(nodeCount) = x22(updatedCount)
	
	LDR X30, [SP], #16	//POP	LR
	LDR X22, [SP], #16	//POP
	LDR X21, [SP], #16	//POP
	LDR X20, [SP], #16	//POP
	LDR X19, [SP], #16	//POP
	RET
