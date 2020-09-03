################################################################################
## selection-sort method to sort an array			       	      ##
## which is valued for 4 integer (hardcoded).				      ##
## assignment3_CS3340.005						      ##
## Name(Last, First): Ziaei, Armin					      ##
## Net-ID(email): axz172330@utdallas.edu				      ##
################################################################################

	
	
.data
array:  .space 16 	#allocate space for 4 integer.(4*4=16);
length: .word  4	#length of array;

newLine: .asciiz "\n"
space:  .asciiz " "
after:  .asciiz "\n\nSorted Array A[3]:\n"
before: .asciiz "Unsorted Array A[3]:\n"

.text	
.globl main

main:	
	la $t1,array		# set array address to $t1 (myArray[3]);
	li $s0,8		# load immediate integer 8 	to $s0
	li $s1,12		# load immediate integer 12 	to $s1
	li $s2,5		# load immediate integer 5	to $s2
	li $s3,2		# load immediate integer 8 	to $s3

	# int myArray[3] = {$s0, $s1, $s2, $s2};
	# int myArray[3] = {8, 12, 5, 2};

	sw $s0,0($t1)	# store word $s0 to myArray[0];
	sw $s1,4($t1)	# store word $s1 to myArray[1];
	sw $s2,8($t1)	# store word $s2 to myArray[2];
	sw $s3,12($t1)	# store word $s3 to myArray[3];
	li $v0, 4	# system call
	la $a0, before	# to print before string
	syscall			
	
	# lable print; getting address of each element and print it.
	jal print		# subroutine prints all elements in array 

	# assume k to $t5 for making loop
	li $t5, 0	# load immediate integer 0 	to $t5
	la $t7, length  # load address of lenght 	to $t7   
    	lw $t7, 0($t7)  # load word length		to $t7
	
	addi $t8, $t7, -1  	# $t8 = length - 1
	la $t6, ($t1)		# $t6 = address of the myArray[].

outerLoop: 
	slt $t0, $t5, $t8	   	# if (k < length - 1) {$t0 = 1}
	beq $t0, $zero, breakOuterLoop 	# k >= (length - 1)
	add $t9, $zero, $t5 		# $t9 is (min = k)

	addi $t1, $t5, 1     		# $t1 is (j = k + 1)
  
innerLoop: 
	slt $t0, $t1, $t7   	# if (j < length) {$t0 = 1}
	beq $t0, $zero, breakInnerLoop

	add $s3, $t9, $t9   # $s3 = 2 * min
	add $s3, $s3, $s3   # $s3 = 4 * min
	add $s3, $t6, $s3   # $s3 is address of list[min]
	lw $t2, 0($s3)      # $t2 is list[min]

	add $s0, $t1, $t1   # $s0 = 2 * j
	add $s0, $s0, $s0   # $s0 = 4 * j
	add $s0, $t6, $s0   # $s0 is address of list[j]
	lw $t3, 0($s0)      # $t3 is list[j]

	slt $t0, $t3, $t2   		# if (list[j] < list[min]) {$t0 = 1}
	beq $t0, $zero, secondIF 	# skip min = j & ++j and jump to secondIF
	add $t9, $zero, $t1 		# min = j
	j secondIF

secondIF: 
	beq $t9, $t5, incrementJ # if(min!=k) {swap}, else {goto incrementJ}

	#SWAP :
	add $s0, $t9, $t9   # $s0 = 2 * min
	add $s0, $s0, $s0   # $s0 = 4 * min
	add $s0, $s0, $t6   # $s0 = address of list[min]
	lw $t4, 0($s0)     # $t4 is temp = list[min]

	add $s1, $t5, $t5   # $s1 = 2 * k
	add $s1, $s1, $s1   # $s1 = 4 * k
	add $s1, $t6, $s1   # $s1 = address of list[k]
	lw $s3, 0($s1)     # $s3 = list[k]
	sw $s3, 0($s0)     # list[min] = list[k]
	sw $t4, 0($s1)     # list[k] = temp 
	addi $t1, $t1, 1	# ++j
	add $t9, $zero, $t5 	# $t9 is (min = k)	 
	
	j innerLoop	

incrementJ: 
	addi $t1, $t1, 1    # ++j
	j innerLoop

breakInnerLoop: 
	addi $t5, $t5, 1 	# ++k
	j outerLoop
	
breakOuterLoop: 
	li $v0, 4		# system call
	la $a0, after		# to print after string
	syscall			
	
	jal print		# subroutine prints all elements in array 
	j exitProgram			

print:	
	li $t5, 0	# k = 0
	la $t6, array	# $t6 = address of the array
	la $t7, length  # load address of length to $t7    
	lw $t7, 0($t7)	# $t7 = length 

loop:
	slt $t0, $t5, $t7		# if (k < length) {$t0 = 1}
	beq $t0, $0, printExit		# if (k >= 10) {exit}
	li $v0, 1			# print an integer
	lw $a0, 0($t6)			# address of integer in $a0
	syscall
	addi $t6, $t6,4			# increment address of array by 4(next integer)
	addi $t5, $t5,1			# k++
	li $v0, 4			# print a newline after each int
	la $a0, space			# address of space string
	syscall
	j loop

printExit: 
	jr $ra

exitProgram:
	li $v0, 10		# system call to
	syscall			# run program
