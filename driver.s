//*****************************************************************
//Name: 	Diego Salas & Diego Rojas
//Program:	driver.s
//Class:	CS 3B
//Lab:		RASM-4
//Date:		November 9, 2023 at 2:30 PM
//Purpose:
//	Menu driver program that serves as a text editor and save the
// resulting text to a file. You  must be able to enter new strings 
// manually and/or via a file (input.txt).
//
//*****************************************************************
	.global _start
	.equ	MAXKB,	1024
	.equ R,	 		0
	.equ W,	 		01
	.equ RW, 		02
	.equ T_RW,		01002
	.equ C_W,	  	0101
	.equ NR_exit, 	93
	.equ RW_RW____, 0660
	.equ AT_FDCWD,	-100
	
	.data
//General variables
fileName: 		.asciz "input.txt"
outName:		.asciz "output.txt"
kdBuf:			.skip		MAXKB
strTemp:		.skip 21	//Use as an string buffer
chLF:			.byte 0xa	//Use for "\n"
targetIndex:	.quad 0		//Used for deleteString & editString
newString:		.skip 21	//Used for editString

//Linked List variables
headPtr: 		.quad 0		//NULL
tailPtr: 		.quad 0		//NULL
newNode:		.quad 0		//Is used for insertion into linked list
currentNode:	.quad 0		//Use for traversing linked list
nodeCount:		.quad 0		//Used to keep count of nodes
memoryUse:		.quad 0		//Used to keep track of memory usage

//Menu Strings
szMenu0:		.asciz		"                   MASM4 TEXT EDITOR\n"
szMenu1:		.asciz  	"         Data Structure Heap Memory Consumption: "
szMenu2:		.asciz      " bytes\n"
szMenu3:		.asciz  	"         Number of Nodes: "
szMenu4:		.asciz  	"\n<1> View all strings\n\n"
szMenu5:		.asciz		"<2> Add string\n"
szMenu6:		.asciz  	"    <a> from Keyboard\n"
szMenu7:		.asciz  	"    <b> from File. Stati file name input.txt\n\n"
szMenu8:		.asciz  	"<3> Delete string, Given an index #, delete \n\n"
szMenu9:		.asciz      "the entire string and de-allocate memory "
szMenu10:		.asciz		"(including node).\n\n"
szMenu11:		.asciz		"<4> Edit string. Given and index #, replace "
szMenu12:		.asciz      "old string w/ new string. Allocate/De-allocate "
szMenu13:		.asciz		"as needed.\n\n"
szMenu14:		.asciz  	"<5> String search. Regardless of case, return "
szMenu15:		.asciz		"all strings that match the substring given.\n\n"
szMenu16:		.asciz  	"<6> Save File (output.txt)\n\n"
szMenu17:		.asciz  	"<7> Quit\n"
szPrompt:		.asciz		"Enter an option: "
szPrompt2:		.asciz		"Enter a string: "
szPrompt3:		.asciz		"Enter a new string: "
szInvalid:		.asciz		"Invalid Option Please re-enter\n"
szEnterIndex:	.asciz		"Enter index of string: "
szTemp:			.skip 21

   .text
_start:
	//==================================================================
	//Prompt Menu
	//---------------------
menu:
	ldr x0,=szMenu0			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu1			//Print Menu prompt
	bl putstring
	
	//Set up parameters int64asc
	ldr x0,=memoryUse		
	ldr x0,[x0]				//x0 = memoryUse
	ldr x1,=szTemp			//x1->szTemp
	bl int64asc
	
	ldr x0,=szTemp			//Print memory consumption
	bl putstring

	ldr x0,=szMenu2			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu3			//Print Menu prompt
	bl putstring
	
	//Set up parameters int64asc
	ldr x0,=nodeCount		
	ldr x0,[x0]				//x0 = nodeCount
	ldr x1,=szTemp			//x1->szTemp
	bl int64asc
	
	ldr x0,=szTemp			//Print nodeCount
	bl putstring

	ldr x0,=szMenu4			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu5			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu6			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu7			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu8			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu9			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu10		//Print Menu prompt
	bl putstring

	ldr x0,=szMenu11		//Print Menu prompt
	bl putstring

	ldr x0,=szMenu12		//Print Menu prompt
	bl putstring

	ldr x0,=szMenu13		//Print Menu prompt
	bl putstring

	ldr x0,=szMenu14		//Print Menu prompt
	bl putstring

	ldr x0,=szMenu15		//Print Menu prompt	
	bl putstring

	ldr x0,=szMenu16		//Print Menu prompt
	bl putstring

	ldr x0,=szMenu17		//Print Menu prompt
	bl putstring
	
	b firstRun
