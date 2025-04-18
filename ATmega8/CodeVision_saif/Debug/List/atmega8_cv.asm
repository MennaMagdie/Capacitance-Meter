
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rangemode=R5
	.DEF __lcd_x=R4
	.DEF __lcd_y=R7
	.DEF __lcd_maxx=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _ana_comp_isr
	RJMP 0x00
	RJMP 0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x4

_0x3:
	.DB  0x70,0x6E,0x75,0x6D,0x20
_0x4:
	.DB  0x0,0xCA,0x9A,0x3B,0x0,0xE1,0xF5,0x5
	.DB  0x80,0x96,0x98,0x0,0x40,0x42,0xF,0x0
	.DB  0xA0,0x86,0x1,0x0,0x10,0x27,0x0,0x0
	.DB  0xE8,0x3,0x0,0x0,0x64,0x0,0x0,0x0
	.DB  0xA,0x0,0x0,0x0,0x1
_0x6:
	.DB  LOW(_0x5),HIGH(_0x5),LOW(_0x5+12),HIGH(_0x5+12),LOW(_0x5+24),HIGH(_0x5+24),LOW(_0x5+36),HIGH(_0x5+36)
	.DB  LOW(_0x5+52),HIGH(_0x5+52),LOW(_0x5+68),HIGH(_0x5+68)
_0x7:
	.DB  0xB6,0x53,0x5C,0x24,0xDF,0x4B,0xF5,0x20
_0x0:
	.DB  0x52,0x61,0x6E,0x67,0x65,0x3A,0x20,0x41
	.DB  0x75,0x74,0x6F,0x0,0x52,0x61,0x6E,0x67
	.DB  0x65,0x3A,0x20,0x4C,0x6F,0x77,0x20,0x0
	.DB  0x52,0x61,0x6E,0x67,0x65,0x3A,0x20,0x48
	.DB  0x69,0x67,0x68,0x0,0x43,0x61,0x6C,0x69
	.DB  0x62,0x72,0x61,0x74,0x65,0x3A,0x20,0x5A
	.DB  0x65,0x72,0x6F,0x0,0x43,0x61,0x6C,0x69
	.DB  0x62,0x72,0x61,0x74,0x65,0x3A,0x20,0x31
	.DB  0x20,0x75,0x46,0x0,0x53,0x61,0x76,0x65
	.DB  0x20,0x63,0x61,0x6C,0x69,0x62,0x72,0x61
	.DB  0x74,0x69,0x6F,0x6E,0x0,0x41,0x75,0x74
	.DB  0x6F,0x20,0x0,0x46,0x6F,0x72,0x63,0x65
	.DB  0x0,0x20,0x68,0x69,0x67,0x68,0x0,0x20
	.DB  0x6C,0x6F,0x77,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x05
	.DW  _decades
	.DW  _0x3*2

	.DW  0x25
	.DW  _tenths_tab
	.DW  _0x4*2

	.DW  0x0C
	.DW  _0x5
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x5+12
	.DW  _0x0*2+12

	.DW  0x0C
	.DW  _0x5+24
	.DW  _0x0*2+24

	.DW  0x10
	.DW  _0x5+36
	.DW  _0x0*2+36

	.DW  0x10
	.DW  _0x5+52
	.DW  _0x0*2+52

	.DW  0x11
	.DW  _0x5+68
	.DW  _0x0*2+68

	.DW  0x0C
	.DW  _menu_item
	.DW  _0x6*2

	.DW  0x08
	.DW  _calib
	.DW  _0x7*2

	.DW  0x06
	.DW  _0x43
	.DW  _0x0*2+85

	.DW  0x06
	.DW  _0x43+6
	.DW  _0x0*2+91

	.DW  0x06
	.DW  _0x43+12
	.DW  _0x0*2+97

	.DW  0x06
	.DW  _0x43+18
	.DW  _0x0*2+103

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 17/04/2025
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <delay.h>  // if you're using delay_ms()
;#include <eeprom.h> // for EEPROM access
;#include <stdio.h>
;// Declare your global variables here
;#include <spi.h>
;
;#define DISCHARGE_ON DDRD |= (1 << 6)
;#define DISCHARGE_OFF DDRD &= ~(1 << 6)
;
;/* Range control */
;#define HIGH_RANGE   \
;  PORTD |= (1 << 5); \
;  DDRD |= (1 << 5)
;#define LOW_RANGE    \
;  DDRD &= ~(1 << 5); \
;  PORTD &= ~(1 << 5)
;#define PULLDOWN_RANGE \
;  PORTD &= ~(1 << 5);  \
;  DDRD |= (1 << 5)
;
;/* Threshold selection */
;#define ADMUX_LOW 1
;#define ADMUX_MEDIUM 2
;#define ADMUX_HIGH 3
;
;/* Timer abstraction */
;#define TIMER_VALUE TCNT1
;#define TIMER_START TCCR1B = (1 << CS10)
;#define TIMER_STOP TCCR1B = 0
;
;/* Led abstraction */
;#define LED_ON PORTD &= ~(1 << 4)
;#define LED_OFF PORTD |= (1 << 4)
;
;/* Button abstraction */
;#define BUTTON_PUSHED (!(PIND & (1 << 2)))
;
;char decades[5] = {'p', 'n', 'u', 'm', ' '};

	.DSEG
;unsigned long tenths_tab[10] = {1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1};
;char lcdbuffer[32];
;
;unsigned short volatile timer_highword;
;
;/* Program states: */
;#define STATE_IDLE 0
;#define STATE_LOW_THRESH 1
;#define STATE_HIGH_THRESH 2
;#define STATE_DONE 3
;// #define STATE_BUTTONDOWN 4
;
;unsigned char volatile measure_state;
;
;/* The following is the value the analog compare interrupt will set ADMUX: */
;unsigned char volatile set_admux;
;
;/* The rangemode defines the measurement operation */
;#define RANGE_HIGH_THRESH 1 /* If missing: threshold low */
;#define RANGE_HIGH 2        /* If missing: range low */
;#define RANGE_AUTO 4
;#define RANGE_OVERFLOW 8 /* If set: cap was out of range */
;unsigned char rangemode = RANGE_AUTO;
;
;/* Constants defining measuring operation: */
;#define EXTRA_DISCHARGE_MS 100   /* Extra discharging that is done even after a threshold is crossed */
;#define LOW_RANGE_TIMEOUT 500    /* At autorange, when to go to high range */
;#define HIGH_RANGE_TIMEOUT 10000 /* When to give up completely */
;
;/* Menu system */
;#define MENU_SPEED 800 /* ms each menu item is shown */
;
;#define MENU_ITEMS 6
;char *menu_item[MENU_ITEMS] = {"Range: Auto", "Range: Low ", "Range: High", "Calibrate: Zero", "Calibrate: 1 uF", "Save  ...
_0x5:
	.BYTE 0x55
;
;#define CALIB_LOW 256000000 /* for 1uF reference prescale: >> 8 */
;#define CALIB_HIGH 65536000 /* for 1uF reference */
;
;/* Calibration values are stored in eeprom in the following format:
;
;   Starting from byte 1:  (not 0)
;   'C' 'D'
;   <data>
;
;*/
;#define EEPROM_HEADER 1
;#define EEPROM_DATA 3
;
;unsigned short calib[4] = {21430, 9308, 19423, 8437};
;// unsigned short calib[4] = {53575, 46540, 19423, 8437};
;//char buf[16];
;unsigned long calib_offset[4] = {0, 0, 0, 0};
;
;#define SIZE_OF_CALIB 8
;#define SIZE_OF_CALIBOFFSET 16
;
;/* This macro fractionally multiplies 16.16 bit with 0.16 bit both unsigned,
;   shifting the result two bytes right and returning 16.16 bit.
;
; Result is 16.16 bit unsigned */
;
;/* Interrupt implementation */
;interrupt[ANA_COMP] void ana_comp_isr(void)
; 0000 0081 {

	.CSEG
_ana_comp_isr:
; .FSTART _ana_comp_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0082   if (measure_state == STATE_LOW_THRESH)
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x1)
	BRNE _0x8
; 0000 0083   {
; 0000 0084     /* We just got low threshold interrupt, start timer and set high threshold */
; 0000 0085     TIMER_START;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 0086     ADMUX = set_admux;
	LDS  R30,_set_admux
	OUT  0x7,R30
; 0000 0087     measure_state = STATE_HIGH_THRESH;
	LDI  R30,LOW(2)
	RJMP _0x66
; 0000 0088   }
; 0000 0089   else if (measure_state == STATE_HIGH_THRESH)
_0x8:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x2)
	BRNE _0xA
