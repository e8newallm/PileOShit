.code32

.global BootStart
.global GDTData
.global GDTTSS

.data
	GDT:
    .quad 0            #Null Descriptor - should be present.
    .quad 0b10100000100110000000000000000000000000000000000000000000 	#64-bit code descriptor. (RING 0)
    .quad 0b10000000100100100000000000000000000000000000000000000000 	#64-bit data descriptor. (RING 0)

	.quad 0b10100000111110000000000000000000000000000000000000000000	#64-bit code descriptor. (RING 3)
	GDTData:
    .quad 0b10000000111100100000000000000000000000000000000000000000	#64-bit data descriptor. (RING 3)
	GDTTSS:
	.quad 0b0
	.quad 0b0	#64-bit TSS entry
	GDTPointer:
    .word . - GDT - 1                    #16-bit Size (Limit) of GDT.
	.quad GDT
	
.section .text

BootStart:
	CLI
	MOV %EBX, mbd
	
	#Make sure Paging is disabled
	MOV %CR0, %EAX
	AND $0b01111111111111111111111111111111, %EAX
	MOV %EAX, %CR0
	
	#Check CR3 bits [0-11] are 000h
	MOV %CR3, %EAX
	AND $0x00, %EAX
	MOV %EAX, %CR3 
	
	#Enable Physical Address Extension
	MOV %CR4, %EAX
	OR $0x00020, %EAX
	MOV %EAX, %CR4
	
	#Load CR3 with Physical base address of Level 4 page map table (PML4)
	LEA (PML4), %EAX
	MOV %EAX, %CR3
	
	#Enable IA-32e
	MOV $0xC0000080, %ECX 
	RDMSR
	OR $0b100000000, %EAX
	WRMSR
	
	#Re-enable Paging
	MOV %CR0, %EAX
	OR $0b10000000000000000000000000000001, %EAX
	MOV %EAX, %CR0
	
	MOVL StackBase, %EBP
	MOVL StackBase, %ESP

	LGDT (GDTPointer)
	MOV $0x10, %AX
	MOV %AX, %DS
	MOV %AX, %SS
	MOV %AX, %ES
	MOV %AX, %FS
	MOV %AX, %GS
	LJMP $0x0008, $Kernel_Start
