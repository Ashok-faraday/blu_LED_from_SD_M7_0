/*****************************************************************************
 *
 * Copyright 2019-2022 NXP
 * All Rights Reserved
 *
 *****************************************************************************
 *
 * THIS SOFTWARE IS PROVIDED BY NXP "AS IS" AND ANY EXPRESSED OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL NXP OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 *
 ****************************************************************************/

__STACK_SIZE = 0x00001000;
__HEAP_SIZE  = 0x00001000;

/* Linker script to configure memory regions. */
MEMORY
{
	CM7_0_RAM (rw) : ORIGIN = 0x34001000, LENGTH = 0x0FF000
	CM7_1_RAM (rw) : ORIGIN = 0x34100000, LENGTH = 0x100000
	CM7_2_RAM (rw) : ORIGIN = 0x34200000, LENGTH = 0x100000
}

/* Linker script to place sections and symbol values. Should be used together
 * with other linker script that defines memory regions RAM.
 * It references following symbols, which must be defined in code:
 *   Reset_Handler : Entry of reset handler
 *
 * It defines following symbols, which code can use without definition:
 *   __exidx_start
 *   __exidx_end
 *   __ecc_table_start__
 *   __ecc_table_end__
 *   __etext
 *   __data_start__
 *   __preinit_array_start
 *   __preinit_array_end
 *   __init_array_start
 *   __init_array_end
 *   __fini_array_start
 *   __fini_array_end
 *   __data_end__
 *   __bss_start__
 *   __bss_end__
 *   __end__
 *   end
 *   __HeapLimit
 *   __StackLimit
 *   __StackTop
 *   __stack
 */
ENTRY(Reset_Handler)

SECTIONS
{
	.text :
	{
		KEEP(*(.vectors))
		*(.text*)

		KEEP(*(.init))
		KEEP(*(.fini))

		/* .ctors */
		*crtbegin.o(.ctors)
		*crtbegin?.o(.ctors)
		*(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
		*(SORT(.ctors.*))
		*(.ctors)

		/* .dtors */
 		*crtbegin.o(.dtors)
 		*crtbegin?.o(.dtors)
 		*(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
 		*(SORT(.dtors.*))
 		*(.dtors)

		*(.rodata*)
		KEEP(*(.eh_frame*))
	} > CM7_0_RAM

	.ARM.extab :
	{
		*(.ARM.extab* .gnu.linkonce.armextab.*)
	} > CM7_0_RAM

	__exidx_start = .;
	.ARM.exidx :
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	} > CM7_0_RAM
	__exidx_end = .;

	.ecc.table :
	{
		. = ALIGN(4);
		__ecc_table_start__ = .;
		
		/* ECC memory for .data section is initialized during copying of application image
		QUAD (__data_start__)
		QUAD ((__data_end__ - __data_start__) / 8) */

		QUAD (__bss_start__)
		QUAD ((__bss_end__ - __bss_start__) / 8)

		QUAD (__HeapTop)
		QUAD ((__HeapLimit - __HeapTop) / 8)

		QUAD (__StackLimit)
		QUAD ((__StackTop - __StackLimit) / 8)

		__ecc_table_end__ = .;
	} > CM7_0_RAM

	.copy.table :
	{
		. = ALIGN(4);
		__copy_table_start__ = .;

		/* .data section was already copied as part of application image
		LONG (__etext)
		LONG (__data_start__)
		LONG ((__data_end__ - __data_start__) / 4) */

		/* Add each additional data section here */
		/*
			LONG (__etext2)
			LONG (__data2_start__)
			LONG ((__data2_end__ - __data2_start__) / 4)
		*/
		__copy_table_end__ = .;
	} > CM7_0_RAM

	.zero.table :
	{
		. = ALIGN(4);
		__zero_table_start__ = .;
		/* Add each additional bss section here */
		/*
			LONG (__bss2_start__)
			LONG ((__bss2_end__ - __bss2_start__) / 4)
		*/
		__zero_table_end__ = .;
	} > CM7_0_RAM

	/* Due ECC initialization sequence __data_start__ and __data_end__ should be aligned on 8 bytes */
	.data :
	{
		. = ALIGN(8);
		__etext = .;
		__data_start__ = .;
		*(vtable)
		*(.data)
		*(.data.*)

		. = ALIGN(4);
		/* preinit data */
		PROVIDE_HIDDEN (__preinit_array_start = .);
		KEEP(*(.preinit_array))
		PROVIDE_HIDDEN (__preinit_array_end = .);

		. = ALIGN(4);
		/* init data */
		PROVIDE_HIDDEN (__init_array_start = .);
		KEEP(*(SORT(.init_array.*)))
		KEEP(*(.init_array))
		PROVIDE_HIDDEN (__init_array_end = .);

		. = ALIGN(4);
		/* finit data */
		PROVIDE_HIDDEN (__fini_array_start = .);
		KEEP(*(SORT(.fini_array.*)))
		KEEP(*(.fini_array))
		PROVIDE_HIDDEN (__fini_array_end = .);

		KEEP(*(.jcr*))
		. = ALIGN(8);
		/* All data end */
		__data_end__ = .;

	} > CM7_0_RAM

	/* Due ECC initialization sequence __bss_start__ and __bss_end__ should be aligned on 8 bytes */
	.bss :
	{
		. = ALIGN(8);
		__bss_start__ = .;
		*(.bss)
		*(.bss.*)
		*(COMMON)
		. = ALIGN(8);
		__bss_end__ = .;
	} > CM7_0_RAM

	/* Due ECC initialization sequence __HeapTop and __HeapLimit should be aligned on 8 bytes */
	.heap (COPY):
	{
		. = ALIGN(8);
		__HeapTop = .;
		__end__ = .;
		_end = .;
		PROVIDE(end = .);
		. = . + __HEAP_SIZE;
		. = ALIGN(8);
		__HeapLimit = .;
	} > CM7_0_RAM

	/* Due ECC initialization sequence __StackLimit and __StackTop should be aligned on 8 bytes */
	.stack (ORIGIN(CM7_0_RAM) + LENGTH(CM7_0_RAM) - __STACK_SIZE) (COPY) :
	{
		. = ALIGN(8);
		__StackLimit = .;
		. = . + __STACK_SIZE;
		. = ALIGN(8);
		__StackTop = .;
	} > CM7_0_RAM
	PROVIDE(__stack = __StackTop);

	/* Labels required by EWL */
	__START_BSS = __bss_start__;
	__END_BSS = __bss_end__;
	__SP_INIT = __StackTop;

	/* Check if data + heap + stack exceeds RAM limit */
	ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")
	__RAM_START = ORIGIN(CM7_0_RAM);
	__RAM_END = ORIGIN(CM7_0_RAM) + LENGTH(CM7_0_RAM);
	CM7_0_START_ADDRESS = ORIGIN(CM7_0_RAM);
	CM7_1_START_ADDRESS = ORIGIN(CM7_1_RAM);
	CM7_2_START_ADDRESS = ORIGIN(CM7_2_RAM);
}
