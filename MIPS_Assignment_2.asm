
.data
	askStr:		.asciiz	"Enter number of rows: "
	askStr2:	.asciiz	"Enter number of columns: "
	askStr3:	.asciiz	"Enter type of elements: "
	askStr4:	.asciiz	"Enter an array of "
	askStr4.5:	.asciiz	" integers"
	mainStr:	.asciiz "Select one of the following functions:\n1. Print the entered array\n2. Exchange two rows\n3. Exchange two columns\n4. Exit the program"
	op1Str:		.asciiz "Array of "
	op1Str1.5:	.asciiz	" integers is:\n"
	enterStr:	.asciiz	"Enter the "
	firstStr:	.asciiz	"first "
	secondStr:	.asciiz	"second "
	numberStr:	.asciiz	" number: "
	rowStr:		.asciiz	"row"
	columnsStr:	.asciiz	"column"
	resultStr:	.asciiz	"The array after exchanging "
	andStr:		.asciiz	" and "
	errorStr:	.asciiz	"Error: Out of range, please try again\n"
.text

	.macro printWhiteSpace
		li $a0, ' '
		li $v0, 11
		syscall
	.end_macro
	.macro printNewLine
		li $a0, '\n'
	        li $v0, 11
	        syscall
	.end_macro
	.macro printCharS
		li $a0, 's'
	        li $v0, 11
	        syscall
	.end_macro
	.macro getInteger	# get user input (integer)
		li $v0, 5
		syscall
	.end_macro
	
	.globl main
	main:
	
	# get the initial information
	## ask for number of rows
	la $a0, askStr
	li $v0, 4
	syscall
	getInteger
	move $s1, $v0	# $s1 = number of rows. $s0 will have the array address
	
	## ask for number of columns
	la $a0, askStr2
	li $v0, 4
	syscall
	getInteger
	move $s2, $v0	# $s2 = number of columns
	
	## ask for input type (i = word (=4) , else = char (=1))
	la $a0, askStr3
	li $v0, 4
	syscall
	li $v0, 12	# read char
	syscall
	## allocate the array size
	mul $a0, $s1, $s2
	li $s3, 1	# $s3 = element length
		bne $v0, 'i' skip
		sll $a0, $t0, 2		# if ($v0 == 'i') $a0 *= 4;
		li $s3, 4
	skip:
	li $v0, 9
	syscall
	move $s0, $v0	# $s0 contains the array address
	
	## ask for the array values
	la $a0, askStr4
	li $v0, 4
	syscall
	move $a0, $s1	# print(rows.length());
	li $v0, 1
	syscall
	li $a0, 'x'	# print (x)
	li $v0, 11
	syscall
	move $a0, $s2	# print(columns.length());
	li $v0, 1
	syscall
	la $a0, askStr4.5
	li $v0, 4
	syscall
	mul $t0, $s1, $s2	# $t0 = number of indexes
	move $t1, $s0
	enterElements:
		getInteger
		sw $v0, 0($t1)
		addu $t1, $t1, $s3
		addiu $t0, $t0, -1
		bnez $t0, enterElements
	# Array is ready, Going to the main menu
	mainMenu:
		la $a0, mainStr
		li $v0, 4
		syscall
		getInteger
	#	switch:	 	 # the labels switch and CPrintA will not be used.
	#		CPrintA: # Written for readability purposes.
				bne $v0, 1, cExchangeR
				jal printA
				j defult	# break
			cExchangeR:
				bne $v0, 2, cExchangeC
				jal ExchangeR
				j defult	# break
			cExchangeC:
				bne $v0, 3, cTerminate
				jal ExchangeC
				j defult	# break
			cTerminate:
				bne $v0, 4, defult
				li $v0, 10
				syscall
			defult:
				printNewLine
				j mainMenu
	# Print a 2d array
	# 	@param $a0 is array address
	#	@param $a1 number of rows
	#	@param $a2 number of columns
	#	@param $a3 element size			
	printA:
		jr $ra
		
	# Ask the user about which two columns to swap their elemnts into
	# each other and then print their values
	# 	@param $a0 is array address
	#	@param $a1 number of rows
	#	@param $a2 number of columns
	#	@param $a3 element size
	ExchangeR:
		jr $ra
	
	# Ask the user about which two columns to swap their elemnts into
	# each other and then print their values
	# 	@param $a0 is array address
	#	@param $a1 number of rows
	#	@param $a2 number of columns
	#	@param $a3 element size
	ExchangeC:
		jr $ra