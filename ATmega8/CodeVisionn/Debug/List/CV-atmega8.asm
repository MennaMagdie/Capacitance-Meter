
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
	.DEF _gx=R6
	.DEF _gx_msb=R7
	.DEF _gy=R8
	.DEF _gy_msb=R9

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x4

_0x3:
	.DB  0x70,0x6E,0x75,0x6D,0x20
_0x5:
	.DB  LOW(_0x4),HIGH(_0x4),LOW(_0x4+12),HIGH(_0x4+12),LOW(_0x4+24),HIGH(_0x4+24),LOW(_0x4+36),HIGH(_0x4+36)
	.DB  LOW(_0x4+52),HIGH(_0x4+52),LOW(_0x4+68),HIGH(_0x4+68)
_0x6:
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
_0x20021:
	.DB  0x0,0xCA,0x9A,0x3B,0x0,0xE1,0xF5,0x5
	.DB  0x80,0x96,0x98,0x0,0x40,0x42,0xF,0x0
	.DB  0xA0,0x86,0x1,0x0,0x10,0x27,0x0,0x0
	.DB  0xE8,0x3,0x0,0x0,0x64,0x0,0x0,0x0
	.DB  0xA,0x0,0x0,0x0,0x1
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x05
	.DW  _decades
	.DW  _0x3*2

	.DW  0x0C
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x4+12
	.DW  _0x0*2+12

	.DW  0x0C
	.DW  _0x4+24
	.DW  _0x0*2+24

	.DW  0x10
	.DW  _0x4+36
	.DW  _0x0*2+36

	.DW  0x10
	.DW  _0x4+52
	.DW  _0x0*2+52

	.DW  0x11
	.DW  _0x4+68
	.DW  _0x0*2+68

	.DW  0x0C
	.DW  _menu_item
	.DW  _0x5*2

	.DW  0x08
	.DW  _calib
	.DW  _0x6*2

	.DW  0x06
	.DW  _0x4A
	.DW  _0x0*2+85

	.DW  0x06
	.DW  _0x4A+6
	.DW  _0x0*2+91

	.DW  0x06
	.DW  _0x4A+12
	.DW  _0x0*2+97

	.DW  0x06
	.DW  _0x4A+18
	.DW  _0x0*2+103

	.DW  0x25
	.DW  _tenths_tab
	.DW  _0x20021*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

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
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 3/21/2025
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
;#include <delay.h>
;#include <eeprom.h>
;//#pragma data:code
;#include "lcd.h"
;
;// Declare your global variables here
;
;/* Hardware IO abstraction macros */
;
;/* AIN0 out also discharges cap */
;#define DISCHARGE_ON  DDRD.6 = 1
;#define DISCHARGE_OFF DDRD.6 = 0
;
;/* Range control */
;#define HIGH_RANGE PORTD.5 = 1; DDRD.5 = 1
;#define LOW_RANGE  DDRD.5 = 0; PORTD.5 = 0
;
;#define PULLDOWN_RANGE PORTD &= ~(1<<5); DDRD |= (1<<5)
;
;/* Threshold selection */
;#define ADMUX_LOW 1
;#define ADMUX_MEDIUM 2
;#define ADMUX_HIGH 3
;
;/* Timer abstraction */
;#define TIMER_VALUE TCNT1
;#define TIMER_START TCCR1B = (1<<CS10)
;#define TIMER_STOP  TCCR1B = 0
;
;/* Led abstraction */
;#define LED_ON  PORTD.4 = 0
;#define LED_OFF PORTD.4 = 1
;
;/* Button abstraction */
;#define BUTTON_PUSHED (!PIND.2)
;
;char decades[5] = {'p','n','u','m',' '};

	.DSEG
;char lcdbuffer[32];
;unsigned short volatile timer_highword;
;
;
;/* Program states: */
;#define STATE_IDLE 0
;#define STATE_LOW_THRESH 1
;#define STATE_HIGH_THRESH 2
;#define STATE_DONE 3
;//#define STATE_BUTTONDOWN 4
;
;
;unsigned char volatile measure_state;
;
;/* The following is the value the analog compare interrupt will set ADMUX: */
;unsigned char volatile set_admux;
;
;/* The rangemode defines the measurement operation */
;#define RANGE_HIGH_THRESH 1   /* If missing: threshold low */
;#define RANGE_HIGH 2          /* If missing: range low */
;#define RANGE_AUTO 4
;#define RANGE_OVERFLOW 8      /* If set: cap was out of range */
;unsigned char rangemode = RANGE_AUTO;
;
;
;/* Constants defining measuring operation: */
;#define EXTRA_DISCHARGE_MS 100     /* Extra discharging that is done even after a threshold is crossed */
;#define LOW_RANGE_TIMEOUT 500     /* At autorange, when to go to high range */
;#define HIGH_RANGE_TIMEOUT 10000  /* When to give up completely */
;
;
;/* Menu system */
;#define MENU_SPEED 800 /* ms each menu item is shown */
;
;#define MENU_ITEMS 6
;char *menu_item[MENU_ITEMS] = {"Range: Auto","Range: Low ","Range: High","Calibrate: Zero","Calibrate: 1 uF","Save calib ...
_0x4:
	.BYTE 0x55
;
;
;#define CALIB_LOW 256000000    /* for 1uF reference prescale: >> 8 */
;#define CALIB_HIGH 65536000    /* for 1uF reference */
;
;#define EEPROM_HEADER 1
;#define EEPROM_DATA 3
;
;
;unsigned short calib[4] = {21430, 9308, 19423, 8437};
;//unsigned short calib[4] = {53575, 46540, 19423, 8437};
;
;unsigned long calib_offset[4] = {0,0,0,0};
;
;#define SIZE_OF_CALIB 8
;#define SIZE_OF_CALIBOFFSET 16
;
;  /* This macro fractionally multiplies 16.16 bit with 0.16 bit both unsigned,
;     shifting the result two bytes right and returning 16.16 bit.
;
;   Result is 16.16 bit unsigned */
;
;// Temporary globals to bridge C to asm
;unsigned int gx, gy;
;unsigned long gresult;
;
;// void MUL_LONG_SHORT_S2(unsigned int x, unsigned int y, unsigned long *result)
;// {
;//     gx = x;
;//     gy = y;
;
;//     #asm
;//         lds r24, _gx
;//         lds r25,
;//         lds r22, _gy
;//         lds r23, _gy+1
;
;//         clr r18
;//         clr r19
;//         clr r20
;//         clr r21
;
;//         ; mul x_low * y_low
;//         mul r24, r22
;//         mov r21, r1
;//         clr r1
;
;//         ; mul x_low * y_high
;//         mul r24, r23
;//         add r21, r0
;//         adc r20, r1
;//         adc r19, r18
;//         clr r1
;
;//         ; mul x_high * y_low
;//         mul r25, r22
;//         add r21, r0
;//         adc r20, r1
;//         adc r19, r18
;//         clr r1
;
;//         ; mul x_high * y_high
;//         mul r25, r23
;//         add r20, r0
;//         adc r19, r1
;//         adc r18, r18
;//         clr r1
;
;//         ; store into gresult
;//         sts _gresult, r21
;//         sts _gresult+1, r20
;//         sts _gresult+2, r19
;//         sts _gresult+3, r18
;//     #endasm
;
;//       *result = gresult;
;//   }
;
;#include <stdint.h>
;void MUL_LONG_SHORT_S2(int32_t x, int16_t y, uint32_t *result) {
; 0000 00B1 void MUL_LONG_SHORT_S2(int32_t x, int16_t y, uint32_t *result) {

	.CSEG
_MUL_LONG_SHORT_S2:
; .FSTART _MUL_LONG_SHORT_S2
; 0000 00B2     int16_t x_high = x >> 16;              // Integer part (signed)
; 0000 00B3     uint16_t x_low = x & 0xFFFF;           // Fractional part (unsigned)
; 0000 00B4 
; 0000 00B5     int32_t part1 = (int32_t)x_high * y;   // Signed mult: integer part
; 0000 00B6     int32_t part2 = ((int32_t)x_low * y + 0x8000) >> 16; // Rounded fractional part
; 0000 00B7 
; 0000 00B8     int32_t combined = part1 + part2;
; 0000 00B9 
; 0000 00BA     *result = (uint32_t)combined;          // Cast final signed result to unsigned
	RCALL SUBOPT_0x0
	SBIW R28,12
	RCALL __SAVELOCR4
;	x -> Y+20
;	y -> Y+18
;	*result -> Y+16
;	x_high -> R16,R17
;	x_low -> R18,R19
;	part1 -> Y+12
;	part2 -> Y+8
;	combined -> Y+4
	__GETD2S 20
	LDI  R30,LOW(16)
	RCALL __ASRD12
	MOVW R16,R30
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	MOVW R18,R30
	MOVW R26,R16
	RCALL __CWD2
	RCALL SUBOPT_0x1
	__PUTD1S 12
	MOVW R26,R18
	CLR  R24
	CLR  R25
	RCALL SUBOPT_0x1
	__ADDD1N 32768
	RCALL __ASRD16
	__PUTD1S 8
	__GETD2S 12
	RCALL __ADDD12
	__PUTD1S 4
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RCALL __PUTDP1
; 0000 00BB }
	RCALL __LOADLOCR4
	ADIW R28,24
	RET
; .FEND
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00C3 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C4 // Place your code here
; 0000 00C5       timer_highword++;
	LDI  R26,LOW(_timer_highword)
	LDI  R27,HIGH(_timer_highword)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00C6 
; 0000 00C7 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;      // Analog Comparator interrupt service routine
;      interrupt [ANA_COMP] void ana_comp_isr(void)
; 0000 00CB       {
_ana_comp_isr:
; .FSTART _ana_comp_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00CC       // Place your code here
; 0000 00CD       if (measure_state == STATE_LOW_THRESH) {
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x1)
	BRNE _0x7
; 0000 00CE             /* We just got low threshold interrupt, start timer and set high threshold */
; 0000 00CF             TIMER_START;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 00D0             ADMUX = set_admux;
	LDS  R30,_set_admux
	OUT  0x7,R30
; 0000 00D1             measure_state = STATE_HIGH_THRESH;
	LDI  R30,LOW(2)
	RJMP _0x77
; 0000 00D2           }
; 0000 00D3           else if(measure_state == STATE_HIGH_THRESH) {
_0x7:
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x2)
	BRNE _0x9
; 0000 00D4             /* High threshold interrupt, verify it, then stop timer */
; 0000 00D5             if (ACSR & (1<<ACO)) {
	SBIS 0x8,5
	RJMP _0xA
; 0000 00D6               TIMER_STOP;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 00D7               measure_state = STATE_DONE;
	LDI  R30,LOW(3)
_0x77:
	STS  _measure_state,R30
; 0000 00D8             }
; 0000 00D9           }
_0xA:
; 0000 00DA 
; 0000 00DB       }
_0x9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;
;// make sure elnext 2 functions will work 3shan momken ye3melo moshkela bsabab ellibrary
;void eeprom_read(void)
; 0000 00E1 {
_eeprom_read:
; .FSTART _eeprom_read
; 0000 00E2   if (eeprom_read_byte((void*)EEPROM_HEADER) != 'C')
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x43)
	BREQ _0xB
