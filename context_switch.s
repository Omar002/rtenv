	.syntax unified

	.type	SysTick_Handler, %function
	.global SysTick_Handler
	.type	USART2_IRQHandler, %function
	.global USART2_IRQHandler
SysTick_Handler:
USART2_IRQHandler:
	mrs r0, psp
	stmdb r0!, {r7}

	/* Get ISR number */
	mrs r7, ipsr
	neg r7, r7

	/* save user state */
	stmdb r0!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}

	/* load kernel state */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr}
	msr psr, ip

	bx lr

	.type	SVC_Handler, %function
	.global SVC_Handler
SVC_Handler:
	/* save user state */
	mrs r0, psp
	
	/*
	 * this r7 is used for padding
	 * hardware interrupt need r7 and activate pop r7 so SVC store it
	 */
	stmdb r0!, {r7}
	stmdb r0!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}

	/* load kernel state */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr}
	msr psr, ip
	
	/* jump to the next line where activate is called */
	bx lr

	.global activate
activate:
	/* save kernel state */
	mrs ip, psr
	push {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr}
	
	/* switch to process stack pointer */
	/* reference: Cortex-M3 Devices Generic User Guide Core registers */
	msr psp, r0
	mov r0, #3
	msr control, r0
	
	/* load user state */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, lr}
	pop {r7}

	bx lr
