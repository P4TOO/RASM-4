
//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	saveFile.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	saves the linked list and stores it into output.txt
//	open and file closing is done in this function
//  fill descriptor is also taken care of here
// Input:
//		
//		x0 - contains address of headPtr
//		x1 - contains address of currentNode
//		x2 - contains address of output file
//		
// Output:
//		
//*****************************************************************


	.data
szfileError: .asciz "File is not open\n"
szFile:		.asciz 		"test.txt"
chLF:	    .byte       0xa
iFD:		.byte		0


	.global saveFile
	.text
	
	
saveFile:

	STR x19, [SP, #-16]!	//PUSH
	STR x20, [SP, #-16]!	//PUSH
	STR x21, [SP, #-16]!	//PUSH
	STR X30, [SP, #-16]!	//PUSH LR
	
	mov x19, x0		// x0 = *headPtr	 (conserver headPtr)
	mov x20, x1		// x1 = *currentNode (conserve currentNode)
	mov x21, x2		// x2 = *fileName   (conserve file name)


//============================================File opening	
	 //; Open the output file for writing
    mov x0, #-100       		// Local directory
    mov x8, #56             	// OPENAT
    mov x1, x21	 				// File Name
    //mov x2, #0101             // FLAGS for write //create if none
    mov x2, #01001				// FLAGS truncated when file is opened
    mov x3, #0777      			// MODE RW-RW----
    svc 0						// Service call
		
    cmp x0,#0
    blt fileOpenError	//display messege
    
    mov x26, x0			//x0 = iFD (conserve iFD)
    
    //At this point x0 contains, the fd
	// ----- code goes here
	//Save x0 to iFD
	// --------------- 1st string
	ldr x4, =iFD
	strb w0, [x4]
    
    
//==========================================linked list parameters	

	mov x0, x19			//x19 = *headPtr
	mov x1, x20			//x21 = *currentNode
	
	//x0 contains address headPtr
	ldr x0,[x0]				//x0 = *x0
	
	//x1 contains address currentNode
	//currentNode = headPtr
	str x0,[x1]
	
iterateList:
	
	//While (currentNode != NULL)
	cmp x0, #0
	b.eq iterateDone
	
	ldr x0,[x0]			//x0 = currentNode->string
	mov x19, x0			//save x0 = currentNode->string reload later
	
	bl String_length
	mov x24, x0
//X24 now has the length of string

	
//======================================OUTPUT TO FILE
		//output currentNode into output file
		//currentNode is currently pointing to string 
		mov x8, #64		//system write call
		mov x0, x26		//load the file descriptor that was previously saved
		mov x1, x19		//currentNode -> string buff address
		mov x2, x24		//num of bytes to write from String_length
		
		svc 0
		
		mov x8, #64		//system write call
		mov x0, x26		//load the file descriptor that was previously saved
		ldr x1,=chLF	//currentNode -> string buff address
		mov x2, #1		//num of bytes to write from String_length
		svc 0

//======================================TRAVERSE NEXT NODE
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

//===========================================File CLOSE
	//x0 needs to have file to handle it
	// reload x0 with file descriptor
	ldr 	x0,=iFD
	ldrb 	w0,[x0]
 
    mov x8, #57         // syscall number for close
    svc 0               // Close file

//===========================================RETURN TO CALLER
	LDR X30, [SP], #16		//POP LR
	LDR X21, [SP], #16		//POP
	LDR X20, [SP], #16		//POP
	LDR X19, [SP], #16		//POP
	ret



fileOpenError:
	
	ldr x0,= szfileError
	bl putstring
	
	b iterateDone