; 0000 00E3     return;
	RET
; 0000 00E4 
; 0000 00E5   if (eeprom_read_byte((unsigned char*)(EEPROM_HEADER + 1)) != 'D')
_0xB:
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x44)
	BREQ _0xC
; 0000 00E6     return;
	RET
; 0000 00E7 
; 0000 00E8 
; 0000 00E9   eeprom_read_block(calib_offset, (eeprom void*)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
_0xC:
	RCALL SUBOPT_0x3
	RCALL _eeprom_read_block
; 0000 00EA   eeprom_read_block(calib, (eeprom char*)EEPROM_DATA + SIZE_OF_CALIBOFFSET, SIZE_OF_CALIB);
	RCALL SUBOPT_0x4
	RCALL _eeprom_read_block
; 0000 00EB 
; 0000 00EC }
	RET
; .FEND
;
;void eeprom_write(void)
; 0000 00EF {
_eeprom_write:
; .FSTART _eeprom_write
; 0000 00F0   eeprom_write_byte((void*)EEPROM_HEADER, 'C');
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	LDI  R30,LOW(67)
	RCALL __EEPROMWRB
; 0000 00F1   eeprom_write_byte((eeprom char*)EEPROM_HEADER+1, 'D');
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	LDI  R30,LOW(68)
	RCALL __EEPROMWRB
; 0000 00F2 
; 0000 00F3   eeprom_write_block(calib_offset, (eeprom void*)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
	RCALL SUBOPT_0x3
	RCALL _eeprom_write_block
; 0000 00F4   eeprom_write_block(calib, (eeprom void*)(EEPROM_DATA + SIZE_OF_CALIBOFFSET), SIZE_OF_CALIB);
	RCALL SUBOPT_0x4
	RCALL _eeprom_write_block
; 0000 00F5 
; 0000 00F6 }
	RET
; .FEND
;
;//
;
;long measure(void)
; 0000 00FB {
_measure:
; .FSTART _measure
; 0000 00FC   unsigned short i;
; 0000 00FD 
; 0000 00FE   measure_state = STATE_IDLE;
	RCALL __SAVELOCR2
;	i -> R16,R17
	LDI  R30,LOW(0)
	STS  _measure_state,R30
; 0000 00FF 
; 0000 0100   /* Discharge cap until below low threshold + some extra */
; 0000 0101   ADMUX = ADMUX_LOW;
	LDI  R30,LOW(1)
	OUT  0x7,R30
; 0000 0102   PULLDOWN_RANGE;      /* Use range signal as pull down */
	CBI  0x12,5
	SBI  0x11,5
; 0000 0103 
; 0000 0104   while(1) {
_0xD:
; 0000 0105     /* Enable comperator and check value */
; 0000 0106     DISCHARGE_OFF;
	CBI  0x11,6
; 0000 0107     ms_spin(1);
	RCALL SUBOPT_0x5
; 0000 0108 
; 0000 0109     /* This value must be checked in every loop */
; 0000 010A     if (BUTTON_PUSHED)
	SBIC 0x10,2
	RJMP _0x12
; 0000 010B       return 0;
	RCALL SUBOPT_0x6
	RJMP _0x20E0006
; 0000 010C 
; 0000 010D     if (!(ACSR & (1<<ACO)))
_0x12:
	SBIS 0x8,5
; 0000 010E       break;
	RJMP _0xF
; 0000 010F 
; 0000 0110     /* Discharge for a while */
; 0000 0111     DISCHARGE_ON;
	SBI  0x11,6
; 0000 0112     ms_spin(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0x7
; 0000 0113 
; 0000 0114 
; 0000 0115   }
	RJMP _0xD
_0xF:
; 0000 0116 
; 0000 0117   DISCHARGE_ON;
	SBI  0x11,6
; 0000 0118   ms_spin(EXTRA_DISCHARGE_MS);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x7
; 0000 0119 
; 0000 011A   /* Prepare: reset timer, low range */
; 0000 011B   TIMER_STOP;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 011C   TIMER_VALUE = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 011D   timer_highword = 0;
	STS  _timer_highword,R30
	STS  _timer_highword+1,R30
; 0000 011E 
; 0000 011F   LOW_RANGE;
	CBI  0x11,5
	CBI  0x12,5
; 0000 0120 
; 0000 0121   measure_state = STATE_LOW_THRESH;
	LDI  R30,LOW(1)
	STS  _measure_state,R30
; 0000 0122 
; 0000 0123   /* High or medium threshold */
; 0000 0124   if (rangemode & RANGE_HIGH_THRESH)
	SBRS R5,0
	RJMP _0x1C
; 0000 0125     set_admux = ADMUX_HIGH;
	LDI  R30,LOW(3)
	RJMP _0x78
; 0000 0126   else
_0x1C:
; 0000 0127     set_admux = ADMUX_MEDIUM;
	LDI  R30,LOW(2)
_0x78:
	STS  _set_admux,R30
; 0000 0128 
; 0000 0129   /* Apply step */
; 0000 012A   LED_ON;
	CBI  0x12,4
; 0000 012B   DISCHARGE_OFF;
	CBI  0x11,6
; 0000 012C 
; 0000 012D   if (rangemode & RANGE_AUTO) {
	SBRS R5,2
	RJMP _0x22
; 0000 012E 
; 0000 012F     /* Autorange: See if low range produces something before LOW_RANGE_TIMEOUT ms */
; 0000 0130     i = 0;
	__GETWRN 16,17,0
; 0000 0131     while ((measure_state == STATE_LOW_THRESH) && (++i < LOW_RANGE_TIMEOUT)) {
_0x23:
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x1)
	BRNE _0x26
	MOVW R30,R16
	ADIW R30,1
	MOVW R16,R30
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLO _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 0132       ms_spin(1);
	RCALL SUBOPT_0x5
; 0000 0133 
; 0000 0134       /* This value must be checked in every loop */
; 0000 0135       if (BUTTON_PUSHED)
	SBIC 0x10,2
	RJMP _0x28
; 0000 0136         return 0;
	RCALL SUBOPT_0x6
	RJMP _0x20E0006
; 0000 0137     }
_0x28:
	RJMP _0x23
_0x25:
; 0000 0138 
; 0000 0139     if (i >= LOW_RANGE_TIMEOUT) {
	__CPWRN 16,17,500
	BRLO _0x29
; 0000 013A       /* low range timeout, go to high range (better discharge a little first) */
; 0000 013B       DISCHARGE_ON;
	SBI  0x11,6
; 0000 013C       ms_spin(EXTRA_DISCHARGE_MS);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x7
; 0000 013D       DISCHARGE_OFF;
	CBI  0x11,6
; 0000 013E       HIGH_RANGE;
	SBI  0x12,5
	SBI  0x11,5
; 0000 013F       rangemode |= RANGE_HIGH;
	LDI  R30,LOW(2)
	OR   R5,R30
; 0000 0140     }
; 0000 0141     else {
	RJMP _0x32
_0x29:
; 0000 0142       /* low range was ok, set flag accordingly */
; 0000 0143       rangemode &= ~RANGE_HIGH;
	LDI  R30,LOW(253)
	AND  R5,R30
; 0000 0144     }
_0x32:
; 0000 0145   }
; 0000 0146   else if (rangemode & RANGE_HIGH) {
	RJMP _0x33
_0x22:
	SBRS R5,1
	RJMP _0x34
; 0000 0147     HIGH_RANGE;
	SBI  0x12,5
	SBI  0x11,5
; 0000 0148   }
; 0000 0149 
; 0000 014A   /* Wait for completion, timing out after HIGH_RANGE_TIMEOUT */
; 0000 014B   i = 0;
_0x34:
_0x33:
	__GETWRN 16,17,0
; 0000 014C   while ((measure_state != STATE_DONE) && (++i < HIGH_RANGE_TIMEOUT)) {
_0x39:
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x3)
	BREQ _0x3C
	MOVW R30,R16
	ADIW R30,1
	MOVW R16,R30
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRLO _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
; 0000 014D     ms_spin(1);
	RCALL SUBOPT_0x5
; 0000 014E 
; 0000 014F     /* This value must be checked in every loop */
; 0000 0150     if (BUTTON_PUSHED)
	SBIC 0x10,2
	RJMP _0x3E
; 0000 0151       return 0;
	RCALL SUBOPT_0x6
	RJMP _0x20E0006
; 0000 0152   }
_0x3E:
	RJMP _0x39
_0x3B:
; 0000 0153 
; 0000 0154   /* Done, discharge cap now */
; 0000 0155   LOW_RANGE;
	CBI  0x11,5
	CBI  0x12,5
; 0000 0156   DISCHARGE_ON;
	SBI  0x11,6
; 0000 0157   LED_OFF;
	SBI  0x12,4
; 0000 0158 
; 0000 0159   if (measure_state != STATE_DONE)
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x3)
	BREQ _0x47