; 0000 008A   {
; 0000 008B     /* High threshold interrupt, verify it, then stop timer */
; 0000 008C     if (ACSR & (1 << ACO))
	SBIS 0x8,5
	RJMP _0xB
; 0000 008D     {
; 0000 008E       TIMER_STOP;
	RCALL SUBOPT_0x1
; 0000 008F       measure_state = STATE_DONE;
	LDI  R30,LOW(3)
_0x66:
	STS  _measure_state,R30
; 0000 0090     }
; 0000 0091   }
_0xB:
; 0000 0092 }
_0xA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt[TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0095 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0096   /* Timer 1 counts the low 16 bits, this interrupt updates the high 16 bits */
; 0000 0097   timer_highword++;
	LDI  R26,LOW(_timer_highword)
	LDI  R27,HIGH(_timer_highword)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0098 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// SIGNAL(SIG_INTERRUPT0)
;// {
;//   /* Hardware interrupt 0 is a buttonpush */
;//   measure_state = STATE_BUTTONDOWN;
;// }
;
;/*
;   The measure function does the cyclus of a capacitance measurement
;   Returned is the number of clocks measured
;
;   The function relies on flags in the global rangemode value
;   Input flags:
;     RANGE_AUTO
;     RANGE_HIGH
;     RANGE_HIGH_THRESH
;
;   Output flags:
;     RANGE_HIGH     (if RANGE_AUTO)
;     RANGE_OVERFLOW
;
;*/
;
;#include <stdint.h>
;void MUL_LONG_SHORT_S2(uint32_t x, uint16_t y, uint32_t *result)
; 0000 00B2 {
_MUL_LONG_SHORT_S2:
; .FSTART _MUL_LONG_SHORT_S2
; 0000 00B3   // int16_t x_high = x >> 16;              // Integer part (signed)
; 0000 00B4   // uint16_t x_low = x & 0xFFFF;           // Fractional part (unsigned)
; 0000 00B5 
; 0000 00B6   // int32_t part1 = (int32_t)x_high * y;   // Signed mult: integer part
; 0000 00B7   // int32_t part2 = ((int32_t)x_low * y + 0x8000) >> 16; // Rounded fractional part
; 0000 00B8 
; 0000 00B9   // int32_t combined = part1 + part2;
; 0000 00BA 
; 0000 00BB   //*result = (uint32_t)combined;          // Cast final signed result to unsigned
; 0000 00BC   uint16_t x_frac = x & 0xFFFF;
; 0000 00BD   uint16_t x_int = x >> 16;
; 0000 00BE 
; 0000 00BF   uint32_t part1 = ((uint32_t)x_frac * y) >> 16;
; 0000 00C0   uint32_t part2 = (uint32_t)x_int * y;
; 0000 00C1   *result = (part2) + part1;
	RCALL SUBOPT_0x2
	SBIW R28,8
	RCALL __SAVELOCR4
;	x -> Y+16
;	y -> Y+14
;	*result -> Y+12
;	x_frac -> R16,R17
;	x_int -> R18,R19
;	part1 -> Y+8
;	part2 -> Y+4
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	MOVW R16,R30
	__GETD1S 16
	RCALL __LSRD16
	MOVW R18,R30
	MOVW R26,R16
	RCALL SUBOPT_0x3
	RCALL __LSRD16
	__PUTD1S 8
	MOVW R26,R18
	RCALL SUBOPT_0x3
	__PUTD1S 4
	__GETD1S 8
	RCALL SUBOPT_0x4
	RCALL __ADDD12
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __PUTDP1
; 0000 00C2   // return result;
; 0000 00C3 }
	RCALL __LOADLOCR4
	ADIW R28,20
	RET
; .FEND
;// Multiply 16.16 fixed-point (x) by 0.16 fixed-point (y), return 16.16 fixed-point
;/*uint32_t MUL_LONG_SHORT_S2(uint32_t x, uint16_t y) {
;    uint16_t x_frac = x & 0xFFFF;
;    uint16_t x_int = x >> 16;
;    uint32_t part1 = ((uint32_t)x_frac * y) >> 16;
;    uint32_t part2 = (uint32_t)x_int * y;
;    uint32_t result = (part2) + part1;
;    return result;
;}  */
;void eeprom_read(void)
; 0000 00CE {
_eeprom_read:
; .FSTART _eeprom_read
; 0000 00CF   if (eeprom_read_byte((void *)EEPROM_HEADER) != 'C')
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x43)
	BREQ _0xC
; 0000 00D0     return;
	RET
; 0000 00D1 
; 0000 00D2   if (eeprom_read_byte((void *)(EEPROM_HEADER + 1)) != 'D')
_0xC:
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x44)
	BREQ _0xD
; 0000 00D3     return;
	RET
; 0000 00D4 
; 0000 00D5   eeprom_read_block(calib_offset, (eeprom void *)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
_0xD:
	RCALL SUBOPT_0x5
	RCALL _eeprom_read_block
; 0000 00D6   eeprom_read_block(calib, (eeprom void *)((char *)EEPROM_DATA + SIZE_OF_CALIBOFFSET), SIZE_OF_CALIB);
	RCALL SUBOPT_0x6
	RCALL _eeprom_read_block
; 0000 00D7 }
	RET
