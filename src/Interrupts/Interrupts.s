.code64

RAXTEMP: .quad 0x0

.global KeyboardInt
.global SystemTimerInt
.global ProcessSwitchInt
.global Exc0, Exc1, Exc2, Exc3, Exc4, Exc5
.global Exc6, Exc7, Exc8, ExcA, ExcB, ExcC
.global ExcD, ExcE, Exc10, Exc11, Exc12, Exc13
.global Exc14, Exc1E
.global SysCall, SwitchThread
	
KeyboardInt:
	PUSH %RBP
	PUSH %RAX
	PUSH %RCX
	PUSH %RBX
	PUSH %RDX
	PUSH %RSI
	PUSH %RDI
	PUSH %R8
	PUSH %R9
	PUSH %R10
	PUSH %R11
	PUSH %R12
	PUSH %R13
	PUSH %R14
	PUSH %R15
	PUSHF
	
	CALL KeyboardInterrupt
			
	POPF
	POP %R15
	POP %R14
	POP %R13
	POP %R12
	POP %R11
	POP %R10
	POP %R9
	POP %R8
	POP %RDI
	POP %RSI
	POP %RDX
	POP %RBX
	POP %RCX
	POP %RAX
	POP %RBP
	IRETQ
	
SystemTimerInt:
	PUSH %RBP
	PUSH %RAX
	PUSH %RCX
	PUSH %RBX
	PUSH %RDX
	PUSH %RSI
	PUSH %RDI
	PUSH %R8
	PUSH %R9
	PUSH %R10
	PUSH %R11
	PUSH %R12
	PUSH %R13
	PUSH %R14
	PUSH %R15
	PUSHF
	
	CALL SystemTimerInterrupt
		
	POPF
	POP %R15
	POP %R14
	POP %R13
	POP %R12
	POP %R11
	POP %R10
	POP %R9
	POP %R8
	POP %RDI
	POP %RSI
	POP %RDX
	POP %RBX
	POP %RCX
	POP %RAX
	POP %RBP
	IRETQ

################ Exception handlers ######################
Exc0:
	CALL DivideByZeroExc
	IRETQ
	
Exc1:
	POP %RAX
	CALL DebugExc
	IRETQ

Exc2:
	CALL NonMaskableExc
	IRETQ

Exc3:
	CALL BreakPointExc
	IRETQ

Exc4:
	CALL OverflowExc
	IRETQ

Exc5:
	CALL BoundRangeExc
	IRETQ

Exc6:
	CALL InvalidOpExc
	IRETQ

Exc7:
	CALL DeviceNotAvailExc
	IRETQ

Exc8:
	CALL DoubleFaultExc
	IRETQ

ExcA:
	CALL InvalidTSSExc
	IRETQ

ExcB:
	CALL SegNotPresentExc
	IRETQ

ExcC:
	CALL StackSegExc
	IRETQ

ExcD:
	MOV RAXTEMP, %RAX
	POP %RAX
	CALL GenProtExc
	MOV %RAX, RAXTEMP
	IRETQ
	
ExcE:
	MOV RAXTEMP, %RAX
	POP %RAX
	CALL PageFaultExc
	MOV %RAX, RAXTEMP
	IRETQ

Exc10:
	CALL x87FloatPExc
	IRETQ

Exc11:
	CALL AlignChkExc
	IRETQ

Exc12:
	CALL MachineChkExc
	IRETQ

Exc13:
	CALL SIMDFloatPExc
	IRETQ

Exc14:
	CALL VirtualExc
	IRETQ

Exc1E:
	CALL SecurityExc
	IRETQ
	
SysCall:
	PUSH %RBP
	PUSH %RCX
	PUSH %RBX
	PUSH %RDX
	PUSH %RSI
	PUSH %RDI
	PUSH %R8
	PUSH %R9
	PUSH %R10
	PUSH %R11
	PUSH %R12
	PUSH %R13
	PUSH %R14
	PUSH %R15
	PUSHF
	CALL SysCallSwitch
	POPF
	POP %R15
	POP %R14
	POP %R13
	POP %R12
	POP %R11
	POP %R10
	POP %R9
	POP %R8
	POP %RDI
	POP %RSI
	POP %RDX
	POP %RBX
	POP %RCX
	POP %RBP
	IRETQ

SwitchThread:
	PUSH %RBP
	PUSH %RAX
	PUSH %RCX
	PUSH %RBX
	PUSH %RDX
	PUSH %RSI
	PUSH %RDI
	PUSH %R8
	PUSH %R9
	PUSH %R10
	PUSH %R11
	PUSH %R12
	PUSH %R13
	PUSH %R14
	PUSH %R15
	PUSHF
	CALL SwitchProcesses
	POPF
	POP %R15
	POP %R14
	POP %R13
	POP %R12
	POP %R11
	POP %R10
	POP %R9
	POP %R8
	POP %RDI
	POP %RSI
	POP %RDX
	POP %RBX
	POP %RCX
	POP %RAX
	POP %RBP
	IRETQ
	
