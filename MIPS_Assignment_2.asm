.data
	askStr:		.asciiz	"Enter number of rows: "
	askStr2:	.asciiz	"Enter number of columns: "
	askStr3:	.asciiz	"Enter type of elements: "
	askStr4:	.asciiz	"\nEnter an array of "
	askStr4.5:	.asciiz	" integers:"
	askStr4.6:	.asciiz " chars:"
	mainStr:	.asciiz "Select one of the following functions:\n1. Print the entered array\n2. Exchange two rows\n3. Exchange two columns\n4. Exit the program"
	op1Str:		.asciiz "Array of "
	op1Str1.5:	.asciiz	" integers is:"
	op1Str1.6:	.asciiz	" chars is:"
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
	.macro errorText
		li $v0, 4
		la $a0, errorStr
		syscall
	.end_macro
	
	.macro getChar
		li $v0, 12	# read char
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
	getChar		# read char
	
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
	beq $s3,1, skip1 # to choose int or char
	la $a0, askStr4.5
	li $v0, 4
	syscall
	j j1
skip1:	la $a0, askStr4.6
	li $v0, 4
	syscall
j1:	mul $t0, $s1, $s2	# $t0 = number of indexes
	move $t1, $s0
	printNewLine
	enterElements:
		beq $s3,1, skip2
		getInteger
		sw $v0, 0($t1)
		j j2
	skip2:	getChar
		sb $v0, 0($t1)	
		printNewLine
	j2:	addu $t1, $t1, $s3
		addiu $t0, $t0, -1
		bnez $t0, enterElements
		printNewLine
	# Array is ready, Going to the main menu
	mainMenu:
		la $a0, mainStr
		li $v0, 4
		syscall
		printNewLine
		getInteger
	#	switch:	 	 # the labels switch and CPrintA will not be used.
	#		CPrintA: # Written for readability purposes.
				bne $v0, 1, cExchangeR
				move $a0, $s0
				move $a1, $s1
				move $a2, $s2
				move $a3, $s3
				jal printA
				j defult	# break
			cExchangeR:
				bne $v0, 2, cExchangeC
				move $a0, $s0
				move $a1, $s1
				move $a2, $s2
				move $a3, $s3
				jal ExchangeR
				j defult	# break
			cExchangeC:
				bne $v0, 3, cTerminate
				move $a0, $s0
				move $a1, $s1
				move $a2, $s2
				move $a3, $s3
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
		mul $t0, $a1, $a2	# $t0 = number of indexes
		move $t1, $a2		# $t1 will be counter of rows to make nextLine \n by reaching end of the column then nextline
		move $t2, $a0		# $t2 is array address
		
		lb $a0, 0($t2)
		
		li $v0, 4			## to print "Array of RxC integers is: "
		la $a0, op1Str			#
		syscall				#
						#
		li $v0, 1			#
		move $a0, $a1			#
		syscall				#
						#
		li $a0, 'x'			#
		li $v0, 11			#
		syscall				#
						#
		li $v0, 1			#
		move $a0, $a2			#
		syscall				#
						#
		beq $a3,1, skip3		#
		li $v0, 4			#
		la $a0, op1Str1.5
		syscall	
		j j3				#
	skip3:	li $v0, 4			#
		la $a0, op1Str1.6
		syscall				#
	j3:	printNewLine			## end of printing the string
		j loop1
		
		loopOut:mul $t0, $a1, $a2	# this for when it called from other method
			move $t1, $a2 
			move $t2, $a0
		loop1:	beq $a3,1, skip4
			lw $t3, 0($t2)		# load then print normal
			move $a0, $t3
			li $v0,1
			syscall
			j j4
		skip4:	lb $t3, 0($t2)
			move $a0, $t3
			li $v0,11
			syscall
		j4:	printWhiteSpace		#to add spaces
			addu $t2, $t2, $a3	#change the address for next loadword lw
			addiu $t0, $t0, -1	#decrease number of indexes
			addiu $t1, $t1, -1	#decrease number of counter row
			bnez $t1,continue	#if(counterOfRows == 0) printNewLine, then reset the row counter, else continue
			printNewLine		#to add newLine
			move $t1, $a2
      		continue:bnez $t0, loop1	#check if we reach to last index or not
		jr $ra
		
	# Ask the user about which two columns to swap their elemnts into
	# each other and then print their values
	# 	@param $a0 is array address
	#	@param $a1 number of rows
	#	@param $a2 number of columns
	#	@param $a3 element size
	ExchangeR:
		# Save the needed information
		sw $ra, 0($sp)
		addiu $sp, $sp, 4
		##### Start editing from here #####
		######################
		# You need to pass the arguments before calling, but since I didn't change
		# anything, I know that a0 to a3 have the needed parameters to call printA
		######################
		move $t0, $a0
		
     printFRow:	li $v0, 4			## to print "Enter the first row number: "
		la $a0, enterStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, firstStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, rowStr			#
		syscall				#
						#
		li $v0, 4			#
		la $a0, numberStr		#
		syscall				## end of printing the string
		
		# this algo to check a < rowSize && a >= 0 for first row
		getInteger	# $v0 row number
		bge $v0, $a1, error1
		bge $v0, $zero, continue1
	error1:	errorText
		j printFRow
	continue1:
		move $t1, $v0	# t1 is first row
		move $t7, $t1	# used when printing statment in 2 and 3 options
		mul $t1, $t1, $a2
		mul $t1, $t1, $a3
		addu $t1, $t0, $t1	# t1 is the index of first index of first selected row
		