; 0000 015A     rangemode |= RANGE_OVERFLOW;
	LDI  R30,LOW(8)
	OR   R5,R30
; 0000 015B   else
	RJMP _0x48
_0x47:
; 0000 015C     rangemode &= ~RANGE_OVERFLOW;
	LDI  R30,LOW(247)
	AND  R5,R30
; 0000 015D 
; 0000 015E   measure_state = STATE_IDLE;
_0x48:
	LDI  R30,LOW(0)
	STS  _measure_state,R30
; 0000 015F 
; 0000 0160   return ((unsigned long)timer_highword << 16) + TIMER_VALUE;
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
_0x20E0006:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0161 }
; .FEND
;
;void calc_and_show(long value)
; 0000 0164 {
_calc_and_show:
; .FSTART _calc_and_show
; 0000 0165   unsigned char b;
; 0000 0166   unsigned long l;
; 0000 0167 
; 0000 0168   if (rangemode & RANGE_AUTO)
	RCALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
;	value -> Y+5
;	b -> R17
;	l -> Y+1
	SBRS R5,2
	RJMP _0x49
; 0000 0169     lcd_string("Auto ",0);
	__POINTW1MN _0x4A,0
	RJMP _0x79
; 0000 016A   else
_0x49:
; 0000 016B     lcd_string("Force",0);
	__POINTW1MN _0x4A,6
_0x79:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_string
; 0000 016C 
; 0000 016D   if (rangemode & RANGE_HIGH)
	SBRS R5,1
	RJMP _0x4C
; 0000 016E     lcd_string(" high",16);
	__POINTW1MN _0x4A,12
	RJMP _0x7A
; 0000 016F   else
_0x4C:
; 0000 0170     lcd_string(" low ",16);
	__POINTW1MN _0x4A,18
_0x7A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	RCALL _lcd_string
; 0000 0171 
; 0000 0172   if (rangemode & RANGE_OVERFLOW) {
	SBRS R5,3
	RJMP _0x4E
; 0000 0173     /* Todo - this smarter */
; 0000 0174     lcdbuffer[0] = ' ';
	LDI  R30,LOW(32)
	STS  _lcdbuffer,R30
; 0000 0175     lcdbuffer[1] = ' ';
	__PUTB1MN _lcdbuffer,1
; 0000 0176     lcdbuffer[2] = ' ';
	__PUTB1MN _lcdbuffer,2
; 0000 0177     lcdbuffer[3] = 'E';
	LDI  R30,LOW(69)
	__PUTB1MN _lcdbuffer,3
; 0000 0178     lcdbuffer[4] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _lcdbuffer,4
; 0000 0179     lcdbuffer[5] = 'r';
	__PUTB1MN _lcdbuffer,5
; 0000 017A     lcdbuffer[6] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _lcdbuffer,6
; 0000 017B     lcdbuffer[7] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _lcdbuffer,7
; 0000 017C     lcdbuffer[8] = ' ';
	LDI  R30,LOW(32)
	RJMP _0x7B
; 0000 017D     lcdbuffer[9] = 0;
; 0000 017E   }
; 0000 017F   else {
_0x4E:
; 0000 0180     /* Select calibration value */
; 0000 0181     b = rangemode & 3;
	MOV  R30,R5
	ANDI R30,LOW(0x3)
	MOV  R17,R30
; 0000 0182 
; 0000 0183     if (calib_offset[b] > value) {
	RCALL SUBOPT_0x8
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x9
	RCALL __CPD12
	BRSH _0x50
; 0000 0184       lcdbuffer[0] = '-';
	LDI  R30,LOW(45)
	STS  _lcdbuffer,R30
; 0000 0185       value = calib_offset[b] - value;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xA
	RCALL __SUBD12
	__PUTD1S 5
; 0000 0186     }
; 0000 0187     else {
	RJMP _0x51
_0x50:
; 0000 0188       lcdbuffer[0] = ' ';
	LDI  R30,LOW(32)
	STS  _lcdbuffer,R30
; 0000 0189       value = value - calib_offset[b];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xA
	RCALL __SUBD21
	__PUTD2S 5
; 0000 018A     }
_0x51:
; 0000 018B 
; 0000 018C     MUL_LONG_SHORT_S2(value, calib[b], &l);
	RCALL SUBOPT_0x9
	RCALL __PUTPARD1
	MOV  R30,R17
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	MOVW R26,R28
	ADIW R26,7
	RCALL _MUL_LONG_SHORT_S2
; 0000 018D 
; 0000 018E     b = long2ascii(lcdbuffer+1, l);
	__POINTW1MN _lcdbuffer,1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 3
	RCALL _long2ascii
	MOV  R17,R30
; 0000 018F 
; 0000 0190     /* High range shifts 1E3 */
; 0000 0191     if (rangemode & RANGE_HIGH)
	SBRC R5,1
; 0000 0192       b++;
	SUBI R17,-1
; 0000 0193 
; 0000 0194     lcdbuffer[6] = ' ';
	LDI  R30,LOW(32)
	__PUTB1MN _lcdbuffer,6
; 0000 0195     lcdbuffer[7] = decades[b];  /* range = 1 shifts 1E3 */
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_decades)
	SBCI R31,HIGH(-_decades)
	LD   R30,Z
	__PUTB1MN _lcdbuffer,7
; 0000 0196     lcdbuffer[8] = 'F';
	LDI  R30,LOW(70)
_0x7B:
	__PUTB1MN _lcdbuffer,8
; 0000 0197     lcdbuffer[9] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _lcdbuffer,9
; 0000 0198   }
; 0000 0199 
; 0000 019A   /* Write high threshold in first line, low threshold in second */
; 0000 019B   if (rangemode & RANGE_HIGH_THRESH)
	SBRS R5,0
	RJMP _0x53
