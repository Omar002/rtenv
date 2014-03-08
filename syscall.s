	.syntax unified
	.cpu cortex-m3
	.fpu softvfp
	.thumb


.macro SYSCALL syscall_name syscall_number 
	.global \syscall_name
\syscall_name:
	push {r7}
	mov r7, \syscall_number
	svc 0
	pop {r7}
	bx lr
.endm

SYSCALL fork 0x1
SYSCALL getpid 0x2
SYSCALL write 0x3
SYSCALL read 0x4
SYSCALL interrupt_wait 0x5
SYSCALL getpriority 0x6
SYSCALL setpriority 0x7
SYSCALL mknod 0x8
SYSCALL sleep 0x9
SYSCALL new_task 0xa
