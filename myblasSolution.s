# Enrique Tapia
# CS3240 lab 6
# Dr. Albert Cruz
# implements SSE instructions

	.file	"myblas.c"
	.text
	.globl	dewvm
	.type	dewvm, @function
dewvm:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)		#N
	movq	%rsi, -32(%rbp)		#x
	movq	%rdx, -40(%rbp)		#Y
	movq	%rcx, -48(%rbp)		#Result
	movl	$0, -4(%rbp)		#i = 0
	jmp	.L2
.L3:
# Recalcultes the current address each time
# *Result + 8 • I 
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax

# *X + 8 • I
	movl	-4(%rbp), %edx		#gets I
	movslq	%edx, %rdx			#promote to 64 bits
	leaq	0(,%rdx,8), %rcx
	movq	-32(%rbp), %rdx
	addq	%rcx, %rdx			#X += 8 • I
	movupd	(%rdx), %xmm1		

# *Y + 8 • I 
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movupd	(%rdx), %xmm0

	mulpd	%xmm1, %xmm0
	movupd	%xmm0, (%rax)
	addl	$2, -4(%rbp)		#I = I + 2ma
.L2:
	movl	-4(%rbp), %eax		#I
	cmpl	-20(%rbp), %eax		#N   If I is less than N
	jl	.L3
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	dewvm, .-dewvm
	.ident	"GCC: (Debian 6.3.0-18+deb9u1) 6.3.0 20170516"
	.section	.note.GNU-stack,"",@progbits
