|	Copyright (c) 2020 Christian Zietz <czietz@gmx.net>
|	
|	Permission is hereby granted, free of charge, to any person obtaining a copy
|	of this software and associated documentation files (the "Software"), to deal
|	in the Software without restriction, including without limitation the rights
|	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
|	copies of the Software, and to permit persons to whom the Software is
|	furnished to do so, subject to the following conditions:
|	
|	The above copyright notice and this permission notice shall be included in all
|	copies or substantial portions of the Software.
|	
|	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
|	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
|	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
|	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
|	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
|	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
|	SOFTWARE.

.text
	move.l	4(sp),a5		// Start of basepage
	move.l	#0x100,d5		// Length of basepage
	add.l	0xc(a5),d5		// Length of text
	add.l	0x14(a5),d5		// Length of data
	add.l	0x1c(a5),d5		// Length of BSS
	// we can skip setting up our own stack

	pea		newtrap1		// new GEMDOS handler
	move.w	#(0x84/4),-(sp) // TRAP #1, GEMDOS
	move.w	#5,-(sp)
	trap	#13				// Setexc
	addq.l	#8,sp
	move.l	d0,oldtrap1

	// print message and stay resident
	pea		msg
	move.w	#9,-(sp)
	trap	#1				// Cconws
	addq.l	#6,sp

	move.w	#0,-(sp)		// Return code
	move.l	d5,-(sp)		// Program size
	move.w	#0x31,-(sp)
	trap	#1				// Ptermres

	.ascii "XBRA"
	.ascii "SupF"
oldtrap1:
	.dc.l	0
newtrap1:
	move	sr,d0
	move	#0x2700,sr		// block interrupts
	// check SR on stack: were we called from supervisor mode?
	btst	#(13-8),(sp)	// note that BTST is a *byte* operation
	jbeq	callold			// no => call old handler
	lea		6(sp),a0		// pointer to arguments
	tst.w	0x59e.w			// __longframe
	jbeq	is68000
	addq.l	#2,a0			// skip additional exception stack frame word

is68000:
	cmp.w	#0x20,(a0)		// call to Super()?
	jbne	callold			// no => call old handler
	cmp.l	#1,2(a0)		// checking current Super status?
	jbne	callold			// no => call old handler
	moveq	#-1,d0			// YES, we are in supervisor mode
	rte						// note: will restore interrupts

callold:
	move.l	oldtrap1,-(sp)
	move	d0,sr			// restore interrupts
	rts						// jump to old handler

.data
msg:
	.asciz "Super() fix for USB drivers installed.\r\n"