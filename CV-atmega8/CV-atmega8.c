/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/21/2025
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega8.h>
#include <delay.h>
#include <eeprom.h>
//#pragma data:code 
#include "lcd.h"

// Declare your global variables here

/* Hardware IO abstraction macros */
 
/* AIN0 out also discharges cap */
#define DISCHARGE_ON  DDRD.6 = 1
#define DISCHARGE_OFF DDRD.6 = 0

/* Range control */
#define HIGH_RANGE PORTD.5 = 1; DDRD.5 = 1
#define LOW_RANGE  DDRD.5 = 0; PORTD.5 = 0

#define PULLDOWN_RANGE PORTD &= ~(1<<5); DDRD |= (1<<5)

/* Threshold selection */
#define ADMUX_LOW 1
#define ADMUX_MEDIUM 2
#define ADMUX_HIGH 3
 
/* Timer abstraction */
#define TIMER_VALUE TCNT1
#define TIMER_START TCCR1B = (1<<CS10)
#define TIMER_STOP  TCCR1B = 0

/* Led abstraction */
#define LED_ON  PORTD.4 = 0
#define LED_OFF PORTD.4 = 1

/* Button abstraction */
#define BUTTON_PUSHED (!PIND.2)

char decades[5] = {'p','n','u','m',' '};
char lcdbuffer[32];
unsigned short volatile timer_highword;


/* Program states: */
#define STATE_IDLE 0
#define STATE_LOW_THRESH 1
#define STATE_HIGH_THRESH 2
#define STATE_DONE 3
//#define STATE_BUTTONDOWN 4


unsigned char volatile measure_state;

/* The following is the value the analog compare interrupt will set ADMUX: */
unsigned char volatile set_admux;

/* The rangemode defines the measurement operation */
#define RANGE_HIGH_THRESH 1   /* If missing: threshold low */
#define RANGE_HIGH 2          /* If missing: range low */
#define RANGE_AUTO 4
#define RANGE_OVERFLOW 8      /* If set: cap was out of range */
unsigned char rangemode = RANGE_AUTO;


/* Constants defining measuring operation: */
#define EXTRA_DISCHARGE_MS 100     /* Extra discharging that is done even after a threshold is crossed */
#define LOW_RANGE_TIMEOUT 500     /* At autorange, when to go to high range */
#define HIGH_RANGE_TIMEOUT 10000  /* When to give up completely */


/* Menu system */
#define MENU_SPEED 800 /* ms each menu item is shown */

#define MENU_ITEMS 6
char *menu_item[MENU_ITEMS] = {"Range: Auto","Range: Low ","Range: High","Calibrate: Zero","Calibrate: 1 uF","Save calibration"};


#define CALIB_LOW 256000000    /* for 1uF reference prescale: >> 8 */
#define CALIB_HIGH 65536000    /* for 1uF reference */

#define EEPROM_HEADER 1
#define EEPROM_DATA 3

   
unsigned short calib[4] = {21430, 9308, 19423, 8437};
//unsigned short calib[4] = {53575, 46540, 19423, 8437};

unsigned long calib_offset[4] = {0,0,0,0};

#define SIZE_OF_CALIB 8
#define SIZE_OF_CALIBOFFSET 16

  /* This macro fractionally multiplies 16.16 bit with 0.16 bit both unsigned, 
     shifting the result two bytes right and returning 16.16 bit.
   
   Result is 16.16 bit unsigned */
	
// Temporary globals to bridge C to asm
unsigned int gx, gy;
unsigned long gresult;

// void MUL_LONG_SHORT_S2(unsigned int x, unsigned int y, unsigned long *result)
// {
//     gx = x;
//     gy = y;

//     #asm
//         lds r24, _gx
//         lds r25, 
//         lds r22, _gy
//         lds r23, _gy+1

//         clr r18
//         clr r19
//         clr r20
//         clr r21

//         ; mul x_low * y_low
//         mul r24, r22
//         mov r21, r1
//         clr r1

//         ; mul x_low * y_high
//         mul r24, r23
//         add r21, r0
//         adc r20, r1
//         adc r19, r18
//         clr r1

//         ; mul x_high * y_low
//         mul r25, r22
//         add r21, r0
//         adc r20, r1
//         adc r19, r18
//         clr r1

//         ; mul x_high * y_high
//         mul r25, r23
//         add r20, r0
//         adc r19, r1
//         adc r18, r18
//         clr r1

//         ; store into gresult
//         sts _gresult, r21
//         sts _gresult+1, r20
//         sts _gresult+2, r19
//         sts _gresult+3, r18
//     #endasm

//       *result = gresult;
//   }

#define MUL_LONG_SHORT_S2(x, y, result_ptr) \
    *(result_ptr) = (unsigned long)(x) * (unsigned short)(y);