; .FEND
;
;void eeprom_write(void)
; 0000 00DA {
_eeprom_write:
; .FSTART _eeprom_write
; 0000 00DB   eeprom_write_byte((void *)EEPROM_HEADER, 'C');
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	LDI  R30,LOW(67)
	RCALL __EEPROMWRB
; 0000 00DC   eeprom_write_byte((void *)(EEPROM_HEADER + 1), 'D');
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	LDI  R30,LOW(68)
	RCALL __EEPROMWRB
; 0000 00DD 
; 0000 00DE   eeprom_write_block(calib_offset, (eeprom void *)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
	RCALL SUBOPT_0x5
	RCALL _eeprom_write_block
; 0000 00DF   eeprom_write_block(calib, (eeprom void *)((char *)EEPROM_DATA + SIZE_OF_CALIBOFFSET), SIZE_OF_CALIB);
	RCALL SUBOPT_0x6
	RCALL _eeprom_write_block
; 0000 00E0 }
	RET
; .FEND
;
;void lcd_string(const char *str, unsigned char pos)
; 0000 00E3 {
_lcd_string:
; .FSTART _lcd_string
; 0000 00E4   unsigned char row = (pos >= 16) ? 1 : 0;
; 0000 00E5   unsigned char col = (pos % 16);
; 0000 00E6   lcd_gotoxy(col, row);
	ST   -Y,R26
	RCALL __SAVELOCR2
;	*str -> Y+3
;	pos -> Y+2
;	row -> R17
;	col -> R16
	LDD  R26,Y+2
	CPI  R26,LOW(0x10)
	BRLO _0xE
	LDI  R30,LOW(1)
	RJMP _0xF
_0xE:
	LDI  R30,LOW(0)
_0xF:
	MOV  R17,R30
	LDD  R30,Y+2
	LDI  R31,0
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RCALL __MANDW12
	MOV  R16,R30
	ST   -Y,R16
	MOV  R26,R17
	RCALL _lcd_gotoxy
; 0000 00E7   lcd_puts(str);
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _lcd_puts
; 0000 00E8 }
	RCALL __LOADLOCR2
	RJMP _0x20C0004
; .FEND
;
;/*unsigned char long2ascii(char *buf, unsigned long val)
;{
;  // Converts val to a 5-digit ASCII right-aligned string, returns # of digits
;  sprintf(buf, "%05lu", val); // e.g., 00042
;  return 5;
;}   */
;char long2ascii(char *target, unsigned long value)
; 0000 00F1 {
_long2ascii:
; .FSTART _long2ascii
; 0000 00F2   unsigned char p, pos=0;
; 0000 00F3   unsigned char numbernow=0;
; 0000 00F4   char ret=0;
; 0000 00F5 
; 0000 00F6   for (p=0;(p<10) && (pos<5);p++) {
	RCALL __PUTPARD2
	RCALL __SAVELOCR4
;	*target -> Y+8
;	value -> Y+4
;	p -> R17
;	pos -> R16
;	numbernow -> R19
;	ret -> R18
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R17,LOW(0)
_0x12:
	CPI  R17,10
	BRSH _0x14
	CPI  R16,5
	BRLO _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 00F7 
; 0000 00F8     if (numbernow) {
	CPI  R19,0
	BREQ _0x16
; 0000 00F9       /* Eventually place dot */
; 0000 00FA       /* Notice the nice fallthrough construction. */
; 0000 00FB       switch(p) {
	MOV  R30,R17
	LDI  R31,0
; 0000 00FC       case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1A
; 0000 00FD         ret++;
	SUBI R18,-1
; 0000 00FE       case 4:
	RJMP _0x1B
_0x1A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1C
_0x1B:
; 0000 00FF         ret++;
	SUBI R18,-1
; 0000 0100       case 7:
	RJMP _0x1D
_0x1C:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x19
_0x1D:
; 0000 0101         ret++;
	SUBI R18,-1
; 0000 0102         target[pos] = '.';
	RCALL SUBOPT_0x7
	LDI  R30,LOW(46)
	ST   X,R30
; 0000 0103         pos++;
	SUBI R16,-1
; 0000 0104       }
_0x19:
; 0000 0105     }
; 0000 0106 
; 0000 0107     if (value < tenths_tab[p]) {
_0x16:
	RCALL SUBOPT_0x8
	BRSH _0x1F
; 0000 0108       if (numbernow) {
	CPI  R19,0
	BREQ _0x20
; 0000 0109         /* Inside number, put a zero */
; 0000 010A         target[pos] = '0';
	RCALL SUBOPT_0x7
	LDI  R30,LOW(48)
	RJMP _0x67
; 0000 010B         pos++;
; 0000 010C       }
; 0000 010D       else {
_0x20:
; 0000 010E         /* Check if we need to pad with spaces */
; 0000 010F         if (p>=6) {
	CPI  R17,6
	BRLO _0x22
; 0000 0110           target[pos] = ' ';
	RCALL SUBOPT_0x7
	LDI  R30,LOW(32)
	ST   X,R30
; 0000 0111           pos++;
	SUBI R16,-1
; 0000 0112         }
; 0000 0113 
; 0000 0114         if (p==6) {
_0x22:
	CPI  R17,6
	BRNE _0x23
; 0000 0115           /* We also need to place a space instead of . */
; 0000 0116           target[pos] = ' ';
	RCALL SUBOPT_0x7
	LDI  R30,LOW(32)
_0x67:
	ST   X,R30
; 0000 0117           pos++;
	SUBI R16,-1
; 0000 0118         }
; 0000 0119       }
_0x23:
; 0000 011A     }
; 0000 011B     else {
	RJMP _0x24
_0x1F:
; 0000 011C       target[pos] = '0';
	RCALL SUBOPT_0x7
	LDI  R30,LOW(48)
	ST   X,R30
; 0000 011D       while (value >= tenths_tab[p]) {
_0x25:
	RCALL SUBOPT_0x8
	BRLO _0x27
; 0000 011E         target[pos]++;
	RCALL SUBOPT_0x7
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 011F         value -= tenths_tab[p];
	MOV  R30,R17
	LDI  R26,LOW(_tenths_tab)
	LDI  R27,HIGH(_tenths_tab)
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x4
	RCALL __SUBD21
	__PUTD2S 4
; 0000 0120       }
	RJMP _0x25
_0x27:
; 0000 0121       pos++;
	SUBI R16,-1
; 0000 0122       numbernow = 1;
	LDI  R19,LOW(1)
; 0000 0123     }
_0x24:
; 0000 0124   }
	SUBI R17,-1
	RJMP _0x12
_0x13:
; 0000 0125 
; 0000 0126   return ret;
	MOV  R30,R18
	RJMP _0x20C0001
; 0000 0127 }
; .FEND
;
;long measure(void)
; 0000 012A {
_measure:
; .FSTART _measure
; 0000 012B   unsigned short i;
; 0000 012C 
; 0000 012D   measure_state = STATE_IDLE;
	RCALL __SAVELOCR2
;	i -> R16,R17
	LDI  R30,LOW(0)
	STS  _measure_state,R30
; 0000 012E 
; 0000 012F   /* Discharge cap until below low threshold + some extra */
; 0000 0130   ADMUX = ADMUX_LOW;
	LDI  R30,LOW(1)
	OUT  0x7,R30
; 0000 0131   PULLDOWN_RANGE; /* Use range signal as pull down */
	CBI  0x12,5
	SBI  0x11,5
; 0000 0132 
; 0000 0133   while (1)
_0x28:
; 0000 0134   {
; 0000 0135     /* Enable comperator and check value */
; 0000 0136     DISCHARGE_OFF;
	CBI  0x11,6
; 0000 0137     delay_ms(1);
	RCALL SUBOPT_0xA
; 0000 0138 
; 0000 0139     /* This value must be checked in every loop */
; 0000 013A     if (BUTTON_PUSHED)
	SBIC 0x10,2
	RJMP _0x2B
; 0000 013B       return 0;
	RCALL SUBOPT_0xB
	RJMP _0x20C0005
; 0000 013C 
; 0000 013D     if (!(ACSR & (1 << ACO)))
_0x2B:
	SBIS 0x8,5
; 0000 013E       break;
	RJMP _0x2A
; 0000 013F 
; 0000 0140     /* Discharge for a while */
; 0000 0141     DISCHARGE_ON;
	SBI  0x11,6
; 0000 0142     delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0xC
; 0000 0143   }
	RJMP _0x28
_0x2A:
; 0000 0144 
; 0000 0145   DISCHARGE_ON;
	SBI  0x11,6
; 0000 0146   delay_ms(EXTRA_DISCHARGE_MS);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0xC
; 0000 0147 
; 0000 0148   /* Prepare: reset timer, low range */
; 0000 0149   TIMER_STOP;
	RCALL SUBOPT_0x1
; 0000 014A   TIMER_VALUE = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 014B   timer_highword = 0;
	STS  _timer_highword,R30
	STS  _timer_highword+1,R30
; 0000 014C 
; 0000 014D   LOW_RANGE;
	CBI  0x11,5
	CBI  0x12,5
; 0000 014E 
; 0000 014F   measure_state = STATE_LOW_THRESH;
	LDI  R30,LOW(1)
	STS  _measure_state,R30
; 0000 0150 
; 0000 0151   /* High or medium threshold */
; 0000 0152   if (rangemode & RANGE_HIGH_THRESH)
	SBRS R5,0
	RJMP _0x2D
; 0000 0153     set_admux = ADMUX_HIGH;
	LDI  R30,LOW(3)
	RJMP _0x68
; 0000 0154   else
_0x2D:
; 0000 0155     set_admux = ADMUX_MEDIUM;
	LDI  R30,LOW(2)
_0x68:
	STS  _set_admux,R30
; 0000 0156 
; 0000 0157   /* Apply step */
; 0000 0158   LED_ON;
	CBI  0x12,4
; 0000 0159   DISCHARGE_OFF;
	CBI  0x11,6
; 0000 015A 
; 0000 015B   if (rangemode & RANGE_AUTO)
	SBRS R5,2
	RJMP _0x2F
; 0000 015C   {
; 0000 015D 
; 0000 015E     /* Autorange: See if low range produces something before LOW_RANGE_TIMEOUT ms */
; 0000 015F     i = 0;
	__GETWRN 16,17,0
; 0000 0160     while ((measure_state == STATE_LOW_THRESH) && (++i < LOW_RANGE_TIMEOUT))
_0x30:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x1)
	BRNE _0x33
	MOVW R30,R16
	ADIW R30,1
	MOVW R16,R30
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLO _0x34
_0x33:
	RJMP _0x32
_0x34:
; 0000 0161     {
; 0000 0162       delay_ms(1);
	RCALL SUBOPT_0xA
; 0000 0163 
; 0000 0164       /* This value must be checked in every loop */
; 0000 0165       if (BUTTON_PUSHED)
	SBIC 0x10,2
	RJMP _0x35
; 0000 0166         return 0;
	RCALL SUBOPT_0xB
	RJMP _0x20C0005
; 0000 0167     }
_0x35:
	RJMP _0x30
_0x32:
; 0000 0168 
; 0000 0169     if (i >= LOW_RANGE_TIMEOUT)
	__CPWRN 16,17,500
	BRLO _0x36
; 0000 016A     {
; 0000 016B       /* low range timeout, go to high range (better discharge a little first) */
; 0000 016C       DISCHARGE_ON;
	SBI  0x11,6
; 0000 016D       delay_ms(EXTRA_DISCHARGE_MS);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0xC
; 0000 016E       DISCHARGE_OFF;
	CBI  0x11,6
; 0000 016F       HIGH_RANGE;
	SBI  0x12,5
	SBI  0x11,5
; 0000 0170       rangemode |= RANGE_HIGH;
	LDI  R30,LOW(2)
	OR   R5,R30
; 0000 0171     }
; 0000 0172     else
	RJMP _0x37
_0x36:
; 0000 0173     {
; 0000 0174       /* low range was ok, set flag accordingly */
; 0000 0175       rangemode &= ~RANGE_HIGH;
	LDI  R30,LOW(253)
	AND  R5,R30
; 0000 0176     }
_0x37:
; 0000 0177   }
; 0000 0178   else if (rangemode & RANGE_HIGH)
	RJMP _0x38
_0x2F:
	SBRS R5,1
	RJMP _0x39
; 0000 0179   {
; 0000 017A     HIGH_RANGE;
	SBI  0x12,5
	SBI  0x11,5
; 0000 017B   }
; 0000 017C 
; 0000 017D   /* Wait for completion, timing out after HIGH_RANGE_TIMEOUT */
; 0000 017E   i = 0;
_0x39:
_0x38:
	__GETWRN 16,17,0
; 0000 017F   while ((measure_state != STATE_DONE) && (++i < HIGH_RANGE_TIMEOUT))
_0x3A:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x3)
	BREQ _0x3D
	MOVW R30,R16
	ADIW R30,1
	MOVW R16,R30
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRLO _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 0180   {
; 0000 0181     delay_ms(1);
	RCALL SUBOPT_0xA
; 0000 0182 
; 0000 0183     /* This value must be checked in every loop */
; 0000 0184     if (BUTTON_PUSHED)
	SBIC 0x10,2
	RJMP _0x3F
; 0000 0185       return 0;
	RCALL SUBOPT_0xB
	RJMP _0x20C0005
; 0000 0186   }
_0x3F:
	RJMP _0x3A
