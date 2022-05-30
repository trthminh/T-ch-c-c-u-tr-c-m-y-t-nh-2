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
sapxeptangdan: .ascii "Mang sau khi sap xep tang dan la: "
trungvi: .asciiz "Gia tri trung vi cua mang la: "
ppSapXep: .asciiz "Chon thuat toan ban muon sap xep (vui long chi chon 1 trong 2 lua chon o duoi)\n"
ppss1: .asciiz "1. Bubble Sort\n"
ppss2: .asciiz "2. Selection Sort\n"
XuongDong: .asciiz "\n"
	.text
	
main:

addi $t5, $zero, 100 # t5 l� gioi han so phan tu cua mang
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

la $s0, arr # s0 l� base cua mang
add $t6, $zero, $zero
add $t1, $zero, $zero # t1 l� bien i
 
addi $s7, $zero, 1 # de phuc vu cho viec xet chan le
add $s5, $zero, $zero # so so chan
add $s6, $zero, $zero # so so le

LoopNhap:
	beq $t1, $t0, ExitNhap # Neu t1 = so phan tu mang th� dung

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
		
		
		# Kiem tra so duoc nhap c� phai l� so kh�ng �m
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

la $s0, arr # s0 l� base cua mang
add $t1, $zero, $zero # t1 l� bien i

add $s3, $zero, $zero # max
add $s4, $zero, $zero # min

lw $t2, ($s0)
move $s3, $t2
move $s4, $t2

la $s0, arr # s0 l� base cua mang
add $t1, $zero, $zero # t1 l� bien i

add $t7, $zero, $zero # t7 l� tong cua mang
# In ra c�c phan tu trong mang
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
	
	li $v0, 4
	la $a0, XuongDong
	syscall 
	
# c�u l?nh y�u c?u ch?n gi� tr?
li $v0, 4
la $a0, ppSapXep
syscall

li $v0, 4
la $a0, ppss1
syscall

li $v0, 4
la $a0, ppss2
syscall
#----------------------------
li $v0, 5
syscall
move $t7, $v0 # t7 l� l?a ch?n

addi $t8, $zero, 1 # t8 = 1
beq $t7, $t8, BubbleSort # bubbleSort
addi $t8, $t8, 1 # t8 = 2
beq $t7, $t8, SelectionSort # selection sort
j Gohome


Gohome:

#----------------------------
BubbleSort:
	# xuat ra cau noi
	li $v0, 4
	la $a0, sapxeptangdan
	syscall

	# thuat toan sap xep
	add $t1, $zero, $zero # bien i l� bi?n ?? ki?m tra xem n� ?� x�t ?? c�c ph?n t? trong m?ng ch?a

	la $s0, arr # s0 la base cua mang khi xet thang i	


	# bubble sort
	loop_for_sort1:
		beq $t1, $t0, ExitSort
	
		lw $t3, ($s0) # t3 = a[i]
	
		la $s1, arr # s1 la base cua mang khi xet thang j
		addi $s1, $s0, 4
		addi $t2, $t1, 1 # t2 l� gi� tr? j ?? ki?m so�t n� c� v??t qu� gi?i h?n m?ng hay kh�ng
		loop_for_sort2:
			beq $t2, $t0, j_to_add_t1
			lw $t4, ($s1) # t4 = a[j]
		
			slt $t5, $t3, $t4 # t5 = (t3 < t4) ? 1 : 0
			beq $t5, $zero, DoiCho
		
			addi $s1, $s1, 4 # t?ng gi� tr? base cho v�ng for j l�n 4
			addi $t2, $t2, 1 # t?ng gi� tr? j l�n 1
			j loop_for_sort2 
		
		DoiCho: 
			# thay ??i gi� tr? t?i m?ng arr
			sw, $t3, ($s1)
			sw, $t4, ($s0)

			# swap gi� tr? t3 v� t4 cho nhau
			move $t5, $t3
			move $t3, $t4
			move $t4, $t5 
		
			addi $s1, $s1, 4
			addi $t2, $t2, 1
			j loop_for_sort2
		
		j_to_add_t1:
			# ph?c v? cho vi?c x�t ti?p v? tr� ti?p theo cho i
			addi $t1, $t1, 1 # t?ng i l�n 1
			addi $s0, $s0, 4
			j loop_for_sort1


	ExitSort:	
	
	la $s0, arr # s0 l� base cua mang
	add $t1, $zero, $zero # t1 l� bien i


	LoopXuatSauKhiSapXep:
		beq $t1, $t0, ExitXuatss # check nhap du phan tu hay chua
	
		lw $t2, ($s0) # t2 = A[i]
	
		li $v0, 1
		la $a0, ($t2)
		syscall

	
		li $v0, 4
		la $a0, KhoangCach		
		syscall
	

		addi $t1, $t1, 1 # tang i len 1
		addi $s0, $s0, 4 # tang base len 4 
		j LoopXuatSauKhiSapXep		
		
	ExitXuatss:
		j TrungVi