// Standard Input/Output functions
#include <stdio.h>

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
      timer_highword++;

}

      // Analog Comparator interrupt service routine
      interrupt [ANA_COMP] void ana_comp_isr(void)
      {
      // Place your code here
      if (measure_state == STATE_LOW_THRESH) {
            /* We just got low threshold interrupt, start timer and set high threshold */
            TIMER_START;
            ADMUX = set_admux;
            measure_state = STATE_HIGH_THRESH;
          }
          else if(measure_state == STATE_HIGH_THRESH) {
            /* High threshold interrupt, verify it, then stop timer */
            if (ACSR & (1<<ACO)) {
              TIMER_STOP;
              measure_state = STATE_DONE;
            }
          }

      }



// make sure elnext 2 functions will work 3shan momken ye3melo moshkela bsabab ellibrary
void eeprom_read(void)
{
  if (eeprom_read_byte((void*)EEPROM_HEADER) != 'C')
    return;
    
  if (eeprom_read_byte((unsigned char*)(EEPROM_HEADER + 1)) != 'D')
    return;

  
  eeprom_read_block(calib_offset, (eeprom void*)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
  eeprom_read_block(calib, (eeprom char*)EEPROM_DATA + SIZE_OF_CALIBOFFSET, SIZE_OF_CALIB);
  
}

void eeprom_write(void)
{
  eeprom_write_byte((void*)EEPROM_HEADER, 'C');
  eeprom_write_byte((eeprom char*)EEPROM_HEADER+1, 'D');
  
  eeprom_write_block(calib_offset, (eeprom void*)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
  eeprom_write_block(calib, (eeprom void*)(EEPROM_DATA + SIZE_OF_CALIBOFFSET), SIZE_OF_CALIB);

}

//

long measure(void)
{
  unsigned short i;
  
  measure_state = STATE_IDLE;
  
  /* Discharge cap until below low threshold + some extra */
  ADMUX = ADMUX_LOW;
  PULLDOWN_RANGE;      /* Use range signal as pull down */
  
  while(1) {
    /* Enable comperator and check value */
    DISCHARGE_OFF;
    ms_spin(1);
    
    /* This value must be checked in every loop */
    if (BUTTON_PUSHED)
      return 0;
      
    if (!(ACSR & (1<<ACO)))
      break;
    
    /* Discharge for a while */
    DISCHARGE_ON;
    ms_spin(10);
    
    
  } 
  
  DISCHARGE_ON;
  ms_spin(EXTRA_DISCHARGE_MS);
  
  /* Prepare: reset timer, low range */
  TIMER_STOP;
  TIMER_VALUE = 0;
  timer_highword = 0;

  LOW_RANGE;

  measure_state = STATE_LOW_THRESH;
  
  /* High or medium threshold */
  if (rangemode & RANGE_HIGH_THRESH)
    set_admux = ADMUX_HIGH;
  else
    set_admux = ADMUX_MEDIUM;
  
  /* Apply step */
  LED_ON;
  DISCHARGE_OFF;
  
  if (rangemode & RANGE_AUTO) {
  
    /* Autorange: See if low range produces something before LOW_RANGE_TIMEOUT ms */
    i = 0;
    while ((measure_state == STATE_LOW_THRESH) && (++i < LOW_RANGE_TIMEOUT)) {
      ms_spin(1);
      
      /* This value must be checked in every loop */
      if (BUTTON_PUSHED)
        return 0;
    }
    
    if (i >= LOW_RANGE_TIMEOUT) {
      /* low range timeout, go to high range (better discharge a little first) */
      DISCHARGE_ON;
      ms_spin(EXTRA_DISCHARGE_MS); 
      DISCHARGE_OFF;
      HIGH_RANGE;
      rangemode |= RANGE_HIGH;
    }
    else {
      /* low range was ok, set flag accordingly */
      rangemode &= ~RANGE_HIGH;
    }
  }
  else if (rangemode & RANGE_HIGH) {
    HIGH_RANGE;
  }
  
  /* Wait for completion, timing out after HIGH_RANGE_TIMEOUT */
  i = 0;
  while ((measure_state != STATE_DONE) && (++i < HIGH_RANGE_TIMEOUT)) {
    ms_spin(1);
    
    /* This value must be checked in every loop */
    if (BUTTON_PUSHED)
      return 0;
  }
  
  /* Done, discharge cap now */
  LOW_RANGE;
  DISCHARGE_ON;
  LED_OFF;
  
  if (measure_state != STATE_DONE)
    rangemode |= RANGE_OVERFLOW;
  else
    rangemode &= ~RANGE_OVERFLOW;
    
  measure_state = STATE_IDLE;
  
  return ((unsigned long)timer_highword << 16) + TIMER_VALUE;
}

void calc_and_show(long value)
{
  unsigned char b;
  unsigned long l;
  
  if (rangemode & RANGE_AUTO)
    lcd_string("Auto ",0);
  else
    lcd_string("Force",0);

  if (rangemode & RANGE_HIGH) 
    lcd_string(" high",16);
  else
    lcd_string(" low ",16);
  
  if (rangemode & RANGE_OVERFLOW) {
    /* Todo - this smarter */
    lcdbuffer[0] = ' ';
    lcdbuffer[1] = ' ';
    lcdbuffer[2] = ' ';
    lcdbuffer[3] = 'E';
    lcdbuffer[4] = 'r';
    lcdbuffer[5] = 'r';
    lcdbuffer[6] = 'o';
    lcdbuffer[7] = 'r'; 
    lcdbuffer[8] = ' ';
    lcdbuffer[9] = 0;
  }
  else {
    /* Select calibration value */
    b = rangemode & 3;
  
    if (calib_offset[b] > value) {
      lcdbuffer[0] = '-';
      value = calib_offset[b] - value;
    }
    else {
      lcdbuffer[0] = ' ';
      value = value - calib_offset[b];
    }
    
    MUL_LONG_SHORT_S2(value, calib[b], &l);
    
    b = long2ascii(lcdbuffer+1, l);
    
    /* High range shifts 1E3 */
    if (rangemode & RANGE_HIGH)
      b++;
    
    lcdbuffer[6] = ' ';
    lcdbuffer[7] = decades[b];  /* range = 1 shifts 1E3 */
    lcdbuffer[8] = 'F';
    lcdbuffer[9] = 0;
  }
    
  /* Write high threshold in first line, low threshold in second */
  if (rangemode & RANGE_HIGH_THRESH)
    b=7;
  else
    b=23;
  
  lcd_string(lcdbuffer,b);
}

void calibrate_zero(void)
{
  char oldrange = rangemode;
  unsigned long l;
  
  rangemode = 0;
 
  l = measure();
  l = measure();
  
  calib_offset[rangemode] = l;
  
  rangemode = RANGE_HIGH_THRESH;
 
  l = measure();
  l = measure();
  
  calib_offset[rangemode] = l;
  
  rangemode = oldrange;
  
}

void calibrate(void)
{
  char oldrange = rangemode;
  unsigned long value;
  
  rangemode = 0;
  value = measure();
  value -= calib_offset[rangemode];
  calib[rangemode] = CALIB_LOW / (value>>8) + 1;

  rangemode = RANGE_HIGH_THRESH;
  value = measure();
  value -= calib_offset[rangemode];
  calib[rangemode] = CALIB_LOW / (value>>8) + 1;
  
  rangemode = RANGE_HIGH;
  value = measure();
  value -= calib_offset[rangemode];
  calib[rangemode] = CALIB_HIGH / value + 1;
 
  rangemode = RANGE_HIGH | RANGE_HIGH_THRESH;
  value = measure();
  value -= calib_offset[rangemode];
  calib[rangemode] = CALIB_HIGH / value + 1;
 
  rangemode = oldrange;
  
}

char menu(void)
{
  unsigned char i;
  
  lcd_clear();
  
  for (i=0; i<MENU_ITEMS; i++) {
    lcd_string(menu_item[i],0);
    ms_spin(MENU_SPEED);
    
    if (!BUTTON_PUSHED)
      break;
    
  }
  
  if (i == MENU_ITEMS) {
    /* Just clear display, if user went out of menu */
    lcd_clear();
    
    /* Wait for release of button */
    while (BUTTON_PUSHED);
    ms_spin(10);
   
  }
  else {
    /* Flash selected item */
    lcd_clear();  
    ms_spin(MENU_SPEED >> 2);
    lcd_string(menu_item[i],0);
    ms_spin(MENU_SPEED >> 1);
    lcd_clear();
    ms_spin(MENU_SPEED >> 2);
    
  }
  
  return i;
}

/* NOW I NEED TO COMPARE THE CODEWIZARD CODE WITH THE INIT FUNCTION */


// SPI functions
#include <spi.h>

void main(void)
{
unsigned long l;
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: On
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
// Interrupt on Rising Output Edge
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2000.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
SPSR=(0<<SPI2X);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")

/*REAL STUFF BEGINS*/

lcd_init();

eeprom_read();

LED_OFF; //turns off an LED (probably an indicator for measurement status).
      
rangemode = RANGE_AUTO; 

while (1) {
      /* Toggle high/low threshold */
      rangemode ^= RANGE_HIGH_THRESH;
      l = measure();
      if (BUTTON_PUSHED) {
        /* Stop any cap. charging */
        LED_OFF;
        LOW_RANGE;
        DISCHARGE_ON;
        
        /* Menu implementation */
        switch(menu()) {
        case 0: /* auto range */
          rangemode |= RANGE_AUTO;
          break; 
        case 1: /* low range */
          rangemode &= ~(RANGE_AUTO | RANGE_HIGH);
          break;  
        case 2: /* high range */
          rangemode &= ~RANGE_AUTO;
          rangemode |= RANGE_HIGH;
          break;  
        case 3: 
          calibrate_zero();
          break;  
        case 4: 
          calibrate();
          break;  
        case 5: 
          eeprom_write();
          break;  
        }
        
      }
      else
        calc_and_show(l);
    }
}
