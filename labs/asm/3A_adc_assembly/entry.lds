ENTRY(reset);

FLASH_VADDR = 0x00000000;
FLASH_PADDR = 0x08000000;
FLASH_SIZE  = 512K;

SRAM_VADDR  = 0x20000000;
SRAM_PADDR  = 0x20000000;
SRAM_SIZE   = 96K;

MEMORY
{
    FLASH  (rx)  : ORIGIN = FLASH_VADDR, LENGTH = FLASH_SIZE
    SRAM   (rwx) : ORIGIN =  SRAM_VADDR, LENGTH =  SRAM_SIZE
}

SECTIONS
{
    . = 0x0;
	
    .text :
    {
        KEEP(*(.vector_table));
        *(.text*)
    } > FLASH

    .data :
    {
        . = ALIGN(4);
        __data_vma_start = .;

        *(.data*)

        . = ALIGN(4);
        __data_vma_end = .;
    } >SRAM AT >FLASH

    __data_lma_start = LOADADDR(.data);
    __stack_start = SRAM_VADDR + SRAM_SIZE;

    /DISCARD/ :
    {
        *(.ARM.attributes)
        *(.comment)
        *(.symtab)
    }
}