; 0000 019C     b=7;
	LDI  R17,LOW(7)
; 0000 019D   else
	RJMP _0x54
_0x53:
; 0000 019E     b=23;
	LDI  R17,LOW(23)
; 0000 019F 
; 0000 01A0   lcd_string(lcdbuffer,b);
_0x54:
	LDI  R30,LOW(_lcdbuffer)
	LDI  R31,HIGH(_lcdbuffer)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	RCALL _lcd_string
; 0000 01A1 }
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND

	.DSEG
_0x4A:
	.BYTE 0x18
;
;void calibrate_zero(void)
; 0000 01A4 {

	.CSEG
_calibrate_zero:
; .FSTART _calibrate_zero
; 0000 01A5   char oldrange = rangemode;
; 0000 01A6   unsigned long l;
; 0000 01A7 
; 0000 01A8   rangemode = 0;
	RCALL SUBOPT_0xE
;	oldrange -> R17
;	l -> Y+1
; 0000 01A9 
; 0000 01AA   l = measure();
; 0000 01AB   l = measure();
	RCALL SUBOPT_0xF
; 0000 01AC 
; 0000 01AD   calib_offset[rangemode] = l;
	RCALL SUBOPT_0x10
; 0000 01AE 
; 0000 01AF   rangemode = RANGE_HIGH_THRESH;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x11
; 0000 01B0 
; 0000 01B1   l = measure();
; 0000 01B2   l = measure();
	RCALL SUBOPT_0xF
; 0000 01B3 
; 0000 01B4   calib_offset[rangemode] = l;
	RCALL SUBOPT_0x10
; 0000 01B5 
; 0000 01B6   rangemode = oldrange;
	RJMP _0x20E0005
; 0000 01B7 
; 0000 01B8 }
; .FEND
;
;void calibrate(void)
; 0000 01BB {
_calibrate:
; .FSTART _calibrate
; 0000 01BC   char oldrange = rangemode;
; 0000 01BD   unsigned long value;
; 0000 01BE 
; 0000 01BF   rangemode = 0;
	RCALL SUBOPT_0xE
;	oldrange -> R17
;	value -> Y+1
; 0000 01C0   value = measure();
; 0000 01C1   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x12
; 0000 01C2   calib[rangemode] = CALIB_LOW / (value>>8) + 1;
	RCALL SUBOPT_0x13
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x14
	POP  R26
	POP  R27
	RCALL SUBOPT_0x15
; 0000 01C3 
; 0000 01C4   rangemode = RANGE_HIGH_THRESH;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x11
; 0000 01C5   value = measure();
; 0000 01C6   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x12
; 0000 01C7   calib[rangemode] = CALIB_LOW / (value>>8) + 1;
	RCALL SUBOPT_0x13
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x14
	POP  R26
	POP  R27
	RCALL SUBOPT_0x15
; 0000 01C8 
; 0000 01C9   rangemode = RANGE_HIGH;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x11
; 0000 01CA   value = measure();
; 0000 01CB   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x12
; 0000 01CC   calib[rangemode] = CALIB_HIGH / value + 1;
	RCALL SUBOPT_0x13
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x16
	POP  R26
	POP  R27
	RCALL SUBOPT_0x15
; 0000 01CD 
; 0000 01CE   rangemode = RANGE_HIGH | RANGE_HIGH_THRESH;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x11
; 0000 01CF   value = measure();
; 0000 01D0   value -= calib_offset[rangemode];
	RCALL SUBOPT_0x12
; 0000 01D1   calib[rangemode] = CALIB_HIGH / value + 1;
	RCALL SUBOPT_0x13
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x16
	POP  R26
	POP  R27
	RCALL SUBOPT_0x15
; 0000 01D2 
; 0000 01D3   rangemode = oldrange;
_0x20E0005:
	MOV  R5,R17
; 0000 01D4 
; 0000 01D5 }
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;
;char menu(void)
; 0000 01D8 {
_menu:
; .FSTART _menu
; 0000 01D9   unsigned char i;
; 0000 01DA 
; 0000 01DB   lcd_clear();
	ST   -Y,R17
;	i -> R17
	RCALL _lcd_clear
; 0000 01DC 
; 0000 01DD   for (i=0; i<MENU_ITEMS; i++) {
	LDI  R17,LOW(0)
_0x56:
	CPI  R17,6
	BRSH _0x57
; 0000 01DE     lcd_string(menu_item[i],0);
	RCALL SUBOPT_0x17
	LDI  R26,LOW(0)
	RCALL _lcd_string
; 0000 01DF     ms_spin(MENU_SPEED);
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	RCALL _ms_spin
; 0000 01E0 
; 0000 01E1     if (!BUTTON_PUSHED)
	SBIC 0x10,2
; 0000 01E2       break;
	RJMP _0x57
; 0000 01E3 
; 0000 01E4   }
	SUBI R17,-1
	RJMP _0x56
_0x57:
; 0000 01E5 
; 0000 01E6   if (i == MENU_ITEMS) {
	CPI  R17,6
	BRNE _0x59
; 0000 01E7     /* Just clear display, if user went out of menu */
; 0000 01E8     lcd_clear();
	RCALL _lcd_clear
; 0000 01E9 
; 0000 01EA     /* Wait for release of button */
; 0000 01EB     while (BUTTON_PUSHED);
_0x5A:
	SBIS 0x10,2
	RJMP _0x5A
; 0000 01EC     ms_spin(10);
	LDI  R26,LOW(10)
	RJMP _0x7C
; 0000 01ED 
; 0000 01EE   }
; 0000 01EF   else {
_0x59:
; 0000 01F0     /* Flash selected item */
; 0000 01F1     lcd_clear();
	RCALL _lcd_clear
; 0000 01F2     ms_spin(MENU_SPEED >> 2);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x7
; 0000 01F3     lcd_string(menu_item[i],0);
	RCALL SUBOPT_0x17
	LDI  R26,LOW(0)
	RCALL _lcd_string
; 0000 01F4     ms_spin(MENU_SPEED >> 1);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _ms_spin
; 0000 01F5     lcd_clear();
	RCALL _lcd_clear
; 0000 01F6     ms_spin(MENU_SPEED >> 2);
	LDI  R26,LOW(200)
_0x7C:
	LDI  R27,0
	RCALL _ms_spin
; 0000 01F7 
; 0000 01F8   }
; 0000 01F9 
; 0000 01FA   return i;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 01FB }
; .FEND
;
;/* NOW I NEED TO COMPARE THE CODEWIZARD CODE WITH THE INIT FUNCTION */
;
;
;// SPI functions
;#include <spi.h>
;
;void main(void)
; 0000 0204 {
_main:
; .FSTART _main
; 0000 0205 unsigned long l;
; 0000 0206 // Declare your local variables here
; 0000 0207 
; 0000 0208 // Input/Output Ports initialization
; 0000 0209 // Port B initialization
; 0000 020A // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 020B DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	SBIW R28,4
;	l -> Y+0
	LDI  R30,LOW(44)
	OUT  0x17,R30
; 0000 020C // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 020D PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 020E 
; 0000 020F // Port C initialization
; 0000 0210 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0211 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0212 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0213 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0214 
; 0000 0215 // Port D initialization
; 0000 0216 // Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0217 DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(112)
	OUT  0x11,R30
; 0000 0218 // State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0219 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 021A 
; 0000 021B // Timer/Counter 0 initialization
; 0000 021C // Clock source: System Clock
; 0000 021D // Clock value: Timer 0 Stopped
; 0000 021E TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 021F TCNT0=0x00;
	OUT  0x32,R30
; 0000 0220 
; 0000 0221 // Timer/Counter 1 initialization
; 0000 0222 // Clock source: System Clock
; 0000 0223 // Clock value: Timer1 Stopped
; 0000 0224 // Mode: Normal top=0xFFFF
; 0000 0225 // OC1A output: Disconnected
; 0000 0226 // OC1B output: Disconnected
; 0000 0227 // Noise Canceler: Off
; 0000 0228 // Input Capture on Falling Edge
; 0000 0229 // Timer1 Overflow Interrupt: On
; 0000 022A // Input Capture Interrupt: Off
; 0000 022B // Compare A Match Interrupt: Off
; 0000 022C // Compare B Match Interrupt: Off
; 0000 022D TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 022E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 022F TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0230 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0231 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0232 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0233 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0234 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0235 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0236 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0237 
; 0000 0238 // Timer/Counter 2 initialization
; 0000 0239 // Clock source: System Clock
; 0000 023A // Clock value: Timer2 Stopped
; 0000 023B // Mode: Normal top=0xFF
; 0000 023C // OC2 output: Disconnected
; 0000 023D ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 023E TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 023F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0240 OCR2=0x00;
	OUT  0x23,R30
; 0000 0241 
; 0000 0242 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0243 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0244 
; 0000 0245 // External Interrupt(s) initialization
; 0000 0246 // INT0: Off
; 0000 0247 // INT1: Off
; 0000 0248 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0249 
; 0000 024A // USART initialization
; 0000 024B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 024C // USART Receiver: On
; 0000 024D // USART Transmitter: On
; 0000 024E // USART Mode: Asynchronous
; 0000 024F // USART Baud Rate: 9600
; 0000 0250 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0251 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0252 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0253 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0254 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0255 
; 0000 0256 // Analog Comparator initialization
; 0000 0257 // Analog Comparator: On
; 0000 0258 // The Analog Comparator's positive input is
; 0000 0259 // connected to the AIN0 pin
; 0000 025A // The Analog Comparator's negative input is
; 0000 025B // connected to the AIN1 pin
; 0000 025C // Interrupt on Rising Output Edge
; 0000 025D // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 025E ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
	LDI  R30,LOW(11)
	OUT  0x8,R30
; 0000 025F SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0260 
; 0000 0261 // ADC initialization
; 0000 0262 // ADC disabled
; 0000 0263 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0264 
; 0000 0265 // SPI initialization
; 0000 0266 // SPI Type: Master
; 0000 0267 // SPI Clock Rate: 2000.000 kHz
; 0000 0268 // SPI Clock Phase: Cycle Start
; 0000 0269 // SPI Clock Polarity: Low
; 0000 026A // SPI Data Order: MSB First
; 0000 026B SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 026C SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 026D 
; 0000 026E // TWI initialization
; 0000 026F // TWI disabled
; 0000 0270 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0271 
; 0000 0272 // Global enable interrupts
; 0000 0273 #asm("sei")
	sei
; 0000 0274 
; 0000 0275 /*REAL STUFF BEGINS*/
; 0000 0276 
; 0000 0277 lcd_init();
	RCALL _lcd_init
; 0000 0278 
; 0000 0279 eeprom_read();
	RCALL _eeprom_read
; 0000 027A 
; 0000 027B LED_OFF; //turns off an LED (probably an indicator for measurement status).
	SBI  0x12,4
; 0000 027C 
; 0000 027D rangemode = RANGE_AUTO;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 027E 
; 0000 027F while (1) {
_0x60:
; 0000 0280       /* Toggle high/low threshold */
; 0000 0281       rangemode ^= RANGE_HIGH_THRESH;
	LDI  R30,LOW(1)
	EOR  R5,R30
; 0000 0282       l = measure();
	RCALL _measure
	RCALL __PUTD1S0
; 0000 0283       if (BUTTON_PUSHED) {
	SBIC 0x10,2
	RJMP _0x63
; 0000 0284         /* Stop any cap. charging */
; 0000 0285         LED_OFF;
	SBI  0x12,4
; 0000 0286         LOW_RANGE;
	CBI  0x11,5
	CBI  0x12,5
; 0000 0287         DISCHARGE_ON;
	SBI  0x11,6
; 0000 0288 
; 0000 0289         /* Menu implementation */
; 0000 028A         switch(menu()) {
	RCALL _menu
; 0000 028B         case 0: /* auto range */
	CPI  R30,0
	BRNE _0x6F
; 0000 028C           rangemode |= RANGE_AUTO;
	LDI  R30,LOW(4)
	OR   R5,R30
; 0000 028D           break;
	RJMP _0x6E
; 0000 028E         case 1: /* low range */
_0x6F:
	CPI  R30,LOW(0x1)
	BRNE _0x70
; 0000 028F           rangemode &= ~(RANGE_AUTO | RANGE_HIGH);
	LDI  R30,LOW(249)
	AND  R5,R30
; 0000 0290           break;
	RJMP _0x6E
; 0000 0291         case 2: /* high range */
_0x70:
	CPI  R30,LOW(0x2)
	BRNE _0x71
; 0000 0292           rangemode &= ~RANGE_AUTO;
	LDI  R30,LOW(251)
	AND  R5,R30
; 0000 0293           rangemode |= RANGE_HIGH;
	LDI  R30,LOW(2)
	OR   R5,R30
; 0000 0294           break;
	RJMP _0x6E
; 0000 0295         case 3:
_0x71:
	CPI  R30,LOW(0x3)
	BRNE _0x72
; 0000 0296           calibrate_zero();
	RCALL _calibrate_zero
; 0000 0297           break;
	RJMP _0x6E
; 0000 0298         case 4:
_0x72:
	CPI  R30,LOW(0x4)
	BRNE _0x73
; 0000 0299           calibrate();
	RCALL _calibrate
; 0000 029A           break;
	RJMP _0x6E
; 0000 029B         case 5:
_0x73:
	CPI  R30,LOW(0x5)
	BRNE _0x6E
; 0000 029C           eeprom_write();
	RCALL _eeprom_write
; 0000 029D           break;
; 0000 029E         }
_0x6E:
; 0000 029F 
; 0000 02A0       }
; 0000 02A1       else
	RJMP _0x75
_0x63:
; 0000 02A2         calc_and_show(l);
	RCALL __GETD2S0
	RCALL _calc_and_show
; 0000 02A3     }
_0x75:
	RJMP _0x60
; 0000 02A4 }
_0x76:
	RJMP _0x76