#----------------------------------------------------------------
# selection sort
SelectionSort:
	la $s0, arr # base cho v? tr� i
	la $s2, arr # base t?m ???c d�ng ?? khi ??i v? tr�
	add $t1, $zero, $zero # v? tr� i
	loop_for_ss1:
		beq $t1, $t0, ExitSelectionSort
	
		lw $t3, ($s0) # t3 = a[i]
		
		la $s1, arr # s1 la base cua mang khi xet thang j
		addi $s1, $s0, 4
		addi $t2, $t1, 1 # t2 l� gi� tr? j ?? ki?m so�t n� c� v??t qu� gi?i h?n m?ng hay kh�ng
		loop_for_ss2:
			beq $t2, $t0, DoiChoSS
			lw $t4, ($s1) # t4 = a[j]
			lw $t7, ($s2) # t7 = a[min]
				
			slt $t5, $t7, $t4 # a[min] < a[j] -> khong thay doi
			beq $t5, $zero, UpdateValueMin
		
			addi $s1, $s1, 4 # t?ng gi� tr? base cho v�ng for j l�n 4
			addi $t2, $t2, 1 # t?ng gi� tr? j l�n 1
			j loop_for_sort2 
		
		UpdateValueMin: # t7 = min, t4 = j
			add $s2, $s2, $s1 # cap nhat lai min = j
			addi $s1, $s1, 4 # t?ng gi� tr? base cho v�ng for j l�n 4
			addi $t2, $t2, 1 # t?ng gi� tr? j l�n 1
			j loop_for_sort2 
	
		DoiChoSS: 
			# thay ??i gi� tr? t?i m?ng arr
			sw $t3, ($s2)
			sw $t7, ($s0)

			# swap gi� tr? t3 v� t4 cho nhau
			move $t5, $t3
			move $t3, $t7
			move $t7, $t5 
		
			addi $s1, $s1, 4
			addi $t2, $t2, 1
		
			# ph?c v? cho vi?c x�t ti?p v? tr� ti?p theo cho i
			addi $t1, $t1, 1 # t?ng i l�n 1
			addi $s0, $s0, 4
			addi $s2, $s2, 4
			j loop_for_sort1

	ExitSelectionSort:
	
	
	
	la $s0, arr # s0 l� base cua mang
	add $t1, $zero, $zero # t1 l� bien i


	XuatSeletionSort:
		beq $t1, $t0, ExitXuatSelectionSort # check nhap du phan tu hay chua
	
		lw $t2, ($s0) # t2 = A[i]
	
		li $v0, 1
		la $a0, ($t2)
		syscall

	
		li $v0, 4
		la $a0, KhoangCach		
		syscall
	

		addi $t1, $t1, 1 # tang i len 1
		addi $s0, $s0, 4 # tang base len 4 
		j XuatSeletionSort		
		
	ExitXuatSelectionSort:
		j TrungVi


#-----------------------------------
# tim trung vi cua mang
TrungVi:
	li $v0, 4
	la $a0, XuongDong
	syscall

	li $v0, 4
	la $a0, trungvi
	syscall
	addi $t0, $t0, 1
	srl $t0, $t0, 1 # phan tu trung vi

	la $s0, arr # base c?a m?ng
	add $t1, $zero, $zero # bien i

	loopFindMid:
		beq $t1, $t0, xuatTrungVi # i == t0 -> den vi tri trung vi
		lw $t2, ($s0) # t2 = a[i]
	
		# x�t ti?p v? tr� ti?p theo
		addi $t1, $t1, 1 # t?ng i l�n 1 ??n v?
		addi $s0, $s0, 4
		j loopFindMid
	
	xuatTrungVi:
		li $v0, 1
		la $a0, ($t2)
		syscall 















