_0x3C:
; 0000 0187 
; 0000 0188   /* Done, discharge cap now */
; 0000 0189   LOW_RANGE;
	CBI  0x11,5
	CBI  0x12,5
; 0000 018A   DISCHARGE_ON;
	SBI  0x11,6
; 0000 018B   LED_OFF;
	SBI  0x12,4
; 0000 018C 
; 0000 018D   if (measure_state != STATE_DONE)
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x3)
	BREQ _0x40
; 0000 018E     rangemode |= RANGE_OVERFLOW;
	LDI  R30,LOW(8)
	OR   R5,R30
; 0000 018F   else
	RJMP _0x41
_0x40:
; 0000 0190     rangemode &= ~RANGE_OVERFLOW;
	LDI  R30,LOW(247)
	AND  R5,R30
; 0000 0191 
; 0000 0192   measure_state = STATE_IDLE;
_0x41:
	LDI  R30,LOW(0)
	STS  _measure_state,R30
; 0000 0193 
; 0000 0194   return ((unsigned long)timer_highword << 16) + TIMER_VALUE;
	LDS  R30,_timer_highword
	LDS  R31,_timer_highword+1
	CLR  R22
	CLR  R23
	RCALL __LSLD16
	MOVW R26,R30
	MOVW R24,R22
	IN   R30,0x2C
	IN   R31,0x2C+1
	CLR  R22
	CLR  R23
	RCALL __ADDD12
