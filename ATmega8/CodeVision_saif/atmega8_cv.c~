/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 17/04/2025
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

// Alphanumeric LCD functions
#include <alcd.h>
#include <delay.h>   // if you're using delay_ms()
#include <eeprom.h>  // for EEPROM access
#include <stdio.h>
// Declare your global variables here
#include <spi.h>

#define DISCHARGE_ON  DDRD |= (1<<6)
#define DISCHARGE_OFF DDRD &= ~(1<<6)

/* Range control */
#define HIGH_RANGE PORTD |= (1<<5); DDRD |= (1<<5)
#define LOW_RANGE  DDRD &= ~(1<<5); PORTD &= ~(1<<5)
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
#define LED_ON  PORTD &= ~(1<<4)
#define LED_OFF PORTD |= (1<<4)

/* Button abstraction */
#define BUTTON_PUSHED (!(PIND & (1<<2)))

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

/* Calibration values are stored in eeprom in the following format: 

   Starting from byte 1:  (not 0)
   'C' 'D'
   <data>
   
*/
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
    
    
/* Interrupt implementation */
interrupt [ANA_COMP] void ana_comp_isr(void)
{
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




interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  /* Timer 1 counts the low 16 bits, this interrupt updates the high 16 bits */
  timer_highword++;
}

// SIGNAL(SIG_INTERRUPT0)
// {
//   /* Hardware interrupt 0 is a buttonpush */
//   measure_state = STATE_BUTTONDOWN;
// }

/* 
   The measure function does the cyclus of a capacitance measurement
   Returned is the number of clocks measured
   
   The function relies on flags in the global rangemode value
   Input flags:
     RANGE_AUTO
     RANGE_HIGH
     RANGE_HIGH_THRESH
     
   Output flags:
     RANGE_HIGH     (if RANGE_AUTO)
     RANGE_OVERFLOW
     
*/

#include <stdint.h>
void MUL_LONG_SHORT_S2(int32_t x, int16_t y, uint32_t *result) {
    int16_t x_high = x >> 16;              // Integer part (signed)
    uint16_t x_low = x & 0xFFFF;           // Fractional part (unsigned)

    int32_t part1 = (int32_t)x_high * y;   // Signed mult: integer part
    int32_t part2 = ((int32_t)x_low * y + 0x8000) >> 16; // Rounded fractional part

    int32_t combined = part1 + part2;

    *result = (uint32_t)combined;          // Cast final signed result to unsigned
}

void eeprom_read(void)
{
  if (eeprom_read_byte((void*)EEPROM_HEADER) != 'C')
    return;
    
  if (eeprom_read_byte((void*)(EEPROM_HEADER+1)) != 'D')
    return;
  
  eeprom_read_block(calib_offset, (eeprom void *)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
  eeprom_read_block(calib, (eeprom void *)((char *)EEPROM_DATA + SIZE_OF_CALIBOFFSET), SIZE_OF_CALIB);

  
}

void eeprom_write(void)
{
  eeprom_write_byte((void*)EEPROM_HEADER, 'C');
  eeprom_write_byte((void*)(EEPROM_HEADER+1), 'D');
  
  eeprom_write_block(calib_offset, (eeprom void *)EEPROM_DATA, SIZE_OF_CALIBOFFSET);
  eeprom_write_block(calib, (eeprom void *)((char *)EEPROM_DATA + SIZE_OF_CALIBOFFSET), SIZE_OF_CALIB);


}

void lcd_string(const char *str, unsigned char pos)
{
  unsigned char row = (pos >= 16) ? 1 : 0;
  unsigned char col = (pos % 16);
  lcd_gotoxy(col, row);
  lcd_puts(str);
}

unsigned char long2ascii(char *buf, unsigned long val)
{
  // Converts val to a 5-digit ASCII right-aligned string, returns # of digits
  sprintf(buf, "%05lu", val);  // e.g., 00042
  return 5;
}

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
    delay_ms(1);
    
    /* This value must be checked in every loop */
    if (BUTTON_PUSHED)
      return 0;
      
    if (!(ACSR & (1<<ACO)))
      break;
    
    /* Discharge for a while */
    DISCHARGE_ON;
    delay_ms(10);
    
    
  } 
  
  DISCHARGE_ON;
  delay_ms(EXTRA_DISCHARGE_MS);
  
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
      delay_ms(1);
      
      /* This value must be checked in every loop */
      if (BUTTON_PUSHED)
        return 0;
    }
    
    if (i >= LOW_RANGE_TIMEOUT) {
      /* low range timeout, go to high range (better discharge a little first) */
      DISCHARGE_ON;
      delay_ms(EXTRA_DISCHARGE_MS); 
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
    delay_ms(1);
    
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

/* 
   This function deals with value according to the global rangemode flag,
   and shows the result on LCD.
   
   LCD should preferably be cleared.
   
   Routine is rather slow
*/

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

/* Hold-down-button menu implementation: */
  
char menu(void)
{
  unsigned char i;
  
  lcd_clear();
  
  for (i=0; i<MENU_ITEMS; i++) {
    lcd_string(menu_item[i],0);
    delay_ms(MENU_SPEED);
    
    if (!BUTTON_PUSHED)
      break;
    
  }
  
  if (i == MENU_ITEMS) {
    /* Just clear display, if user went out of menu */
    lcd_clear();
    
    /* Wait for release of button */
    while (BUTTON_PUSHED);
    delay_ms(10);
   
  }
  else {
    /* Flash selected item */
    lcd_clear();  
    delay_ms(MENU_SPEED >> 2);
    lcd_string(menu_item[i],0);
    delay_ms(MENU_SPEED >> 1);
    lcd_clear();
    delay_ms(MENU_SPEED >> 2);
    
  }
  
  return i;
}

void init(void)
{
  
  /* Set datadirections */
  DDRD = (1<<4); /* led output, rest input */
  PORTD &= ~(1<<6); /* AIN0 port must be 0 */
  
  /* Enable button pull up resistor */
  PORTD |= (1<<2);
  
  /* Setup timer1 to normal operation */
  TCCR1A = 0;
  TCCR1B = 0;
  TIMSK = (1<<TOIE1); //(mega8)
  //TIMSK1 = (1<<TOIE1); //(mega48/88/168)
  
  
  /* Setup analog comperator to generate rising edge interrupt */
  ACSR = (1<<ACIS0)|(1<<ACIS1)|(1<<ACIE);
  
  /* Setup analog comperator to use ADMUX */
  ADMUX = ADMUX_LOW;
  SFIOR |= (1<<ACME);
  //ADCSRB |= (1<<ACME);  
  //DIDR1 |= (1<<AIN1D)|(1<<AIN0D); 
  
}

  

void main(void)
{

// Declare your local variables here
unsigned long l;

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
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
// Timer1 Overflow Interrupt: Off
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
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);



lcd_init(8);


  
init(); //init peripherals/adc/timers/etc.. 
  
eeprom_read(); //reads calibration values or settings from EEPROM.
	 
#asm("sei"); //enables global interrupts 
  
LED_OFF; //turns off an LED (probably an indicator for measurement status).
      
rangemode = RANGE_AUTO; //setting Up the Measurement Mode

  
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