; .FEND
;//
;// Title        : LCD driver and other stuff
;// Author       : Lars Pontoppidan Larsen
;// Date         : Jan 2006
;// Version      : 1.00
;// Target MCU   : Atmel AVR Series
;//
;// DESCRIPTION:
;// This module implements sending chars and strings to a HD44780 compatible LCD,
;// and various other helpfull functions are present.
;//
;// Display initialization:
;//   void lcd_init()
;//
;// Sending a zero-terminated string (from s-ram) at pos (0-31):
;//   void lcd_string(char *p, unsigned char pos);
;//
;// Clear display:
;//   void lcd_clear(void);
;//
;// OTHER STUFF:
;//   void ms_spin(unsigned short ms);
;//   void hex2ascii(char *target, long value, char pointplace);
;//   char long2ascii(char *target, unsigned long value);
;//
;// DISCLAIMER:
;// The author is in no way responsible for any problems or damage caused by
;// using this code. Use at your own risk.
;//
;// LICENSE:
;// This code is distributed under the GNU Public License
;// which can be found at http://www.gnu.org/licenses/gpl.txt
;//
;
;
;#include <io.h>
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
;#include <stdlib.h>
;//#include <util/delay.h>
;
;
;#include "lcd.h"
;
;
;#define DISP_ON      0x0C //0b00001100  //LCD control constants
;#define DISP_OFF     0x08 //0b00001000  //
;#define CLR_DISP     0x01 //0b00000001  //
;#define CUR_HOME     0x02 //0b00000010  //
;#define DD_RAM_ADDR  0x80 //0b10000000  //
;#define DD_RAM_ADDR2 0xC0 //0b11000000  //
;#define DD_RAM_ADDR3 0x28 //40    //
;#define CG_RAM_ADDR  0x40 //0b01000000  //
;
;
;/* Use these defines to specify lcd port and RS, EN pin */
;#define PORT PORTB
;#define DDR DDRB
;
;#define RS_BIT 5
;#define EN_BIT 4
;
;#define F_CPU 8000000UL  // Change to your actual clock speed
;
;/* DELAY FUNCTIONS */
;
;#define LOOPS_PER_MS (F_CPU/1000/4)
;
;/* spin for ms milliseconds */
;void ms_spin(unsigned short ms)
; 0001 0046 {

	.CSEG
_ms_spin:
; .FSTART _ms_spin
; 0001 0047     unsigned short outer, inner;
; 0001 0048 
; 0001 0049     for (outer = 0; outer < ms; outer++)
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR4
;	ms -> Y+4
;	outer -> R16,R17
;	inner -> R18,R19
	__GETWRN 16,17,0
_0x20004:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x20005
; 0001 004A     {
; 0001 004B         inner = LOOPS_PER_MS;
	__GETWRN 18,19,2000
; 0001 004C         while (inner--)
_0x20006:
	MOVW R30,R18
	__SUBWRN 18,19,1
	SBIW R30,0
	BREQ _0x20008
; 0001 004D         {
; 0001 004E             #asm
; 0001 004F                 nop
                nop
; 0001 0050             #endasm
; 0001 0051         }
	RJMP _0x20006
_0x20008:
; 0001 0052     }
	__ADDWRN 16,17,1
	RJMP _0x20004
_0x20005:
; 0001 0053 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;
;
;/* 8-bit count, 3 cycles/loop */
;/*static inline void
;_delay_loop_1(unsigned char __count)
;{
;        if (!__count)
;                return;
;
;        asm volatile (
;                "1: dec %0" "\n\t"
;                "brne 1b"
;                : "=r" (__count)
;                : "0" (__count)
;        );
;}   */
;
;void _delay_loop_1(unsigned char __count)
; 0001 0067 {
__delay_loop_1:
; .FSTART __delay_loop_1
; 0001 0068     if (!__count)
	ST   -Y,R26
;	__count -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20E0004
; 0001 0069         return;
; 0001 006A 
; 0001 006B     do {
_0x2000B:
; 0001 006C         #asm
; 0001 006D             nop
            nop
; 0001 006E         #endasm
; 0001 006F     } while (--__count);
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	BRNE _0x2000B
; 0001 0070 }
_0x20E0004:
	ADIW R28,1
	RET
; .FEND
;
;
;
;
;void lcd_putchar(unsigned char rs, unsigned char data )
; 0001 0076 {
_lcd_putchar:
; .FSTART _lcd_putchar
; 0001 0077   // must set LCD-mode before calling this function!
; 0001 0078   // RS = 1 LCD in character-mode
; 0001 0079   // RS = 0 LCD in command-mode
; 0001 007A 
; 0001 007B   if (rs)
	ST   -Y,R26
;	rs -> Y+1
;	data -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000D
; 0001 007C     rs = (1<<RS_BIT);
	LDI  R30,LOW(32)
	STD  Y+1,R30
; 0001 007D 
; 0001 007E   /* High nibble, rsbit and EN low */
; 0001 007F   PORT = (0x0F & (data >> 4)) | rs ;
_0x2000D:
	LD   R30,Y
	SWAP R30
	RCALL SUBOPT_0x18
; 0001 0080 
; 0001 0081   /* Clock cyclus */
; 0001 0082   PORT |= (1<<EN_BIT);
; 0001 0083   _delay_loop_1(5);
; 0001 0084   PORT &= ~(1<<EN_BIT);
; 0001 0085 
; 0001 0086   /* Wait a little */
; 0001 0087   ms_spin(2);
; 0001 0088 
; 0001 0089   /* Low nibble, rsbit and EN low*/
; 0001 008A   PORT = (data & 0x0F) | rs;
	LD   R30,Y
	RCALL SUBOPT_0x18
; 0001 008B 
; 0001 008C   /* Clock cyclus */
; 0001 008D   PORT |= (1<<EN_BIT);
; 0001 008E   _delay_loop_1(5);
; 0001 008F   PORT &= ~(1<<EN_BIT);
; 0001 0090 
; 0001 0091   /* Wait a little */
; 0001 0092   ms_spin(2);
; 0001 0093 }
	ADIW R28,2
	RET
; .FEND
;
;
;void lcd_init( void ) // must be run once before using the display
; 0001 0097 {
_lcd_init:
; .FSTART _lcd_init
; 0001 0098   /* Set ddr all out */
; 0001 0099   PORT = 0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0001 009A   DDR = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0001 009B 
; 0001 009C   /* Power on wait */
; 0001 009D   ms_spin(50);
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x7
; 0001 009E 
; 0001 009F   /* Configure 4 bit access */
; 0001 00A0   lcd_putchar(0, 0x33);
	RCALL SUBOPT_0x19
	LDI  R26,LOW(51)
	RCALL SUBOPT_0x1A
; 0001 00A1   lcd_putchar(0, 0x32);
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x1A
; 0001 00A2 
; 0001 00A3   /* Setup lcd */
; 0001 00A4   lcd_putchar(0, 0x28);
	LDI  R26,LOW(40)
	RCALL SUBOPT_0x1A
; 0001 00A5   lcd_putchar(0, 0x08);
	LDI  R26,LOW(8)
	RCALL SUBOPT_0x1A
; 0001 00A6   lcd_putchar(0, 0x0c);
	LDI  R26,LOW(12)
	RCALL SUBOPT_0x1A
; 0001 00A7   lcd_putchar(0, 0x01);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1A
; 0001 00A8   lcd_putchar(0, 0x06);
	LDI  R26,LOW(6)
	RJMP _0x20E0003
; 0001 00A9 }
; .FEND
;
;void lcd_clear(void)
; 0001 00AC {
_lcd_clear:
; .FSTART _lcd_clear
; 0001 00AD   /* Display clear  */
; 0001 00AE   lcd_putchar(0, CLR_DISP);
	RCALL SUBOPT_0x19
	LDI  R26,LOW(1)
_0x20E0003:
	RCALL _lcd_putchar
; 0001 00AF 
; 0001 00B0 }
	RET
; .FEND
;
;void lcd_string(char *p, unsigned char pos)
; 0001 00B3 {
_lcd_string:
; .FSTART _lcd_string
; 0001 00B4 
; 0001 00B5     // place cursor
; 0001 00B6     if (pos < 16) {
	ST   -Y,R26
;	*p -> Y+1
;	pos -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x10)
	BRSH _0x2000E
; 0001 00B7       lcd_putchar(0, DD_RAM_ADDR + pos);
	RCALL SUBOPT_0x19
	LDD  R26,Y+1
	SUBI R26,-LOW(128)
	RCALL _lcd_putchar
; 0001 00B8     }
; 0001 00B9     else if (pos < 32) {
	RJMP _0x2000F
_0x2000E:
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x20010
; 0001 00BA         lcd_putchar(0, DD_RAM_ADDR2 + (pos-16));
	RCALL SUBOPT_0x19
	LDD  R26,Y+1
	SUBI R26,-LOW(176)
	RCALL _lcd_putchar
; 0001 00BB     }
; 0001 00BC     else
	RJMP _0x20011
_0x20010:
; 0001 00BD        return;
	RJMP _0x20E0002
; 0001 00BE 
; 0001 00BF     // Write text
; 0001 00C0     while (*p) {
_0x20011:
_0x2000F:
_0x20012:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x20014
; 0001 00C1       if (pos > 31)
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x20014
; 0001 00C2         break;
; 0001 00C3 
; 0001 00C4       lcd_putchar(1, *(p++));
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	MOV  R26,R30
	RCALL _lcd_putchar
; 0001 00C5 
; 0001 00C6       if (++pos == 16)
	LD   R26,Y
	SUBI R26,-LOW(1)
	ST   Y,R26
	CPI  R26,LOW(0x10)
	BRNE _0x20016
; 0001 00C7         lcd_putchar(0, DD_RAM_ADDR2);
	RCALL SUBOPT_0x19
	LDI  R26,LOW(192)
	RCALL _lcd_putchar
; 0001 00C8 
; 0001 00C9     }
_0x20016:
	RJMP _0x20012
_0x20014:
; 0001 00CA }
_0x20E0002:
	ADIW R28,3
	RET