_0x20C0005:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0195 }
; .FEND
;
;/*
;   This function deals with value according to the global rangemode flag,
;   and shows the result on LCD.
;
;   LCD should preferably be cleared.
;
;   Routine is rather slow
;*/
;
;void calc_and_show(long value)
; 0000 01A1 {
_calc_and_show:
; .FSTART _calc_and_show
; 0000 01A2   unsigned char b;
; 0000 01A3   unsigned long l;
; 0000 01A4 
; 0000 01A5   if (rangemode & RANGE_AUTO)
	RCALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
;	value -> Y+5
;	b -> R17
;	l -> Y+1
	SBRS R5,2
	RJMP _0x42
; 0000 01A6     lcd_string("Auto ", 0);
	__POINTW1MN _0x43,0
	RJMP _0x69
; 0000 01A7   else
_0x42:
; 0000 01A8     lcd_string("Force", 0);
	__POINTW1MN _0x43,6
_0x69:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_string
; 0000 01A9 
; 0000 01AA   if (rangemode & RANGE_HIGH)
	SBRS R5,1
	RJMP _0x45
; 0000 01AB     lcd_string(" high", 16);
	__POINTW1MN _0x43,12
	RJMP _0x6A
; 0000 01AC   else
_0x45:
; 0000 01AD     lcd_string(" low ", 16);
	__POINTW1MN _0x43,18
_0x6A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	RCALL _lcd_string
; 0000 01AE 
; 0000 01AF   if (rangemode & RANGE_OVERFLOW)
	SBRS R5,3
	RJMP _0x47
; 0000 01B0   {
; 0000 01B1     /* Todo - this smarter */
; 0000 01B2     lcdbuffer[0] = ' ';
	LDI  R30,LOW(32)
	STS  _lcdbuffer,R30
; 0000 01B3     lcdbuffer[1] = ' ';
	__PUTB1MN _lcdbuffer,1
; 0000 01B4     lcdbuffer[2] = ' ';
	__PUTB1MN _lcdbuffer,2
; 0000 01B5     lcdbuffer[3] = 'E';
	LDI  R30,LOW(69)
	__PUTB1MN _lcdbuffer,3
; 0000 01B6     lcdbuffer[4] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _lcdbuffer,4
; 0000 01B7     lcdbuffer[5] = 'r';
	__PUTB1MN _lcdbuffer,5
; 0000 01B8     lcdbuffer[6] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _lcdbuffer,6
; 0000 01B9     lcdbuffer[7] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _lcdbuffer,7
; 0000 01BA     lcdbuffer[8] = ' ';
	LDI  R30,LOW(32)
	RJMP _0x6B
; 0000 01BB     lcdbuffer[9] = 0;
; 0000 01BC   }
; 0000 01BD   else
_0x47:
; 0000 01BE   {
; 0000 01BF     /* Select calibration value */
; 0000 01C0     b = rangemode & 3;
	MOV  R30,R5
	ANDI R30,LOW(0x3)
	MOV  R17,R30
; 0000 01C1 
; 0000 01C2     if (calib_offset[b] > value)
	RCALL SUBOPT_0xD
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0xE
	RCALL __CPD12
	BRSH _0x49
; 0000 01C3     {
; 0000 01C4       lcdbuffer[0] = '-';
	LDI  R30,LOW(45)
	STS  _lcdbuffer,R30
; 0000 01C5       value = calib_offset[b] - value;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL __SUBD12
	__PUTD1S 5
; 0000 01C6     }
; 0000 01C7     else
	RJMP _0x4A
_0x49:
; 0000 01C8     {
; 0000 01C9       lcdbuffer[0] = ' ';
	LDI  R30,LOW(32)
	STS  _lcdbuffer,R30
; 0000 01CA       value = value - calib_offset[b];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	RCALL __SUBD21
	__PUTD2S 5
; 0000 01CB     }
_0x4A:
; 0000 01CC     // sprintf(buf, "before mul : %u", 2);  // or whatever variable
; 0000 01CD     // lcd_string(buf,0);
; 0000 01CE     // delay_ms(1000);
; 0000 01CF     MUL_LONG_SHORT_S2(value, calib[b], &l);
	RCALL SUBOPT_0xE
	RCALL __PUTPARD1
	MOV  R30,R17
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	MOVW R26,R28
	ADIW R26,7
	RCALL _MUL_LONG_SHORT_S2
; 0000 01D0     // sprintf(buf, "after mul: %u", l);  // or whatever variable
; 0000 01D1     // lcd_string(buf,0);
; 0000 01D2     // delay_ms(1000);
; 0000 01D3     b = long2ascii(lcdbuffer + 1, l);
	__POINTW1MN _lcdbuffer,1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 3
	RCALL _long2ascii
	MOV  R17,R30
; 0000 01D4 
; 0000 01D5     /* High range shifts 1E3 */
; 0000 01D6     if (rangemode & RANGE_HIGH)
	SBRC R5,1
; 0000 01D7       b++;
	SUBI R17,-1
; 0000 01D8 
; 0000 01D9     lcdbuffer[6] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _lcdbuffer,6
; 0000 01DA     lcdbuffer[7] = decades[b]; /* range = 1 shifts 1E3 */
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_decades)
	SBCI R31,HIGH(-_decades)
	LD   R30,Z
	__PUTB1MN _lcdbuffer,7
; 0000 01DB     lcdbuffer[8] = 'F';
	LDI  R30,LOW(70)
_0x6B:
	__PUTB1MN _lcdbuffer,8
; 0000 01DC     lcdbuffer[9] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _lcdbuffer,9
; 0000 01DD   }
; 0000 01DE     // sprintf(buf, "after ascii: %u", decades[b]); // or whatever variable
; 0000 01DF     //lcd_string(buf, 0);
; 0000 01E0     //delay_ms(1000);
; 0000 01E1   /* Write high threshold in first line, low threshold in second */
; 0000 01E2   if (rangemode & RANGE_HIGH_THRESH)
	SBRS R5,0
	RJMP _0x4C
; 0000 01E3     b = 7;
	LDI  R17,LOW(7)
; 0000 01E4   else
	RJMP _0x4D
_0x4C:
; 0000 01E5     b = 23;
	LDI  R17,LOW(23)
; 0000 01E6    // sprintf(buf, "%u", lcdbuffer);  // or whatever variable
; 0000 01E7     //lcd_string(buf,b);
; 0000 01E8   lcd_string(lcdbuffer, b);
_0x4D:
	LDI  R30,LOW(_lcdbuffer)
	LDI  R31,HIGH(_lcdbuffer)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	RCALL _lcd_string
; 0000 01E9 
; 0000 01EA }
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND

	.DSEG
_0x43:
	.BYTE 0x18