//======================================================================
// Prompt User to choose from Menu
// ----------------------------------
newOption:
	ldr x0,=szMenu1			//Print Menu prompt
	bl putstring
	
	//Set up parameters int64asc
	ldr x0,=memoryUse		
	ldr x0,[x0]				//x0 = memoryUse
	ldr x1,=szTemp			//x1->szTemp
	bl int64asc
	
	ldr x0,=szTemp			//Print memory consumption
	bl putstring

	ldr x0,=szMenu2			//Print Menu prompt
	bl putstring

	ldr x0,=szMenu3			//Print Menu prompt
	bl putstring
	
	//Set up parameters int64asc
	ldr x0,=nodeCount		
	ldr x0,[x0]				//x0 = nodeCount
	ldr x1,=szTemp			//x1->szTemp
	bl int64asc
	
	ldr x0,=szTemp			//Print nodeCount
	bl putstring
	
	ldr x0,=chLF			//Print LF
	bl putch
	
	ldr x0,=chLF			//Print LF
	bl putch
firstRun:
invalidOption:
	//Print "Enter an option: "
	ldr x0,=szPrompt
	bl putstring
		
	ldr x0,=kdBuf
	mov x1, MAXKB
		
	bl getstring
		
	ldr x0,=kdBuf
	ldrb w0,[x0]
		
	cmp w0, '1'
	beq option1
	
	cmp w0, '2'
	beq option2
	
	cmp w0, '3'
	beq option3
	
	cmp w0, '4'
	beq option4
	
	cmp w0, '6'
	beq option6
	
	cmp w0, '7'
	beq exit
		
	//Else (Ask user to re-enter a valid option)
	//Print "Invalid Option Please re-enter\n"
	ldr x0,=szInvalid
	bl putstring
	
	b invalidOption		//goto invalidOption
	