; .FEND
;
;/* String functions */
;
;/*
;   Writes value as hexadecimals in target. 9 characters will be written.
;   pointplace puts a point in the number, example:
;
;   0123.4567  (pointplace = 2)
;   89ABCD.EF  (pointplace = 1)
;*/
;
;
;unsigned char swap_nibbles(unsigned char x)
; 0001 00D8 {
; 0001 00D9     #asm
;	x -> Y+0
; 0001 00DA         mov r16, x
; 0001 00DB         swap r16
; 0001 00DC         mov x, r16
; 0001 00DD     #endasm
; 0001 00DE     return x;
; 0001 00DF }
;
;
;void hex2ascii(char *target, long value, char pointplace)
; 0001 00E3 {
; 0001 00E4    int i;
; 0001 00E5    unsigned char hex;
; 0001 00E6 
; 0001 00E7    for (i=3; i>=0; i--) {
;	*target -> Y+9
;	value -> Y+5
;	pointplace -> Y+4
;	i -> R16,R17
;	hex -> R19
; 0001 00E8 
; 0001 00E9      hex = value>>24;   /* Get msbyte */
; 0001 00EA     hex = swap_nibbles(hex); /* Get high nibble */
; 0001 00EB      hex &= 0x0F;
; 0001 00EC 
; 0001 00ED      *(target++) = ((hex < 0x0A) ? (hex + '0') : (hex + ('A' - 0x0A)));
; 0001 00EE 
; 0001 00EF      hex = value>>24;   /* Get msbyte */
; 0001 00F0      hex &= 0x0F;       /* Get low nibble */
; 0001 00F1 
; 0001 00F2      *(target++) = ((hex < 0x0A) ? (hex + '0') : (hex + ('A' - 0x0A)));
; 0001 00F3 
; 0001 00F4      value <<= 8;
; 0001 00F5 
; 0001 00F6      if (i == pointplace)
; 0001 00F7        *(target++) = '.';
; 0001 00F8 
; 0001 00F9    }
; 0001 00FA 
; 0001 00FB 
; 0001 00FC }
;
;
;// /*
;//    Writes a unsigned long as 13 ascii decimals:
;//
;//    x.xxx.xxx.xxx
;// */
;
;// unsigned long tenths_tab[10] = {1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1};
;// void long2ascii(char *target, unsigned long value)
;// {
;//    unsigned char p, pos=0;
;//    unsigned char numbernow=0;
;//
;//    for (p=0;p<10;p++) {
;//
;//      if ((p==1) || (p==4) || (p==7)) {
;//        if (numbernow)
;//          target[pos] = '.';
;//        else
;//          target[pos] = ' ';
;//
;//        pos++;
;//      }
;//
;//      if (value < tenths_tab[p]) {
;//        if (numbernow)
;//          target[pos] = '0';
;//        else
;//          target[pos] = ' ';
;//      }
;//      else {
;//        target[pos] = '0';
;//        while (value >= tenths_tab[p]) {
;//          target[pos]++;
;//          value -= tenths_tab[p];
;//        }
;//        numbernow = 1;
;//     }
;//     pos++;
;//   }
;//
;// }
;
;/*
;   Writes a unsigned long as 4 ascii decimals + a dot. Always writes 5 ascii chars.
;   Returns dot place.
;
;   examples:      returns:
;  "a.aaa"         3
;    "aaa.a"       2
;     "aa.aa"      2
;          "a.aaa" 1
;          "  aaa" 0
;          "    a" 0
;   x.xxx.xxx.xxx
;*/
;
;unsigned long tenths_tab[10] = {1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1};

	.DSEG