;
;void calibrate_zero(void)
; 0000 01ED {

	.CSEG
_calibrate_zero:
; .FSTART _calibrate_zero
; 0000 01EE   char oldrange = rangemode;
; 0000 01EF   unsigned long l;
; 0000 01F0 
; 0000 01F1   rangemode = 0;
	RCALL SUBOPT_0x12
;	oldrange -> R17
;	l -> Y+1
; 0000 01F2 
; 0000 01F3   l = measure();
; 0000 01F4   l = measure();
	RCALL SUBOPT_0x13
; 0000 01F5 
; 0000 01F6   calib_offset[rangemode] = l;
	RCALL SUBOPT_0x14
; 0000 01F7 
; 0000 01F8   rangemode = RANGE_HIGH_THRESH;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x15
; 0000 01F9 
; 0000 01FA   l = measure();
; 0000 01FB   l = measure();
	RCALL SUBOPT_0x13
; 0000 01FC 
; 0000 01FD   calib_offset[rangemode] = l;
	RCALL SUBOPT_0x14
; 0000 01FE 
; 0000 01FF   rangemode = oldrange;
	RJMP _0x20C0003
; 0000 0200 }
; .FEND
;
;void calibrate(void)
; 0000 0203 {
_calibrate:
; .FSTART _calibrate
; 0000 0204   char oldrange = rangemode;
; 0000 0205   unsigned long value;
; 0000 0206 
; 0000 0207   rangemode = 0;
	RCALL SUBOPT_0x12
;	oldrange -> R17
;	value -> Y+1
; 0000 0208   value = measure();
; 0000 0209   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
; 0000 020A   calib[rangemode] = CALIB_LOW / (value >> 8) + 1;
	RCALL SUBOPT_0x19
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1A
	POP  R26
	POP  R27
	RCALL SUBOPT_0x1B
; 0000 020B 
; 0000 020C   rangemode = RANGE_HIGH_THRESH;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x15
; 0000 020D   value = measure();
; 0000 020E   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
; 0000 020F   calib[rangemode] = CALIB_LOW / (value >> 8) + 1;
	RCALL SUBOPT_0x19
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1A
	POP  R26
	POP  R27
	RCALL SUBOPT_0x1B
; 0000 0210 
; 0000 0211   rangemode = RANGE_HIGH;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x15
; 0000 0212   value = measure();
; 0000 0213   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
; 0000 0214   calib[rangemode] = CALIB_HIGH / value + 1;
	RCALL SUBOPT_0x19
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1C
	POP  R26
	POP  R27
	RCALL SUBOPT_0x1B
; 0000 0215 
; 0000 0216   rangemode = RANGE_HIGH | RANGE_HIGH_THRESH;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x15
; 0000 0217   value = measure();
; 0000 0218   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
; 0000 0219   calib[rangemode] = CALIB_HIGH / value + 1;
	RCALL SUBOPT_0x19
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x1C
	POP  R26
	POP  R27
	RCALL SUBOPT_0x1B
; 0000 021A 
; 0000 021B   rangemode = oldrange;
_0x20C0003:
	MOV  R5,R17
; 0000 021C }
	LDD  R17,Y+0
_0x20C0004:
	ADIW R28,5
	RET
; .FEND
;
;/* Hold-down-button menu implementation: */
;
;char menu(void)
; 0000 0221 {
_menu:
; .FSTART _menu
; 0000 0222   unsigned char i;
; 0000 0223 
; 0000 0224   lcd_clear();
	ST   -Y,R17
;	i -> R17
	RCALL _lcd_clear
; 0000 0225 
; 0000 0226   for (i = 0; i < MENU_ITEMS; i++)
	LDI  R17,LOW(0)
_0x4F:
	CPI  R17,6
	BRSH _0x50
; 0000 0227   {
; 0000 0228     lcd_string(menu_item[i], 0);
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(0)
	RCALL _lcd_string
; 0000 0229     delay_ms(MENU_SPEED);
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	RCALL _delay_ms
; 0000 022A 
; 0000 022B     if (!BUTTON_PUSHED)
	SBIC 0x10,2
; 0000 022C       break;
	RJMP _0x50
; 0000 022D   }
	SUBI R17,-1
	RJMP _0x4F
_0x50:
; 0000 022E 
; 0000 022F   if (i == MENU_ITEMS)
	CPI  R17,6
	BRNE _0x52
; 0000 0230   {
; 0000 0231     /* Just clear display, if user went out of menu */
; 0000 0232     lcd_clear();
	RCALL _lcd_clear
; 0000 0233 
; 0000 0234     /* Wait for release of button */
; 0000 0235     while (BUTTON_PUSHED)
_0x53:
	SBIS 0x10,2
; 0000 0236       ;
	RJMP _0x53
; 0000 0237     delay_ms(10);
	LDI  R26,LOW(10)
	RJMP _0x6C
; 0000 0238   }
; 0000 0239   else
_0x52:
; 0000 023A   {
; 0000 023B     /* Flash selected item */
; 0000 023C     lcd_clear();
	RCALL _lcd_clear
; 0000 023D     delay_ms(MENU_SPEED >> 2);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0xC
; 0000 023E     lcd_string(menu_item[i], 0);
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(0)
	RCALL _lcd_string
; 0000 023F     delay_ms(MENU_SPEED >> 1);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _delay_ms
; 0000 0240     lcd_clear();
	RCALL _lcd_clear
; 0000 0241     delay_ms(MENU_SPEED >> 2);
	LDI  R26,LOW(200)
_0x6C:
	LDI  R27,0
	RCALL _delay_ms
; 0000 0242   }
; 0000 0243 
; 0000 0244   return i;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0245 }
; .FEND
;
;void init(void)
; 0000 0248 {
_init:
; .FSTART _init
; 0000 0249 
; 0000 024A   /* Set datadirections */
; 0000 024B   DDRD = (1 << 4);    /* led output, rest input */
	LDI  R30,LOW(16)
	OUT  0x11,R30
; 0000 024C   PORTD &= ~(1 << 6); /* AIN0 port must be 0 */
	CBI  0x12,6
; 0000 024D 
; 0000 024E   /* Enable button pull up resistor */
; 0000 024F   PORTD |= (1 << 2);
	SBI  0x12,2
; 0000 0250 
; 0000 0251   /* Setup timer1 to normal operation */
; 0000 0252   TCCR1A = 0;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0253   TCCR1B = 0;
	RCALL SUBOPT_0x1
; 0000 0254   TIMSK = (1 << TOIE1); //(mega8)
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0255   // TIMSK1 = (1<<TOIE1); //(mega48/88/168)
; 0000 0256 
; 0000 0257   /* Setup analog comperator to generate rising edge interrupt */
; 0000 0258   ACSR = (1 << ACIS0) | (1 << ACIS1) | (1 << ACIE);
	LDI  R30,LOW(11)
	OUT  0x8,R30
; 0000 0259 
; 0000 025A   /* Setup analog comperator to use ADMUX */
; 0000 025B   ADMUX = ADMUX_LOW;
	LDI  R30,LOW(1)
	OUT  0x7,R30
; 0000 025C   SFIOR |= (1 << ACME);
	IN   R30,0x30
	ORI  R30,8
	OUT  0x30,R30
; 0000 025D   // ADCSRB |= (1<<ACME);
; 0000 025E   // DIDR1 |= (1<<AIN1D)|(1<<AIN0D);
; 0000 025F }
	RET
