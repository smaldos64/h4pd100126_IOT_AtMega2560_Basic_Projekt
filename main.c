/**
 * @file main.c
 * @author ltpe
 * @date 2026-10-15
 * @brief Main function
 */

#define _XTAL_FREQ 16000000UL  // Sæt til din faktiske clock-frekvens (f.eks. 16 MHz)

#include <xc.h>

// Præcise, selvstændige inline-forsinkelser baseret på _XTAL_FREQ
// 'volatile' sikrer, at optimeringscomputeren ikke fjerner tæller-løkken
inline void delay_us(unsigned int us) {
    while (us--) {
        // En grov eller finjusteret NOP-baseret eller cyklus-tæller
        // For 16 MHz tager én mikrosekund ca. 16 cyklusser minus overhead
        __asm__ volatile("nop");
    }
}

void delay_ms(unsigned int ms) {
    while (ms--) {
        // 1 millisekund = 1000 mikrosekunder
        // Da en simpel løkke tager et antal cyklusser, kan vi kalde en 1ms præcis rutine
        for (volatile unsigned int i = 0; i < (_XTAL_FREQ / 4000); i++) {
            __asm__ volatile("nop");
        }
    }
}


int main(void)
{
    // Sæt pin 5 på PORTB som udgang (eksempel)
    DDRB |= (1 << DDB3);
    PORTB ^= (1 << PORTB3); // Toggle LED

    while (1) 
    {
       PORTB ^= (1 << PORTB3); // Toggle LED
       delay_ms(250);         // Vent 500 ms
    }
}