;char long2ascii(char *target, unsigned long value)
; 0001 0139 {

	.CSEG
_long2ascii:
; .FSTART _long2ascii
; 0001 013A   unsigned char p, pos=0;
; 0001 013B   unsigned char numbernow=0;
; 0001 013C   char ret=0;
; 0001 013D 
; 0001 013E   for (p=0;(p<10) && (pos<5);p++) {
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
_0x20023:
	CPI  R17,10
	BRSH _0x20025
	CPI  R16,5
	BRLO _0x20026
_0x20025:
	RJMP _0x20024
_0x20026:
; 0001 013F 
; 0001 0140     if (numbernow) {
	CPI  R19,0
	BREQ _0x20027
; 0001 0141       /* Eventually place dot */
; 0001 0142       /* Notice the nice fallthrough construction. */
; 0001 0143       switch(p) {
	MOV  R30,R17
	LDI  R31,0
; 0001 0144       case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2002B
; 0001 0145         ret++;
	SUBI R18,-1
; 0001 0146       case 4:
	RJMP _0x2002C
_0x2002B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2002D
_0x2002C:
; 0001 0147         ret++;
	SUBI R18,-1
; 0001 0148       case 7:
	RJMP _0x2002E
_0x2002D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2002A
_0x2002E:
; 0001 0149         ret++;
	SUBI R18,-1
; 0001 014A         target[pos] = '.';
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(46)
	ST   X,R30
; 0001 014B         pos++;
	SUBI R16,-1
; 0001 014C       }
_0x2002A:
; 0001 014D     }
; 0001 014E 
; 0001 014F     if (value < tenths_tab[p]) {
_0x20027:
	RCALL SUBOPT_0x1C
	BRSH _0x20030
; 0001 0150       if (numbernow) {
	CPI  R19,0
	BREQ _0x20031
; 0001 0151         /* Inside number, put a zero */
; 0001 0152         target[pos] = '0';
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(48)
	RJMP _0x20039
; 0001 0153         pos++;
; 0001 0154       }
; 0001 0155       else {
_0x20031:
; 0001 0156         /* Check if we need to pad with spaces */
; 0001 0157         if (p>=6) {
	CPI  R17,6
	BRLO _0x20033
; 0001 0158           target[pos] = ' ';
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(32)
	ST   X,R30
; 0001 0159           pos++;
	SUBI R16,-1
; 0001 015A         }
; 0001 015B 
; 0001 015C         if (p==6) {
_0x20033:
	CPI  R17,6
	BRNE _0x20034
; 0001 015D           /* We also need to place a space instead of . */
; 0001 015E           target[pos] = ' ';
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(32)
_0x20039:
	ST   X,R30
; 0001 015F           pos++;
	SUBI R16,-1
; 0001 0160         }
; 0001 0161       }
_0x20034:
; 0001 0162     }
; 0001 0163     else {
	RJMP _0x20035
_0x20030:
; 0001 0164       target[pos] = '0';
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(48)
	ST   X,R30
; 0001 0165       while (value >= tenths_tab[p]) {
_0x20036:
	RCALL SUBOPT_0x1C
	BRLO _0x20038
; 0001 0166         target[pos]++;
	RCALL SUBOPT_0x1B
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0001 0167         value -= tenths_tab[p];
	MOV  R30,R17
	LDI  R26,LOW(_tenths_tab)
	LDI  R27,HIGH(_tenths_tab)
	LDI  R31,0
	RCALL __LSLW2
	RCALL SUBOPT_0xC
	RCALL __GETD1P
	__GETD2S 4
	RCALL __SUBD21
	__PUTD2S 4
; 0001 0168       }
	RJMP _0x20036
_0x20038:
; 0001 0169       pos++;
	SUBI R16,-1
; 0001 016A       numbernow = 1;
	LDI  R19,LOW(1)
; 0001 016B     }
_0x20035:
; 0001 016C   }
	SUBI R17,-1
	RJMP _0x20023
_0x20024:
; 0001 016D 
; 0001 016E   return ret;
	MOV  R30,R18
	RJMP _0x20E0001
; 0001 016F }
; .FEND
;

	.CSEG
