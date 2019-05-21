.data 
# Data declaration section
_msg0: .asciiz "Unsorted Array"
_msg1: .asciiz "Sorted Array"
_newline: .asciiz "\n"
_spaces: .asciiz " "
msg1: .asciiz "Enter the number of elements: "
msg2: .asciiz "Enter elements: "
msg3: .asciiz "Performing MergeSort........ "


Array1: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
Array2: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

.text
.globl main
main:

jal input

addi $sp, $sp, -4     # make room on the stack for return address
sw $ra, 0($sp)        # save the return address
#Load array address
la $a0, Array2        # address of temp array
la $a1, Array1        # load address of unsorted array
add $a2, $zero, $v1   # load size of array into $a2
and $a3, $zero, $zero # initializing low = 0
or $t0, $a1, $zero    # address of unsorted array
or $t3, $a2, $zero    # array length
#Print message
li $v0, 4             # system call code for print_str
la $a0, _msg0         # address of string to print
syscall
#Print newline
li $v0, 4             # system call code for print_str
la $a0, _newline      # address of string to print
syscall



and $t4, $zero, $zero # set i to 0
j LoopPrintUn         # jump to print unsorted array





.end main




PrepSort:

li $v0, 4             
la $a0, _newline    # Newline 
syscall 

li $v0, 4             
la $a0, msg3        # display(print_str) msg for msg3 
syscall 

la $a0, Array2      # reinitialized because of msg

addi $sp, $sp, -16    # make room on the stack
sw $ra, 0($sp)        # return address
sw $a1, 8($sp)        # save address unsorted array
add $a2, $a2, -1      # setting $a2 to (high - 1)
sw $a2, 4($sp)        # save the size of the (array-1)
sw $a3, 0($sp)        # low parameter
jal MSORT             # jump to merge sort with arguments (array, high, low)

PrintSorted:

#Print newline
li $v0, 4             # system call code for print_str
la $a0, _newline      # address of string to print
syscall               # print the string
#Print message
li $v0, 4             # system call code for print_str
la $a0, _msg1         # address of string to print
syscall
#Print newline
li $v0, 4             # system call code for print_str
la $a0, _newline      # address of string to print
syscall
and $t7, $zero, $zero # set i to 0
jal LoopPrintSort     # jump to print the sorted array




LoopPrintUn:          # print unsorted array

#While (i < length)

slt $t6, $t4, $a2     # if i < the length of the array
beq $t6, $zero, PrepSort # if (length <= i) then jump to prep for merge sort

# Load Array[i] and print it
sll $t0, $t4, 2       # i * 4
add $t6, $a1, $t0     # base address of array + offest 

li $v0, 1             # system call code for print_int
lw $a0, 0($t6)        # shift amount array itme
syscall               # print it
#Print spaces
li $v0, 4             # system call code for print_str
la $a0, _spaces       # address of string to print
syscall
addi $t4, $t4, 1      # i ++
j LoopPrintUn         # loop print for unsorted array


LoopPrintSort:        # print sorted array

#While (i < length)
slt $t6, $t7, $v1      # if i < the length of the array
beq $t6, $zero, EndProgram # if (length <= i) then exit loop
sll $t0, $t7, 2       # i * 4
add $t6, $a1, $t0     # base address of array + offest
li $v0, 1             # system call code for print_int
lw $a0, 0($t6)        # shift amount array itme
syscall               # print array [i]
#Print spaces
li $v0, 4             # system call code for print_str
la $a0, _spaces       # address of string to print
syscall
addi $t7, $t7, 1      # i ++
j LoopPrintSort     # loop print

EndProgram:
addi $sp, $sp, 20     # pop all items from the stack in main
li $v0, 10            # END OF PROGRAM
syscall               # END OF PROGRAM


MSORT:

addi$sp, $sp, -20     # make room on the stack
sw $ra, 16($sp)       # save return address
sw $s1, 12($sp)       # save arguments unsorted array address
sw $s2, 8($sp)        # save arguments size of array = high

sw $s3, 4($sp)        # save low size of array
sw $s4, 0($sp)        # save register for mid
or $s1, $zero, $a1    # $s1 <- array address
or $s2, $zero, $a2    # $s2 <- size of array - 1 = high
or $s3, $zero, $a3    # $s3 <- low size
slt $t3, $s3, $s2     # low < high
beq $t3, $zero, DONE  # if $t3 == 0, DONE
add $s4, $s3, $s2     # low + high
div $s4, $s4, 2       # $s4 <- (low+high)/2
or $a2, $zero, $s4    # argument low
or $a3, $zero, $s3    # argument mid
jal MSORT             # recursive call for (array, low, mid)
# mergesort (a, mid+1, high)

addi$t4, $s4, 1       # argument mid +1
or $a3, $zero, $t4    # low gets (mid+1)
or $a2, $zero, $s2    # high gets high
jal MSORT             # recursive call for (a, mid+1, high)
or $a1, $zero, $s1    # Argument 1 gets array address
or $a2, $zero, $s2    # Argument 2 gets high
or $a3, $zero, $s3    # Argument 3 gets low
or $a0, $zero, $s4    # Argument 4 gets mid
jal MERGE             # jump to merge (array, high, low, mid)