option2:
	//A or B?	
	ldr x0,=kdBuf
	ldr w0,[x0, #1]
	
	cmp x0, 'a'
	beq	optiona
	
	cmp x0, 'b'
	beq optionb
	
	//Else (Ask user to re-enter a valid option)
	//Print "Invalid Option Please re-enter\n"
	ldr x0,=szInvalid
	bl putstring
	
	b invalidOption		//goto invalidOption
//==================================================================
//Option 1 (View All Strings)
//----------------------------
option1:
	//Set parameters displayList
	ldr x0,=headPtr			//x0 - contains ptr of head of ll
	ldr x1,=currentNode		//x1 - contains ptr of currentNode of ll
	bl displayList			//Calls displayList
	
	//Print LF
	ldr x0,=chLF
	bl putch
	
	b newOption				//return to menu
//==================================================================
//Option 2a (Add String from Keyboard)
//-------------------------------------
optiona:
	//Print "Enter a string: "
	ldr x0,=szPrompt2		//x0 points to string
	bl putstring			//Call putstring
	
	//Clean buffer
	mov x1,#0	
	ldr x0,=kdBuf
	str x1,[x0]				//kdBuf = 0
	
	//Set parameters getString
	ldr x0,=kdBuf			//x0 points to buffer
	mov x1, MAXKB			//sets max of bytes
	bl getstring			//Call getstring
	
	//Set paramters addStringKey
	ldr x0,=headPtr			//x0->headPtr	
	ldr x1,=newNode			//x1->newNode
	ldr x2,=kdBuf			//x2->kdBuf
	ldr x3,=nodeCount		
	ldr x3,[x3]				//x3 = nodeCount
	ldr x4,=tailPtr			//x4->tailPtr
	bl addStringKey			//Call addStringKey
							//function returns updated x3(nodeCount)
	ldr x0,=nodeCount		
	str x3,[x0]				//nodeCount = updated nodeCount
	
	//Clean buffer
	mov x1,#0
	ldr x0,=kdBuf
	str x1,[x0]				//kdBuf = 0
	
	//Print LF
	ldr x0,=chLF
	bl putch
	
	b newOption				//return to menu
//==================================================================
//Option 2b (Add String from File)
//-------------------------------------
optionb:
	//Open file
	mov x0, #AT_FDCWD		//local directory
	mov x8, #56				//OPENAT
	ldr x1,=fileName		//x1 = address fileName
	
	mov x2, #R				//FLAGS
	mov x3, #RW_RW____		//MODE RW-RW----
	svc 0					//Service call

    //set parameters readFile
	ldr x1,=headPtr			//x1 = address headPtr
	ldr x2,=newNode			//x2 = address newNode
	ldr x3,=nodeCount		
	ldr x3,[x3]				//x3 = nodeCount
	ldr x4,=tailPtr			//x4 = address tailPtr
	bl readFile				//readFile returns x3(updated nodeCount)
	ldr x0,=nodeCount
	str x3,[x0]		//nodeCount = updated nodeCount
	
    mov x8, #57		//CLOSE FILE
	svc 0
	
	//Print LF
	ldr x0,=chLF
	bl putch
	
	b newOption				//return to menu
//==================================================================
//Option 3 Delete String
//-------------------------------------
option3:
	//Print "Enter index of string: "
	ldr x0,=szEnterIndex		//x0->szEnterIndex
	bl putstring				//Print
	
	//Clean buffer
	mov x1,#0	
	ldr x0,=kdBuf
	str x1,[x0]				//kdBuf = 0
	
	//Set parameters getString
	ldr x0,=kdBuf			//x0 points to buffer
	mov x1, MAXKB			//sets max of bytes
	bl getstring			//Call getstring
	
	//Set parameters ascint64
	ldr x0,=kdBuf			//x0 points to buffer
	bl ascint64				//returns int64 value
	ldr x1,=targetIndex		//x1->targetIndex
	str x0,[x1]				//targetIndex = int64 value		


	//Set parameters deleteString
	ldr x0,=headPtr			//x0->headPtr
	ldr x1,=currentNode		//x1->currentNode
	ldr x2,=targetIndex	
	ldr x2,[x2]				//x2 = targetIndex
	ldr x3,=tailPtr			//x3->tailPtr
	ldr x4,=nodeCount		
	ldr x4,[x4]				//x4 = nodeCount
	bl deleteString			//Returns x3(update nodeCount)
	ldr x0,=nodeCount
	str x3,[x0]				//nodeCount = updated nodeCount
	
	//Print LF
	ldr x0,=chLF
	bl putch
	
	b newOption				//return to menu
//==================================================================
//Option 4 Edit String
//-------------------------------------
option4:
	//Print "Enter index of string: "
	ldr x0,=szEnterIndex		//x0->szEnterIndex
	bl putstring				//Print
	
	//Clean buffer
	mov x1,#0	
	ldr x0,=kdBuf
	str x1,[x0]				//kdBuf = 0
	
	//Set parameters getString
	ldr x0,=kdBuf			//x0 points to buffer
	mov x1, MAXKB			//sets max of bytes
	bl getstring			//Call getstring
	
	//Set parameters ascint64
	ldr x0,=kdBuf			//x0 points to buffer
	bl ascint64				//returns int64 value
	ldr x1,=targetIndex		//x1->targetIndex
	str x0,[x1]				//targetIndex = int64 value		
	
	//Print "Enter a new string: "
	ldr x0,=szPrompt3		//x0 points to string
	bl putstring			//Call putstring
	
	//Clean buffer
	mov x1,#0	
	ldr x0,=kdBuf
	str x1,[x0]				//kdBuf = 0
	
	//Set parameters getString
	ldr x0,=kdBuf			//x0 points to buffer
	mov x1, MAXKB			//sets max of bytes
	bl getstring			//Call getstring
	
	//Set parameters editString
	ldr x0,=headPtr			//x0->headPtr
	ldr x1,=currentNode		//x1->currentNode
	ldr x2,=targetIndex		
	ldr x2,[x2]				//x2 = targetIndex
	ldr x3,=kdBuf			//x3->kdBuf(contains new string)		
	bl editString

	//Print LF
	ldr x0,=chLF
	bl putch
	
	b newOption				//return to menu

//==================================================================
//Option Save File (output.txt)
//-------------------------------------
option6:
	//Set parameters saveFile
	ldr x0,=headPtr			//x0 = *headPtr
	ldr x1,=currentNode		//x1 = *currentNode
	ldr x2,=outName			//x2 = *outName (Output file)
	bl saveFile				//Prints all string to output file

	//Print LF
	ldr x0,=chLF
	bl putch
	
	b newOption				//return to menu


exit:
   // Setup the parameters to exit the program
   // and then call Linux to do it.
   MOV   X0, #0      // Use 0 return code
   MOV   X8, #93      // Service command code 93 terminates this program
   SVC   0           // Call linux to terminate the program