_eeprom_read_block:
; .FSTART _eeprom_read_block
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR4
	__GETWRS 16,17,8
	__GETWRS 18,19,6
_0x2000003:
	RCALL SUBOPT_0x1D
	BREQ _0x2000005
	PUSH R17
	PUSH R16
	RCALL SUBOPT_0x1E
	RCALL __EEPROMRDB
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x2000003
_0x2000005:
	RJMP _0x20E0001
; .FEND
_eeprom_write_block:
; .FSTART _eeprom_write_block
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR4
	__GETWRS 16,17,6
	__GETWRS 18,19,8
_0x2000006:
	RCALL SUBOPT_0x1D
	BREQ _0x2000008
	PUSH R17
	PUSH R16
	RCALL SUBOPT_0x1E
	LD   R30,X
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RJMP _0x2000006
_0x2000008:
_0x20E0001:
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

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_decades:
	.BYTE 0x5
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
_tenths_tab:
	.BYTE 0x28
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	RCALL __CWD1
	RCALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDS  R26,_measure_state
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
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
SUBOPT_0x4:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _ms_spin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R27,0
	RJMP _ms_spin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R26,LOW(_calib_offset)
	LDI  R27,HIGH(_calib_offset)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_calib)
	LDI  R27,HIGH(_calib)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	SBIW R28,4
	ST   -Y,R17
	MOV  R17,R5
	CLR  R5
	RCALL _measure
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xF:
	RCALL _measure
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
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
SUBOPT_0x11:
	MOV  R5,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x12:
	MOV  R30,R5
	LDI  R26,LOW(_calib_offset)
	LDI  R27,HIGH(_calib_offset)
	LDI  R31,0
	RCALL __LSLW2
	RCALL SUBOPT_0xC
	RCALL __GETD1P
	__GETD2S 1
	RCALL __SUBD21
	__PUTD2S 1
	MOV  R30,R5
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	__GETD2S 1
	LDI  R30,LOW(8)
	RCALL __LSRD12
	__GETD2N 0xF424000
	RCALL __DIVD21U
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	__GETD1S 1
	__GETD2N 0x3E80000
	RCALL __DIVD21U
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	MOV  R30,R17
	LDI  R26,LOW(_menu_item)
	LDI  R27,HIGH(_menu_item)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0xC
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	ANDI R30,LOW(0xF)
	LDD  R26,Y+1
	OR   R30,R26
	OUT  0x18,R30
	SBI  0x18,4
	LDI  R26,LOW(5)
	RCALL __delay_loop_1
	CBI  0x18,4
	LDI  R26,LOW(2)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	RCALL _lcd_putchar
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	MOV  R30,R17
	LDI  R26,LOW(_tenths_tab)
	LDI  R27,HIGH(_tenths_tab)
	LDI  R31,0
	RCALL __LSLW2
	RCALL SUBOPT_0xC
	RCALL __GETD1P
	__GETD2S 4
	RCALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	RET


	.CSEG
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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
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

__ASRD16:
	MOV  R30,R22
	MOV  R31,R23
	CLR  R22
	SBRC R31,7
	SER  R22
	MOV  R23,R22
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
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