DONE:
lw $ra, 16($sp)       # load return address
lw $s1, 12($sp)       # load arguments array address
lw $s2, 8($sp)        # load arguments size of array = high
lw $s3, 4($sp)        # low size of array
lw $s4, 0($sp)        # register for mid
addi $sp, $sp, 20     # clear room on the stack
jr $ra                # jump to register

MERGE:
addi$sp, $sp, -20     # make room on the stack
sw $ra, 16($sp)       # save return address
sw $s1, 12($sp)       # save arguments unsorted array address
sw $s2, 8($sp)        # save arguments size of array = high
sw $s3, 4($sp)        # save low size of array
sw $s4, 0($sp)        # save register for mid
or $s1, $zero, $a1    # array address
or $s2, $zero, $a2    # $s2 <- size of array = high
or $s3, $zero, $a3    # $s3 <- low size
or $s4, $zero, $a0    # $s4 <- mid
or $t1, $zero, $s3    # i= $t1 gets low
or $t2, $zero, $s4    # j= $t2 gets mid
addi$t2, $t2, 1       # j= $t2 gets mid + 1
or $t3, $zero, $a3    # k = low
WHILE:
slt $t4, $s4, $t1      # mid < i (i>=mid)
bne $t4, $zero, while2 # go to while 2 if i >= mid
slt $t5, $s2, $t2      # high < j (j>=high)
bne $t5, $zero, while2 # && go to while 2 if j >= high
sll $t6, $t1, 2       # i*4
add $t6, $s1, $t6     # $t6 = address a[i]
lw $s5, 0($t6)        # $s5 = a[i]
sll $t7, $t2, 2       # j*4
add $t7, $s1, $t7     # $t7 = address a[j]
lw $s6, 0($t7)        # $s6 = a[j]
slt $t4, $s5, $s6     # a[i] < a[j]
bne $t4, $zero, ELSE  # go to else if a[i] >= a[j}
sll $t8, $t3, 2       # k*4
la $a0, Array2        # load address of temporary array (neccasary if using $a0 for print statements)
add $t8, $a0, $t8     # $t8 = address c[k]
sw $s5, 0($t8)        # c[k] = a[i]
addi $t3, $t3, 1      # k++
addi $t1, $t1, 1      # i++
j WHILE


ELSE:
sll $t8, $t3, 2       # i*4
la $a0, Array2        #load address of temporary array (neccasary if using $a0 for print statements)
add $t8, $a0, $t8     # $t8 = address c[k]
sw $s6, 0($t8)        # c[k] = a[j]
addi $t3, $t3, 1      # k++
addi $t2, $t2, 1      # j++
j WHILE

while2:
slt $t4, $s4, $t1     # mid < i (i>=mid)
bne $t4, $zero, while3 # go to while3 if i >= mid
sll $t6, $t1, 2       # i*4
add $t6, $s1, $t6     # $t6 = address a[i]
lw $s5, 0($t6)        # $s5 = a[i]
sll $t8, $t3, 2       # i*4
la $a0, Array2        # load address of temporary array (neccasary if using $a0 for print statements)
add $t8, $a0, $t8     # $t8 = address c[k]
sw $s5, 0($t8)        # c[k] = a[i]
addi $t3, $t3, 1      # k++
addi $t1, $t1, 1      # i++
j while2

while3:
slt $t5, $s2, $t2     # high < j (j>=high)
bne $t5, $zero, start # go to for loop if j >= high
sll $t7, $t2, 2       # i*4
add $t7, $s1, $t7     # $t7 = address a[j]
lw $s6, 0($t7)        # $s6 = a[j]
sll $t8, $t3, 2       # i*4
la $a0, Array2        # load address of temporary array (neccasary if using $a0 for print statements)
add $t8, $a0, $t8     # $t8 = address c[k]
sw $s6, 0($t8)        # c[k] = a[j]
addi $t3, $t3, 1      # k++
addi $t2, $t2, 1      # j++
j while3

start:
or $t1, $zero, $s3    # i <- low

forloop:
slt $t5, $t1, $t3     # i < k
beq $t5, $zero, DONE  # branch if merging is complete
sll $t6, $t1, 2       # i*4
add $t6, $s1, $t6     # $t6 = address a[i]
sll $t8, $t1, 2       # i*4
la $a0, Array2        # load address of temporary array (neccasary if using $a0 for print statements)
add $t8, $a0, $t8     # $t8 = address c[i]
lw $s7, 0($t8)        # $s7 = c[i]
sw $s7, 0($t6)        # a[i]
addi $t1, $t1, 1      # i++
j forloop






















.globl input
.ent input
input:

li $v0,4
la $a0,msg1
syscall

li $v0,5
syscall
move $v1,$v0

li $v0,4
la $a0,msg2
syscall

li $a0,0
li $s1,0
while_input:
bge $a0,$v1,Exxx
li $v0,5
syscall

sw $v0,Array1($s1)

sw $0,Array2($s1)


addi $s1,$s1,4
addi $a0,$a0,1
j while_input

Exxx:
li $a0,0
li $s1,0
li $v0,0
jr $ra

.end input