; .FEND
;
;void main(void)
; 0000 0262 {
_main:
; .FSTART _main
; 0000 0263 
; 0000 0264   // Declare your local variables here
; 0000 0265   unsigned long l;
; 0000 0266 
; 0000 0267   // Input/Output Ports initialization
; 0000 0268   // Port B initialization
; 0000 0269   // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 026A   DDRB = (1 << DDB7) | (1 << DDB6) | (1 << DDB5) | (1 << DDB4) | (1 << DDB3) | (1 << DDB2) | (1 << DDB1) | (1 << DDB0);
	SBIW R28,4
;	l -> Y+0
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 026B   // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 026C   PORTB = (0 << PORTB7) | (0 << PORTB6) | (0 << PORTB5) | (0 << PORTB4) | (0 << PORTB3) | (0 << PORTB2) | (0 << PORTB1)  ...
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 026D 
; 0000 026E   // Port C initialization
; 0000 026F   // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0270   DDRC = (0 << DDC6) | (0 << DDC5) | (0 << DDC4) | (0 << DDC3) | (0 << DDC2) | (0 << DDC1) | (0 << DDC0);
	OUT  0x14,R30
; 0000 0271   // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0272   PORTC = (0 << PORTC6) | (0 << PORTC5) | (0 << PORTC4) | (0 << PORTC3) | (0 << PORTC2) | (0 << PORTC1) | (0 << PORTC0);
	OUT  0x15,R30
; 0000 0273 
; 0000 0274   // Port D initialization
; 0000 0275   // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0276   DDRD = (0 << DDD7) | (0 << DDD6) | (0 << DDD5) | (0 << DDD4) | (0 << DDD3) | (0 << DDD2) | (0 << DDD1) | (0 << DDD0);
	OUT  0x11,R30
; 0000 0277   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0278   PORTD = (0 << PORTD7) | (0 << PORTD6) | (0 << PORTD5) | (0 << PORTD4) | (0 << PORTD3) | (0 << PORTD2) | (0 << PORTD1)  ...
	OUT  0x12,R30
; 0000 0279 
; 0000 027A   // Timer/Counter 0 initialization
; 0000 027B   // Clock source: System Clock
; 0000 027C   // Clock value: Timer 0 Stopped
; 0000 027D   TCCR0 = (0 << CS02) | (0 << CS01) | (0 << CS00);
	OUT  0x33,R30
; 0000 027E   TCNT0 = 0x00;
	OUT  0x32,R30
; 0000 027F 
; 0000 0280   // Timer/Counter 1 initialization
; 0000 0281   // Clock source: System Clock
; 0000 0282   // Clock value: Timer1 Stopped
; 0000 0283   // Mode: Normal top=0xFFFF
; 0000 0284   // OC1A output: Disconnected
; 0000 0285   // OC1B output: Disconnected
; 0000 0286   // Noise Canceler: Off
; 0000 0287   // Input Capture on Falling Edge
; 0000 0288   // Timer1 Overflow Interrupt: Off
; 0000 0289   // Input Capture Interrupt: Off
; 0000 028A   // Compare A Match Interrupt: Off
; 0000 028B   // Compare B Match Interrupt: Off
; 0000 028C   TCCR1A = (0 << COM1A1) | (0 << COM1A0) | (0 << COM1B1) | (0 << COM1B0) | (0 << WGM11) | (0 << WGM10);
	OUT  0x2F,R30
; 0000 028D   TCCR1B = (0 << ICNC1) | (0 << ICES1) | (0 << WGM13) | (0 << WGM12) | (0 << CS12) | (0 << CS11) | (0 << CS10);
	RCALL SUBOPT_0x1
; 0000 028E   TCNT1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 028F   TCNT1L = 0x00;
	OUT  0x2C,R30
; 0000 0290   ICR1H = 0x00;
	OUT  0x27,R30
; 0000 0291   ICR1L = 0x00;
	OUT  0x26,R30
; 0000 0292   OCR1AH = 0x00;
	OUT  0x2B,R30
; 0000 0293   OCR1AL = 0x00;
	OUT  0x2A,R30
; 0000 0294   OCR1BH = 0x00;
	OUT  0x29,R30
; 0000 0295   OCR1BL = 0x00;
	OUT  0x28,R30
; 0000 0296 
; 0000 0297   // Timer/Counter 2 initialization
; 0000 0298   // Clock source: System Clock
; 0000 0299   // Clock value: Timer2 Stopped
; 0000 029A   // Mode: Normal top=0xFF
; 0000 029B   // OC2 output: Disconnected
; 0000 029C   ASSR = 0 << AS2;
	OUT  0x22,R30
; 0000 029D   TCCR2 = (0 << PWM2) | (0 << COM21) | (0 << COM20) | (0 << CTC2) | (0 << CS22) | (0 << CS21) | (0 << CS20);
	OUT  0x25,R30
; 0000 029E   TCNT2 = 0x00;
	OUT  0x24,R30
; 0000 029F   OCR2 = 0x00;
	OUT  0x23,R30
; 0000 02A0 
; 0000 02A1   // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02A2   TIMSK = (0 << OCIE2) | (0 << TOIE2) | (0 << TICIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (0 << TOIE1) | (0 << TOIE0);
	OUT  0x39,R30
; 0000 02A3 
; 0000 02A4   // External Interrupt(s) initialization
; 0000 02A5   // INT0: Off
; 0000 02A6   // INT1: Off
; 0000 02A7   MCUCR = (0 << ISC11) | (0 << ISC10) | (0 << ISC01) | (0 << ISC00);
	OUT  0x35,R30
; 0000 02A8 
; 0000 02A9   // USART initialization
; 0000 02AA   // USART disabled
; 0000 02AB   UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (0 << TXEN) | (0 << UCSZ2) | (0 << RXB8) | (0 << TX ...
	OUT  0xA,R30
; 0000 02AC 
; 0000 02AD   // Analog Comparator initialization
; 0000 02AE   // Analog Comparator: Off
; 0000 02AF   // The Analog Comparator's positive input is
; 0000 02B0   // connected to the AIN0 pin
; 0000 02B1   // The Analog Comparator's negative input is
; 0000 02B2   // connected to the AIN1 pin
; 0000 02B3   ACSR = (1 << ACD) | (0 << ACBG) | (0 << ACO) | (0 << ACI) | (0 << ACIE) | (0 << ACIC) | (0 << ACIS1) | (0 << ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02B4   SFIOR = (0 << ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02B5 
; 0000 02B6   // ADC initialization
; 0000 02B7   // ADC disabled
; 0000 02B8   ADCSRA = (0 << ADEN) | (0 << ADSC) | (0 << ADFR) | (0 << ADIF) | (0 << ADIE) | (0 << ADPS2) | (0 << ADPS1) | (0 << ADP ...
	OUT  0x6,R30
; 0000 02B9 
; 0000 02BA   // SPI initialization
; 0000 02BB   // SPI disabled
; 0000 02BC   SPCR = (0 << SPIE) | (0 << SPE) | (0 << DORD) | (0 << MSTR) | (0 << CPOL) | (0 << CPHA) | (0 << SPR1) | (0 << SPR0);
	OUT  0xD,R30
; 0000 02BD 
; 0000 02BE   // TWI initialization
; 0000 02BF   // TWI disabled
; 0000 02C0   TWCR = (0 << TWEA) | (0 << TWSTA) | (0 << TWSTO) | (0 << TWEN) | (0 << TWIE);
	OUT  0x36,R30
; 0000 02C1 
; 0000 02C2   lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 02C3 
; 0000 02C4   init(); // init peripherals/adc/timers/etc..
	RCALL _init
; 0000 02C5 
; 0000 02C6   eeprom_read(); // reads calibration values or settings from EEPROM.
	RCALL _eeprom_read
; 0000 02C7 
; 0000 02C8 #asm("sei"); // enables global interrupts
	sei
; 0000 02C9 
; 0000 02CA   LED_OFF; // turns off an LED (probably an indicator for measurement status).
	SBI  0x12,4
; 0000 02CB 
; 0000 02CC   rangemode = RANGE_AUTO; // setting Up the Measurement Mode
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 02CD 
; 0000 02CE   while (1)
_0x57:
; 0000 02CF   {
; 0000 02D0     /* Toggle high/low threshold */
; 0000 02D1     rangemode ^= RANGE_HIGH_THRESH;
	LDI  R30,LOW(1)
	EOR  R5,R30
; 0000 02D2     l = measure();
	RCALL _measure
	RCALL __PUTD1S0
; 0000 02D3 
; 0000 02D4     // sprintf(buf, "ADC: %u", l);  // or whatever variable
; 0000 02D5     // lcd_string(buf,0);
; 0000 02D6     // delay_ms(1000);
; 0000 02D7     if (BUTTON_PUSHED)
	SBIC 0x10,2
	RJMP _0x5A
; 0000 02D8     {
; 0000 02D9       /* Stop any cap. charging */
; 0000 02DA       LED_OFF;
	SBI  0x12,4
; 0000 02DB       LOW_RANGE;
	CBI  0x11,5
	CBI  0x12,5
; 0000 02DC       DISCHARGE_ON;
	SBI  0x11,6
; 0000 02DD 
; 0000 02DE       /* Menu implementation */
; 0000 02DF       switch (menu())
	RCALL _menu
; 0000 02E0       {
; 0000 02E1       case 0: /* auto range */
	CPI  R30,0
	BRNE _0x5E
; 0000 02E2         rangemode |= RANGE_AUTO;
	LDI  R30,LOW(4)
	OR   R5,R30
; 0000 02E3         break;
	RJMP _0x5D
; 0000 02E4       case 1: /* low range */
_0x5E:
	CPI  R30,LOW(0x1)
	BRNE _0x5F
; 0000 02E5         rangemode &= ~(RANGE_AUTO | RANGE_HIGH);
	LDI  R30,LOW(249)
	AND  R5,R30
; 0000 02E6         break;
	RJMP _0x5D
; 0000 02E7       case 2: /* high range */
_0x5F:
	CPI  R30,LOW(0x2)
	BRNE _0x60
; 0000 02E8         rangemode &= ~RANGE_AUTO;
	LDI  R30,LOW(251)
	AND  R5,R30
; 0000 02E9         rangemode |= RANGE_HIGH;
	LDI  R30,LOW(2)
	OR   R5,R30
; 0000 02EA         break;
	RJMP _0x5D
; 0000 02EB       case 3:
_0x60:
	CPI  R30,LOW(0x3)
	BRNE _0x61
; 0000 02EC         calibrate_zero();
	RCALL _calibrate_zero
; 0000 02ED         break;
	RJMP _0x5D
; 0000 02EE       case 4:
_0x61:
	CPI  R30,LOW(0x4)
	BRNE _0x62
; 0000 02EF         calibrate();
	RCALL _calibrate
; 0000 02F0         break;
	RJMP _0x5D
; 0000 02F1       case 5:
_0x62:
	CPI  R30,LOW(0x5)
	BRNE _0x5D
; 0000 02F2         eeprom_write();
	RCALL _eeprom_write
; 0000 02F3         break;
; 0000 02F4       }
_0x5D:
; 0000 02F5     }
; 0000 02F6     else
	RJMP _0x64
_0x5A:
; 0000 02F7       calc_and_show(l);
	RCALL __GETD2S0
	RCALL _calc_and_show
; 0000 02F8   }
_0x64:
	RJMP _0x57
; 0000 02F9 }
_0x65:
	RJMP _0x65
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	OR   R30,R26
	OUT  0x18,R30
	RCALL SUBOPT_0x1E
	SBI  0x18,4
	RCALL SUBOPT_0x1E
	CBI  0x18,4
	RCALL SUBOPT_0x1E
	RJMP _0x20C0002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20C0002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R4,Y+1
	LDD  R7,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0xC
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0xC
	LDI  R30,LOW(0)
	MOV  R7,R30
	MOV  R4,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R4,R6
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R7
	MOV  R26,R7
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x20C0002
_0x2000004:
	INC  R4
	SBI  0x18,5
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,5
	RJMP _0x20C0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL SUBOPT_0x2
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	CBI  0x18,4
	CBI  0x18,5
	CBI  0x18,6
	LDD  R6,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_eeprom_read_block:
; .FSTART _eeprom_read_block
	RCALL SUBOPT_0x2
	RCALL __SAVELOCR4
	__GETWRS 16,17,8
	__GETWRS 18,19,6
_0x2020003:
	RCALL SUBOPT_0x20
	BREQ _0x2020005
	PUSH R17
	PUSH R16
	RCALL SUBOPT_0x21
	RCALL __EEPROMRDB
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x2020003
_0x2020005:
	RJMP _0x20C0001
; .FEND
_eeprom_write_block:
; .FSTART _eeprom_write_block
	RCALL SUBOPT_0x2
	RCALL __SAVELOCR4
	__GETWRS 16,17,6
	__GETWRS 18,19,8
_0x2020006:
	RCALL SUBOPT_0x20
	BREQ _0x2020008
	PUSH R17
	PUSH R16
	RCALL SUBOPT_0x21
	LD   R30,X
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RJMP _0x2020006
_0x2020008:
_0x20C0001:
	RCALL __LOADLOCR4
	ADIW R28,10
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_decades:
	.BYTE 0x5
_tenths_tab:
	.BYTE 0x28
_lcdbuffer:
	.BYTE 0x20
_timer_highword:
	.BYTE 0x2
_measure_state:
	.BYTE 0x1
_set_admux:
	.BYTE 0x1
_menu_item:
	.BYTE 0xC
_calib:
	.BYTE 0x8
_calib_offset:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDS  R26,_measure_state
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	OUT  0x2E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	CLR  R24
	CLR  R25
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CLR  R22
	CLR  R23
	RCALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_calib_offset)
	LDI  R31,HIGH(_calib_offset)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(_calib)
	LDI  R31,HIGH(_calib)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x7:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R26,LOW(_tenths_tab)
	LDI  R27,HIGH(_tenths_tab)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	RCALL SUBOPT_0x4
	RCALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x9:
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	MOV  R30,R17
	LDI  R26,LOW(_calib_offset)
	LDI  R27,HIGH(_calib_offset)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_calib)
	LDI  R27,HIGH(_calib)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	SBIW R28,4
	ST   -Y,R17
	MOV  R17,R5
	CLR  R5
	RCALL _measure
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x13:
	RCALL _measure
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x14:
	MOV  R30,R5
	LDI  R26,LOW(_calib_offset)
	LDI  R27,HIGH(_calib_offset)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	__GETD2S 1
	RCALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOV  R5,R30
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	MOV  R30,R5
	LDI  R26,LOW(_calib_offset)
	LDI  R27,HIGH(_calib_offset)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x18:
	RCALL __SUBD21
	__PUTD2S 1
	MOV  R30,R5
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x17
	LDI  R30,LOW(8)
	RCALL __LSRD12
	__GETD2N 0xF424000
	RCALL __DIVD21U
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	__GETD1S 1
	__GETD2N 0x3E80000
	RCALL __DIVD21U
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	MOV  R30,R17
	LDI  R26,LOW(_menu_item)
	LDI  R27,HIGH(_menu_item)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
