	.data
string1: .asciiz "Nhap so phan tu mang (be hon 100): "

pti: .asciiz "Nhap phan tu thu"
xuatmang: .asciiz "Mang ban vua nhap la:\n"
KhoangCach: .asciiz " "
HaiCham: .asciiz ": "


	.align 4
arr: .space 400 # Tao mang so nguyen gom 100 phan tu

string4: .asciiz "Phan tu phai la so duong. Vui long nhap lai!\n"
string5: .asciiz "So khong hop le, vui long nhap lai!\n"
string6: .asciiz "Tong cua mang la: "
chan: .asciiz "So so chan cua mang: "
le: .asciiz "So so le cua mang: "
max: .asciiz "So lon nhat trong mang: "
min: .asciiz "So be nhat trong mang: "

XuongDong: .asciiz "\n"
	.text
	
main:

addi $t5, $zero, 100 # t5 là gioi han so phan tu cua mang
addi $t6, $zero, 1

Nhapsopt:
	# in thong bao nhap
	li $v0, 4
	la $a0, string1
	syscall

	li $v0, 5
	syscall
	move $t0, $v0 # t0 la so phan tu
	
	# kiem tra dieu kien
	slt $t3, $t5, $t0 # 100 < t0
	slt $t4, $t0, $t6 # t0 < 1

	or $t3, $t3, $t4
	beq $t3, $zero, thoatnhapsopt
	
	# neu khong thoa dieu kien thi nhap lai so phan tu
	li $v0, 4
	la $a0, string5
	syscall
	
	j Nhapsopt

thoatnhapsopt:

la $s0, arr # s0 là base cua mang
add $t6, $zero, $zero
add $t1, $zero, $zero # t1 là bien i
 
addi $s7, $zero, 1 # de phuc vu cho viec xet chan le
add $s5, $zero, $zero # so so chan
add $s6, $zero, $zero # so so le

LoopNhap:
	beq $t1, $t0, ExitNhap # Neu t1 = so phan tu mang thì dung

	Nhappt:
		# Nhap phan tu thu i
		li $v0, 4
		la $a0, pti
		syscall


		li $v0, 4
		la $a0, KhoangCach
		syscall
		
		li $v0, 1
		la $a0, ($t1)
		syscall

		li $v0, 4
		la $a0, HaiCham
		syscall
			
		# Nhap phan tu thu i
		li $v0, 5
		syscall
		
		move $t2, $v0 # t2 = A[i]
		
		
		# Kiem tra so duoc nhap có phai là so không âm
		slt $t3, $zero, $v0 # 0 < v0 -> 1
		add $t6, $zero, $zero # gan t6 = 0
		addi $t6, $t6, 1 # t6 = 1
		beq $t3, $t6, ThoatNhap # > 0, sau do nhap phan tu tiep theo
		
		li $v0, 4
		la $a0, string4
		syscall
		
		j Nhappt
		
	ThoatNhap:
	
	sw $t2, ($s0)


	addi $t1, $t1, 1 # tang bien dem i len 1
	addi $s0, $s0, 4 # tang gia tri base len 4 
	j LoopNhap

ExitNhap:
	li $v0, 4
	la $a0, KhoangCach
	syscall

la $s0, arr # s0 là base cua mang
add $t1, $zero, $zero # t1 là bien i

add $s3, $zero, $zero # max
add $s4, $zero, $zero # min

lw $t2, ($s0)
move $s3, $t2
move $s4, $t2

la $s0, arr # s0 là base cua mang
add $t1, $zero, $zero # t1 là bien i

add $t7, $zero, $zero # t7 là tong cua mang
# In ra các phan tu trong mang
li $v0, 4
la $a0, xuatmang
syscall



LoopXuat:
	beq $t1, $t0, ExitXuat # check nhap du phan tu hay chua
	
	lw $t2, ($s0) # t2 = A[i]
	
	li $v0, 1
	la $a0, ($t2)
	syscall
	
	add $t7, $t7, $t2
	
	andi $t8, $t2, 1 # t2 = 0 thi no la so chan
	beq $t8, $zero, SoChan # tinh so so chan
	
	addi $s6, $s6, 1 # tinh so so le
	
	# tim max min
	
	slt $t9, $t2, $s3 # if t2 < max -> capnhat, 0 thi cap nhat
	bne $t9, $zero, ContinueXetMin 
	move $s3, $t2
	
	slt $t9, $s4, $t2 # min < t2, 0 thi cap nhat
	bne $t9, $zero, Continue
	move $s4, $t2
	
	li $v0, 4
	la $a0, KhoangCach		
	syscall
	
		

	addi $t1, $t1, 1 # tang i len 1
	addi $s0, $s0, 4 # tang base len 4 
	j LoopXuat

ContinueXetMin:
	slt $t9, $s4, $t2 # min < t2, 0 thi cap nhat
	bne $t9, $zero, Continue
	move $s4, $t2
	
	li $v0, 4
	la $a0, KhoangCach		
	syscall

	addi $t1, $t1, 1 # tang i len 1
	addi $s0, $s0, 4 # tang base len 4 
	j LoopXuat
	
Continue:
	li $v0, 4
	la $a0, KhoangCach		
	syscall

	addi $t1, $t1, 1 # tang i len 1
	addi $s0, $s0, 4 # tang base len 4 
	j LoopXuat

SoChan:
	addi $s5, $s5, 1
	# tim max min
	
	slt $t9, $t2, $s3 # if t2 < max -> capnhat, 0 thi cap nhat
	bne $t9, $zero, ContinueXetMin 
	move $s3, $t2
	
	slt $t9, $s4, $t2 # min < t2, 0 thi cap nhat
	bne $t9, $zero, Continue
	move $s4, $t2
	
	li $v0, 4
	la $a0, KhoangCach		
	syscall
	
	
	addi $t1, $t1, 1 # tang i len 1
	addi $s0, $s0, 4 # tang base len 4 
	j LoopXuat

ExitXuat:
	# in dau xuong dong
	li $v0, 4
	la $a0, XuongDong
	syscall
	# in cau xuat tong
	li $v0, 4
	la $a0, string6
	syscall
	
	# in tong cua mang
	li $v0, 1
	move $a0, $t7
	syscall
	
	li $v0, 4
	la $a0, XuongDong
	syscall
	
	# in so so chan cua mang
	li $v0, 4
	la $a0, chan
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, XuongDong
	syscall
	
	#in so so le
	li $v0, 4
	la $a0, le
	syscall
	
	li $v0, 1
	move $a0, $s6
	syscall
	
	li $v0, 4
	la $a0, XuongDong
	syscall
	
	# in so lon nhat trong mang
	li $v0, 4
	la $a0, max
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, XuongDong
	syscall
	
	# in so be nhat trong mang
	li $v0, 4
	la $a0, min
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	



	

















































