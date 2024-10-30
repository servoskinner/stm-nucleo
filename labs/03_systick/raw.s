.section .vector_table:

 ; interrupt table
 8000004:	08000041 
 8000008:	0800006e 
 800000c:	0800006e 
 8000010:	0800006e 
 8000014:	0800006e 
 8000018:	0800006e
 .fill 4 7 0x00 
 800002c:	0800006e
 8000030:	0800006e
 8000034:	00000000
 8000038:	0800006e
 800003c:	080001bd

 .section .text

08000040 <__reset_handler>:
 8000040:	480c      	ldr	r0, [pc, #48]	; (8000074 <__data_start_lma_val>)
 8000042:	490d      	ldr	r1, [pc, #52]	; (8000078 <__data_start_vma_val>)
 8000044:	4a0d      	ldr	r2, [pc, #52]	; (800007c <__data_end_vma_val>)

08000046 <__loop_copy_data_section>:
 8000046:	4291      	cmp	r1, r2
 8000048:	d004      	beq.n	8000054 <__loop_copy_data_section_end>
 800004a:	6804      	ldr	r4, [r0, #0]
 800004c:	600c      	str	r4, [r1, #0]
 800004e:	3004      	adds	r0, #4
 8000050:	3104      	adds	r1, #4
 8000052:	e7f8      	b.n	8000046 <__loop_copy_data_section>

08000054 <__loop_copy_data_section_end>:
 8000054:	480a      	ldr	r0, [pc, #40]	; (8000080 <__bss_start_lma_val>)
 8000056:	490b      	ldr	r1, [pc, #44]	; (8000084 <__bss_start_vma_val>)
 8000058:	4a0b      	ldr	r2, [pc, #44]	; (8000088 <__bss_end_vma_val>)

0800005a <__loop_copy_bss_section>:
 800005a:	4291      	cmp	r1, r2
 800005c:	d004      	beq.n	8000068 <__loop_copy_bss_section_end>
 800005e:	6804      	ldr	r4, [r0, #0]
 8000060:	600c      	str	r4, [r1, #0]
 8000062:	3004      	adds	r0, #4
 8000064:	3104      	adds	r1, #4
 8000066:	e7f8      	b.n	800005a <__loop_copy_bss_section>

08000068 <__loop_copy_bss_section_end>:
 8000068:	f000 f8c8 	bl	80001fc <main>

0800006c <__halt>:
 800006c:	e7fe      	b.n	800006c <__halt>

0800006e <__exc_handler>:
 800006e:	e7fe      	b.n	800006e <__exc_handler>

08000070 <__dummy_handler>:
 8000070:	4770      	bx	lr
 8000072:	bf00      	nop

08000074 <__data_start_lma_val>:
 8000074:	0800021c 	stmdaeq	r0, {r2, r3, r4, r9}

08000078 <__data_start_vma_val>:
 8000078:	20000000 	andcs	r0, r0, r0

0800007c <__data_end_vma_val>:
 800007c:	20000000 	andcs	r0, r0, r0

08000080 <__bss_start_lma_val>:
 8000080:	0800021c 	stmdaeq	r0, {r2, r3, r4, r9}

08000084 <__bss_start_vma_val>:
 8000084:	20000000 	andcs	r0, r0, r0

08000088 <__bss_end_vma_val>:
 8000088:	20000004 	andcs	r0, r0, r4

0800008c <board_clocking_init>:
 800008c:	b480      	push	{r7}
 800008e:	af00      	add	r7, sp, #0
 8000090:	4b23      	ldr	r3, [pc, #140]	; (8000120 <board_clocking_init+0x94>)
 8000092:	681b      	ldr	r3, [r3, #0]
 8000094:	4a22      	ldr	r2, [pc, #136]	; (8000120 <board_clocking_init+0x94>)
 8000096:	f443 3380 	orr.w	r3, r3, #65536	; 0x10000
 800009a:	6013      	str	r3, [r2, #0]
 800009c:	bf00      	nop
 800009e:	4b20      	ldr	r3, [pc, #128]	; (8000120 <board_clocking_init+0x94>)
 80000a0:	681b      	ldr	r3, [r3, #0]
 80000a2:	f403 3300 	and.w	r3, r3, #131072	; 0x20000
 80000a6:	f5b3 3f00 	cmp.w	r3, #131072	; 0x20000
 80000aa:	d1f8      	bne.n	800009e <board_clocking_init+0x12>
 80000ac:	4b1d      	ldr	r3, [pc, #116]	; (8000124 <board_clocking_init+0x98>)
 80000ae:	681b      	ldr	r3, [r3, #0]
 80000b0:	4a1c      	ldr	r2, [pc, #112]	; (8000124 <board_clocking_init+0x98>)
 80000b2:	f043 0320 	orr.w	r3, r3, #32
 80000b6:	6013      	str	r3, [r2, #0]
 80000b8:	4b1a      	ldr	r3, [pc, #104]	; (8000124 <board_clocking_init+0x98>)
 80000ba:	681b      	ldr	r3, [r3, #0]
 80000bc:	4a19      	ldr	r2, [pc, #100]	; (8000124 <board_clocking_init+0x98>)
 80000be:	f023 0310 	bic.w	r3, r3, #16
 80000c2:	6013      	str	r3, [r2, #0]
 80000c4:	4b17      	ldr	r3, [pc, #92]	; (8000124 <board_clocking_init+0x98>)
 80000c6:	681b      	ldr	r3, [r3, #0]
 80000c8:	4a16      	ldr	r2, [pc, #88]	; (8000124 <board_clocking_init+0x98>)
 80000ca:	f443 0380 	orr.w	r3, r3, #4194304	; 0x400000
 80000ce:	6013      	str	r3, [r2, #0]
 80000d0:	4b13      	ldr	r3, [pc, #76]	; (8000120 <board_clocking_init+0x94>)
 80000d2:	681b      	ldr	r3, [r3, #0]
 80000d4:	4a12      	ldr	r2, [pc, #72]	; (8000120 <board_clocking_init+0x94>)
 80000d6:	f043 7380 	orr.w	r3, r3, #16777216	; 0x1000000
 80000da:	6013      	str	r3, [r2, #0]
 80000dc:	bf00      	nop
 80000de:	4b10      	ldr	r3, [pc, #64]	; (8000120 <board_clocking_init+0x94>)
 80000e0:	681b      	ldr	r3, [r3, #0]
 80000e2:	f003 7300 	and.w	r3, r3, #33554432	; 0x2000000
 80000e6:	f1b3 7f00 	cmp.w	r3, #33554432	; 0x2000000
 80000ea:	d1f8      	bne.n	80000de <board_clocking_init+0x52>
 80000ec:	4b0e      	ldr	r3, [pc, #56]	; (8000128 <board_clocking_init+0x9c>)
 80000ee:	4a0e      	ldr	r2, [pc, #56]	; (8000128 <board_clocking_init+0x9c>)
 80000f0:	681b      	ldr	r3, [r3, #0]
 80000f2:	6013      	str	r3, [r2, #0]
 80000f4:	4b0c      	ldr	r3, [pc, #48]	; (8000128 <board_clocking_init+0x9c>)
 80000f6:	681b      	ldr	r3, [r3, #0]
 80000f8:	4a0b      	ldr	r2, [pc, #44]	; (8000128 <board_clocking_init+0x9c>)
 80000fa:	f043 0302 	orr.w	r3, r3, #2
 80000fe:	6013      	str	r3, [r2, #0]
 8000100:	bf00      	nop
 8000102:	4b09      	ldr	r3, [pc, #36]	; (8000128 <board_clocking_init+0x9c>)
 8000104:	681b      	ldr	r3, [r3, #0]
 8000106:	f003 030c 	and.w	r3, r3, #12
 800010a:	2b08      	cmp	r3, #8
 800010c:	d1f9      	bne.n	8000102 <board_clocking_init+0x76>
 800010e:	4b06      	ldr	r3, [pc, #24]	; (8000128 <board_clocking_init+0x9c>)
 8000110:	4a05      	ldr	r2, [pc, #20]	; (8000128 <board_clocking_init+0x9c>)
 8000112:	681b      	ldr	r3, [r3, #0]
 8000114:	6013      	str	r3, [r2, #0]
 8000116:	bf00      	nop
 8000118:	46bd      	mov	sp, r7
 800011a:	bc80      	pop	{r7}
 800011c:	4770      	bx	lr
 800011e:	bf00      	nop
 8000120:	40023800 	andmi	r3, r2, r0, lsl #16
 8000124:	40023804 	andmi	r3, r2, r4, lsl #16
 8000128:	40023808 	andmi	r3, r2, r8, lsl #16

0800012c <board_gpio_init>:
 800012c:	b480      	push	{r7}
 800012e:	af00      	add	r7, sp, #0
 8000130:	4b0c      	ldr	r3, [pc, #48]	; (8000164 <board_gpio_init+0x38>)
 8000132:	681b      	ldr	r3, [r3, #0]
 8000134:	4a0b      	ldr	r2, [pc, #44]	; (8000164 <board_gpio_init+0x38>)
 8000136:	f043 0301 	orr.w	r3, r3, #1
 800013a:	6013      	str	r3, [r2, #0]
 800013c:	4b09      	ldr	r3, [pc, #36]	; (8000164 <board_gpio_init+0x38>)
 800013e:	681b      	ldr	r3, [r3, #0]
 8000140:	4a08      	ldr	r2, [pc, #32]	; (8000164 <board_gpio_init+0x38>)
 8000142:	f043 0302 	orr.w	r3, r3, #2
 8000146:	6013      	str	r3, [r2, #0]
 8000148:	4b06      	ldr	r3, [pc, #24]	; (8000164 <board_gpio_init+0x38>)
 800014a:	681b      	ldr	r3, [r3, #0]
 800014c:	4a05      	ldr	r2, [pc, #20]	; (8000164 <board_gpio_init+0x38>)
 800014e:	f043 0304 	orr.w	r3, r3, #4
 8000152:	6013      	str	r3, [r2, #0]
 8000154:	4b04      	ldr	r3, [pc, #16]	; (8000168 <board_gpio_init+0x3c>)
 8000156:	f245 5255 	movw	r2, #21845	; 0x5555
 800015a:	601a      	str	r2, [r3, #0]
 800015c:	bf00      	nop
 800015e:	46bd      	mov	sp, r7
 8000160:	bc80      	pop	{r7}
 8000162:	4770      	bx	lr
 8000164:	40023830 	andmi	r3, r2, r0, lsr r8
 8000168:	40020000 	andmi	r0, r2, r0

0800016c <systick_init>:
 800016c:	b480      	push	{r7}
 800016e:	b085      	sub	sp, #20
 8000170:	af00      	add	r7, sp, #0
 8000172:	6078      	str	r0, [r7, #4]
 8000174:	687b      	ldr	r3, [r7, #4]
 8000176:	4a0c      	ldr	r2, [pc, #48]	; (80001a8 <systick_init+0x3c>)
 8000178:	fb02 f303 	mul.w	r3, r2, r3
 800017c:	4a0b      	ldr	r2, [pc, #44]	; (80001ac <systick_init+0x40>)
 800017e:	fba2 2303 	umull	r2, r3, r2, r3
 8000182:	0d5b      	lsrs	r3, r3, #21
 8000184:	60fb      	str	r3, [r7, #12]
 8000186:	68fb      	ldr	r3, [r7, #12]
 8000188:	3b01      	subs	r3, #1
 800018a:	4a09      	ldr	r2, [pc, #36]	; (80001b0 <systick_init+0x44>)
 800018c:	f023 437f 	bic.w	r3, r3, #4278190080	; 0xff000000
 8000190:	6013      	str	r3, [r2, #0]
 8000192:	4b08      	ldr	r3, [pc, #32]	; (80001b4 <systick_init+0x48>)
 8000194:	2200      	movs	r2, #0
 8000196:	601a      	str	r2, [r3, #0]
 8000198:	4b07      	ldr	r3, [pc, #28]	; (80001b8 <systick_init+0x4c>)
 800019a:	2207      	movs	r2, #7
 800019c:	601a      	str	r2, [r3, #0]
 800019e:	bf00      	nop
 80001a0:	3714      	adds	r7, #20
 80001a2:	46bd      	mov	sp, r7
 80001a4:	bc80      	pop	{r7}
 80001a6:	4770      	bx	lr
 80001a8:	001d4c00 	andseq	r4, sp, r0, lsl #24
 80001ac:	431bde83 	tstmi	fp, #2096	; 0x830
 80001b0:	e000e014 	and	lr, r0, r4, lsl r0
 80001b4:	e000e018 	and	lr, r0, r8, lsl r0
 80001b8:	e000e010 	and	lr, r0, r0, lsl r0

080001bc <systick_handler>:
 80001bc:	b480      	push	{r7}
 80001be:	af00      	add	r7, sp, #0
 80001c0:	4b0c      	ldr	r3, [pc, #48]	; (80001f4 <systick_handler+0x38>)
 80001c2:	681b      	ldr	r3, [r3, #0]
 80001c4:	3301      	adds	r3, #1
 80001c6:	461a      	mov	r2, r3
 80001c8:	4b0a      	ldr	r3, [pc, #40]	; (80001f4 <systick_handler+0x38>)
 80001ca:	601a      	str	r2, [r3, #0]
 80001cc:	4b09      	ldr	r3, [pc, #36]	; (80001f4 <systick_handler+0x38>)
 80001ce:	681b      	ldr	r3, [r3, #0]
 80001d0:	f242 7210 	movw	r2, #10000	; 0x2710
 80001d4:	4293      	cmp	r3, r2
 80001d6:	d108      	bne.n	80001ea <systick_handler+0x2e>
 80001d8:	4b06      	ldr	r3, [pc, #24]	; (80001f4 <systick_handler+0x38>)
 80001da:	2200      	movs	r2, #0
 80001dc:	601a      	str	r2, [r3, #0]
 80001de:	4b06      	ldr	r3, [pc, #24]	; (80001f8 <systick_handler+0x3c>)
 80001e0:	681b      	ldr	r3, [r3, #0]
 80001e2:	4a05      	ldr	r2, [pc, #20]	; (80001f8 <systick_handler+0x3c>)
 80001e4:	f083 0320 	eor.w	r3, r3, #32
 80001e8:	6013      	str	r3, [r2, #0]
 80001ea:	bf00      	nop
 80001ec:	46bd      	mov	sp, r7
 80001ee:	bc80      	pop	{r7}
 80001f0:	4770      	bx	lr
 80001f2:	bf00      	nop
 80001f4:	20000000 	andcs	r0, r0, r0
 80001f8:	40020014 	andmi	r0, r2, r4, lsl r0

080001fc <main>:
 80001fc:	b580      	push	{r7, lr}
 80001fe:	af00      	add	r7, sp, #0
 8000200:	f7ff ff44 	bl	800008c <board_clocking_init>
 8000204:	f7ff ff92 	bl	800012c <board_gpio_init>
 8000208:	f44f 707a 	mov.w	r0, #1000	; 0x3e8
 800020c:	f7ff ffae 	bl	800016c <systick_init>
 8000210:	bf00      	nop
 8000212:	e7fd      	b.n	8000210 <main+0x14>

Disassembly of section .init:

08000214 <_init>:
 8000214:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
 8000216:	bf00      	nop

Disassembly of section .fini:

08000218 <_fini>:
 8000218:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
 800021a:	bf00      	nop

Disassembly of section .bss:

20000000 <__bss_start_vma>:
20000000:	00000000 	andeq	r0, r0, r0
