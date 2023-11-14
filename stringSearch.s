//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	stringSearch.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Given string/substring function will search linked list and find all
// similar string
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
	.global stringSearch
	.data
	.text
stringSearch:
	STR X30, [SP, #-16]!	//PUSH LR

searchDone:
	LDR X30, [SP], #16		//POP LR

	ret