printSRow:	li $v0, 4			## to print "Enter the second row number: "
		la $a0, enterStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, secondStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, rowStr			#
		syscall				#
						#
		li $v0, 4			#
		la $a0, numberStr		#
		syscall				## end of printing the string
		
		# this algo to check a < rowSize && a >= 0 for second row
		getInteger	# $v0 row number
		bge $v0, $a1, error2
		bge $v0, $zero, continue2
	error2:	errorText
		j printSRow
	continue2:
		move $t2, $v0 # t2 is second row
		move $t8, $t2	# used when printing statment in 2 and 3 options
		mul $t2, $t2, $a2
		mul $t2, $t2, $a3
		addu $t2, $t0, $t2	# t2 is the index of first index of second selected row
		
		li $t5,0	# t5 to reach a3 and stop loop
	loop2:	beq $a3,1, skip5
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t3, 0($t2)
		sw $t4, 0($t1)
		j j5
	skip5:	lb $t3, 0($t1)
		lb $t4, 0($t2)
		sb $t3, 0($t2)
		sb $t4, 0($t1)
	j5:	add $t1, $t1, $a3
		add $t2, $t2, $a3
		addi $t5, $t5, 1
		bne $t5, $a2, loop2
		
		li $v0, 4			## to print "The array after exchanging rows r and c"
		la $a0, resultStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, rowStr			#
		syscall				#
		printCharS			#
		printWhiteSpace			#
						#
		li $v0, 1			#
		move $a0, $t7			#
		syscall				#
						#
		li $v0, 4			#
		la $a0, andStr 			#
		syscall				#
						#
		li $v0, 1			#
		move $a0, $t8			#
		syscall				#
		printNewLine			## end of printing the string
		
		move $a0, $t0
		j loopOut
		
		
		#jal printA	# call printA
		##### Stop here #####
		# return the saved information
		addiu $sp, $sp, -4
		lw $ra, 0($sp)
		jr $ra
	
	# Ask the user about which two columns to swap their elemnts into
	# each other and then print their values
	# 	@param $a0 is array address
	#	@param $a1 number of rows
	#	@param $a2 number of columns
	#	@param $a3 element size
	ExchangeC:
		# Save the needed information
		sw $ra, 0($sp)
		addiu $sp, $sp, 4
		##### Start editing from here #####
		######################
		# You need to pass the arguments before calling, but since I didn't change
		# anything, I know that a0 to a3 have the needed parameters to call printA
		######################
		move $t0, $a0
		
     printFCol:	li $v0, 4			## to print "Enter the first column number: "
		la $a0, enterStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, firstStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, columnsStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, numberStr		#
		syscall				## end of printing the string
		
		# this algo to check column number out-of-range
		getInteger	# $v0 column number
		bge $v0, $a2, error1c
		bge $v0, $zero, continue1c
	error1c:errorText
		j printFCol
	continue1c:
		move $t1, $v0	# t1 is first col
		move $t7, $t1	# used when printing statment in 2 and 3 options
		mul $t1, $t1, $a3
		addu $t1, $t0, $t1	# t1 is the index of first index of first selected col
		
printSCol:	li $v0, 4			## to print "Enter the second column number: "
		la $a0, enterStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, secondStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, columnsStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, numberStr		#
		syscall				## end of printing the string
		
		# this algo to check column out-of-range
		getInteger	# $v0 col number
		bge $v0, $a2, error2c
		bge $v0, $zero, continue2c
	error2c:errorText
		j printSCol
	continue2c:
		move $t2, $v0 # t2 is second col
		move $t8, $t2	# used when printing statment in 2 and 3 options
		mul $t2, $t2, $a3
		addu $t2, $t0, $t2	# t2 is the index of first index of second selected col
		
		li $t5,0	# t5 to reach a1 and stop loop
		mul $t6, $a2, $a3
	loop2c:	beq $a3,1, skip6
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t3, 0($t2)
		sw $t4, 0($t1)
		j j6
	skip6:	lb $t3, 0($t1)
		lb $t4, 0($t2)
		sb $t3, 0($t2)
		sb $t4, 0($t1)
	j6:	add $t1, $t1, $t6
		add $t2, $t2, $t6
		addi $t5, $t5, 1
		bne $t5, $a1, loop2c
		
		li $v0, 4			## to print "The array after exchanging rows r and c"
		la $a0, resultStr		#
		syscall				#
						#
		li $v0, 4			#
		la $a0, columnsStr		#
		syscall				#
		printCharS			#
		printWhiteSpace			#
						#
		li $v0, 1			#
		move $a0, $t7			#
		syscall				#
						#
		li $v0, 4			#
		la $a0, andStr 			#
		syscall				#
						#
		li $v0, 1			#
		move $a0, $t8			#
		syscall				#
		printNewLine			## end of printing the string
		
		move $a0, $t0
		j loopOut
		
		#jal printA	# call printA
		##### Stop here #####
		# return the saved information
		addiu $sp, $sp, -4
		lw $ra, 0($sp)
		jr $ra

    
