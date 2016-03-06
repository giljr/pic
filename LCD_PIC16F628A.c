/*
See: https://www.youtube.com/playlist?list=PLK3PeNcUzb8TYBUxpC2Y9xaXN0wBSY2e0
---1. Cataloguing ---
 * Project name: 06 # picSerie - Interfacing LCD w/ PIC16F628A!!!
    LCD_PIC16F628A.asm
 *  Copyright: Mikroelektronika (c)
 * Revision History:
     20160605:
       - initial release;
       
 * Description:
     This code describe how to write in the LCD using mikroC and PIC16F628A 
     without many frills !!! Have fun !!! Always !!!
 * Test configuration:
     MCU:            PIC16F628A
                     http://www.microchip.com/wwwproducts/en/en010210
     Rec.Board:      PicKit3
                     PicKit3 - http://www.microchip.com/pagehandler/...
     Oscillator:     16MHz Crystal
     Proteus test:   LCD_16x2_n_PIC16F628A.pdsprj
     SW:             mikroC PRO for PIC v.4.15.0.0
                     http://www.microchip.com/mplab/mplab-x-ide
 * NOTES: Based on mikroC PRO for PIC v.4.15.0.0 help.
 * Date : mar 2016
*/


//---2. LCD module connections ---
sbit LCD_RS at RB1_bit;
sbit LCD_EN at RB0_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

//---3. LCD module directions ---
sbit LCD_RS_Direction at TRISB1_bit;
sbit LCD_EN_Direction at TRISB0_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;

// ---4. Text to write to LCD ---
char txt1[] = "mikroElektronika";
char txt2[] = "EasyPIC6";
char txt3[] = "Lcd4bit";
char txt4[] = "example";

// ---5. Loop variable ---
char i;

// ---6. Function used for text moving ---
void Move_Delay() {
  Delay_ms(500);                     // You can change the moving speed here
}

// ---7. Business rules ---
void main(){
  INTCON = 0x00;                      // Disable interruptions
  CMCON = 0x07;                       // Disable comparators
  
  Lcd_Init();                        // Initialize LCD

  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,6,txt3);                 // Write text in first row

  Lcd_Out(2,6,txt4);                 // Write text in second row
  Delay_ms(2000);
  Lcd_Cmd(_LCD_CLEAR);               // Clear display

  Lcd_Out(1,1,txt1);                 // Write text in first row
  Lcd_Out(2,5,txt2);                 // Write text in second row

  Delay_ms(2000);


  for(i=0; i<4; i++) {               // Move text to the right 4 times
    Lcd_Cmd(_LCD_SHIFT_RIGHT);
    Move_Delay();
  }

  while(1) {                         // Endless loop
    for(i=0; i<8; i++) {             // Move text to the left 7 times
      Lcd_Cmd(_LCD_SHIFT_LEFT);
      Move_Delay();
    }

    for(i=0; i<8; i++) {             // Move text to the right 7 times
      Lcd_Cmd(_LCD_SHIFT_RIGHT);
      Move_Delay();
    }
  }
}