/*--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	3/12/2025
-- File:	Lab_3.c
-- Event:	Lab 3
-- Crs:		CSCE 436
--

-- Documentation:	MicroBlaze Tutorial
--
-- Academic Integrity Statement: I certify that, while others may have
-- assisted me in brain storming, debugging and validating this program,
-- the program itself is my own work. I understand that submitting code
-- which is the work of other individuals is a violation of the honor
-- code.  I also understand that if I knowingly give my original work to
-- another individual is also a violation of the honor code.
-------------------------------------------------------------------------*/
/***************************** Include Files ********************************/

#include <stdio.h>
#include "xparameters.h"
#include "stdio.h"
#include "xstatus.h"

#include "platform.h"
#include "xil_printf.h"						// Contains xil_printf
#include <xuartlite_l.h>					// Contains XUartLite_RecvByte
#include <xil_io.h>							// Contains Xil_Out8 and its variations
#include <xil_exception.h>

/************************** Constant Definitions ****************************/

/*
 * The following constants define the slave registers used for our Counter PCORE
 */
#define countBase		0x44a00000
#define countQReg		countBase			//slv_reg0
#define	triggerTimeReg	countBase+4			// 9 LSBs of slv_reg1 are ex_trigger_time
#define	triggerVoltReg	countBase+8			// 9 LSBs of slv_reg2 are ex_trigger_volt
#define	exSelReg	countBase+0xc		// 1 LSBs of slv_reg3 (0) exSel
#define flagQReg         countBase + 0x10    // slv_reg4  8 bits
#define flagClearReg     countBase + 0x14    // slv_reg5 8 bits CHANGED TO REG5
#define lbusOutReg       countBase + 0x18    // slv_reg6 16 bits
#define rbusOutReg       countBase + 0x1c    // slv_reg7 16 bits
#define exLbusReg        countBase + 0x20    // slv_reg8 16 bits
#define exRbusReg        countBase + 0x24    // slv_reg9 16 bits
#define exWenReg         countBase + 0x28    // slv_reg10 1 bit
#define exWrAddrReg      countBase + 0x2c    // slv_reg11 10 bits
#define exch1enbReg      countBase + 0x30    // slv_reg12 1 bit
#define exch2enbReg      countBase + 0x34    // slv_reg13 1 bit

#define printf xil_printf			/* A smaller footprint printf */

#define	uartRegAddr			0x40600000		// read <= RX, write => TX





/************************** Function Prototypes ****************************/
void myISR(void);


u16 arrayIndex = 0;


// DECLARE GLOBAL CIRCULAR BUFFERS FOR DATA
u16 channel1[1023];
u16 channel2[1023];

int bufferFull = 0;

int chan1_state = 1;
int chan2_state = 1;


int main()
{
    init_platform();


    print("Welcome To My O-Scope!!!       By: Maxwell J. Pembo :)\n\r");

    unsigned char c;

     int trigger_volt = 220;
     int trigger_time = 320;





    microblaze_register_handler((XInterruptHandler) myISR, (void *) 0);
    microblaze_enable_interrupts();


    // TURN ON BOTH CHANNELS
    Xil_Out8(exch1enbReg,0x01);
    Xil_Out8(exch2enbReg,0x01);

    while(1) {

    	c=XUartLite_RecvByte(uartRegAddr);

		switch(c) {

    		/*-------------------------------------------------
    		 * Reply with the help menu
    		 *-------------------------------------------------
			 */
    		case '?':
    			printf("--------------------------\r\n");
    			printf("	Trigger Volt = %d\r\n", trigger_volt);
    			printf("	Trigger Time = %d\r\n",trigger_time);
    			printf("--------------------------\r\n");
    			printf("?: help menu\r\n");
				printf("w:   Increase Trigger Volt \r\n");
				printf("s:   Decrease Trigger Volt \r\n");
				printf("d:   Increase Trigger Time\r\n");
				printf("a:   Increase Trigger Time\r\n");
				printf("g:   Grab Data \r\n");
				printf("h:   Trigger Off channel 2 \r\n");
    			printf("r:   Reset Trigger Volt & Trigger Time\r\n");
    			printf("f:   flush terminal\r\n");
    			printf("o:   Enable / Disable Channel 1 (Left)\r\n");
    			printf("p:   Enable / Disable Channel 2 (Right)\r\n");
    			printf("y:   Trigger On Falling Edge\r\n");

    			break;

			/*-------------------------------------------------
			 * Increase Trigger Volt
			 *-------------------------------------------------
			 */
    		case 'w':
				trigger_volt = trigger_volt - 10;

				//Set exSel to 1
				Xil_Out8(exSelReg,0x01);
				// Set the new Value
				Xil_Out16(triggerVoltReg,trigger_volt);
				//Set exSel back to 0
				Xil_Out8(exSelReg,0x00);



    			break;

			/*-------------------------------------------------
			 * Decrease Trigger Volt
			 *-------------------------------------------------
			 */
    		case 's':
    			trigger_volt = trigger_volt + 10;

				//Set exSel to 1
				Xil_Out8(exSelReg,0x01);
				// Set the new Value
				Xil_Out16(triggerVoltReg,trigger_volt);
				//Set exSel back to 0
				Xil_Out8(exSelReg,0x00);



    			break;

			/*-------------------------------------------------
			 * Decrease Trigger Time
			 *-------------------------------------------------
			 */
        	case 'a':
        		trigger_time = trigger_time - 10;

				//Set exSel to 1
				Xil_Out8(exSelReg,0x01);
				// Set the new Value
				Xil_Out16(triggerTimeReg,trigger_time);
				//Set exSel back to 0
				Xil_Out8(exSelReg,0x00);




        		break;

			/*-------------------------------------------------
			 * Increase Trigger Volt
			 *-------------------------------------------------
			 */
        	case 'd':
        		trigger_time = trigger_time + 10;

				//Set exSel to 1
				Xil_Out8(exSelReg,0x01);
				// Set the new Value
				Xil_Out16(triggerTimeReg,trigger_time);
				//Set exSel back to 0
				Xil_Out8(exSelReg,0x00);

        		break;

			/*---------------------------------------------g----
			 * Reset the counter
			 *-------------------------------------------------
			 */
            case 'r':
            	trigger_volt = 220;
				trigger_time = 320;

				//Set exSel to 1
				Xil_Out8(exSelReg,0x01);
				// Set the new Value
				Xil_Out16(triggerTimeReg,trigger_time);
				Xil_Out16(triggerVoltReg,trigger_volt);
				//Set exSel back to 0
				Xil_Out8(exSelReg,0x00);

            	break;

			/*-------------------------------------------------
			 * Clear the ISR counter
			 *-------------------------------------------------
			 */
			case 'i':
				arrayIndex = 0;				// clear ISR Count
				break;

			/*-------------------------------------------------
			 * Clear the terminal window
			 *-------------------------------------------------
			 */
            case 'f':
            	for (c=0; c<40; c++) printf("\r\n");
               	break;


            /*-------------------------------------------------
     		 * Draw Signal
           	 *-------------------------------------------------
            */
            case 'g':
            	// Reset index
            	arrayIndex = 0;

            	// Clear buffer

            	bufferFull = 0;

            	// wait till filled
            	while (bufferFull == 0){
            	// look for trigger


            		// Start search at trigger time
            	    int startIndex = trigger_time;
            	    int risingEdgeIndex = 0;

            	    int tr_volt_temp = trigger_volt;
            	    tr_volt_temp = (tr_volt_temp + 292) << 6;

            	    for (int i = startIndex; i < 1022; i++) {
            	    	// Find the Rising edge trigger
            	    	if ((channel1[i] <= tr_volt_temp) && (channel1[i+1] > tr_volt_temp)) {
            	    		//printf("found Rising Edge\n");
            	    		risingEdgeIndex = i;
            	            break;
            	    	}
            	    }


            	    int triggerAddress = risingEdgeIndex - trigger_time;
            	    if (triggerAddress < 0) {
            	        triggerAddress = 0;  // Prevent negative address
            	    }


            	    int ramAddress = 0;


            	// Write to BRAM
            		Xil_Out8(exSelReg,0x01);//set exSel = 1

            		 for (u16 i = triggerAddress; i <= triggerAddress + 620; i++){

            		  ramAddress ++;

            		  if (ramAddress > 1023){
            			  ramAddress = 0;
            		  }

            		  Xil_Out16(exWrAddrReg,ramAddress);

            		  Xil_Out16(exLbusReg,(channel1[i]));
            		  Xil_Out16(exRbusReg,(channel2[i]));



            		  Xil_Out8(exWenReg,1);
            		  Xil_Out8(exWenReg,0); //make sure you clear the ExWen so you can update the bus and address
            		 }
            		//Xil_Out8(exSelReg,0x00);//set exSel = 0
            	    }
            	break;



                /*-------------------------------------------------
          		 * Trigger off channel 2
                 *-------------------------------------------------
                 */
                 case 'h':
                 	// Reset index
                 	arrayIndex = 0;

                 	// Clear buffer

                 	bufferFull = 0;

                 	// wait till filled
                 	while (bufferFull == 0){
                 	// look for trigger


                 		// Start search at trigger time
                 	    int startIndex = trigger_time;
                 	    int risingEdgeIndex = 0;

                 	    int tr_volt_temp = trigger_volt;
                 	    tr_volt_temp = (tr_volt_temp + 292) << 6;

                 	    for (int i = startIndex; i < 1022; i++) {
                 	    	// Find the Rising edge trigger
                 	    	if ((channel2[i] <= tr_volt_temp) && (channel2[i+1] > tr_volt_temp)) {
                 	    		//printf("found Rising Edge\n");
                 	    		risingEdgeIndex = i;
                 	            break;
                 	    	}
                 	    }


                 	    int triggerAddress = risingEdgeIndex - trigger_time;
                 	    if (triggerAddress < 0) {
                 	        triggerAddress = 0;  // Prevent negative address
                 	    }


                 	    int ramAddress = 0;


                 	// Write to BRAM
                 		Xil_Out8(exSelReg,0x01);//set exSel = 1

                 		 for (u16 i = triggerAddress; i <= triggerAddress + 620; i++){

                 		  ramAddress ++;

                 		  if (ramAddress > 1023){
                 			  ramAddress = 0;
                 		  }

                 		  Xil_Out16(exWrAddrReg,ramAddress);

                 		  Xil_Out16(exLbusReg,(channel1[i]));
                 		  Xil_Out16(exRbusReg,(channel2[i]));



                 		  Xil_Out8(exWenReg,1);
                 		  Xil_Out8(exWenReg,0); //make sure you clear the ExWen so you can update the bus and address
                 		 }
                 		//Xil_Out8(exSelReg,0x00);//set exSel = 0
                 	    }
                 	break;


                /*-------------------------------------------------
         		 * Draw Signal On falling edge
               	 *-------------------------------------------------
                */
                case 'y':
                	// Reset index
                	arrayIndex = 0;

                	// Clear buffer

                	bufferFull = 0;

                	// wait till filled
                	while (bufferFull == 0){
                	// look for trigger


                		// Start search at trigger time
                	    int startIndex = trigger_time;
                	    int risingEdgeIndex = 0;

                	    int tr_volt_temp = trigger_volt;
                	    tr_volt_temp = (tr_volt_temp + 292) << 6;

                	    for (int i = startIndex; i < 1022; i++) {
                	    	// Find the Rising edge trigger
                	    	if ((channel1[i] >= tr_volt_temp) && (channel1[i+1] < tr_volt_temp)) {
                	    		//printf("found Falling Edge\n");
                	    		risingEdgeIndex = i;
                	            break;
                	    	}
                	    }


                	    int triggerAddress = risingEdgeIndex - trigger_time;
                	    if (triggerAddress < 0) {
                	        triggerAddress = 0;  // Prevent negative address
                	    }


                	    int ramAddress = 0;


                	// Write to BRAM
                		Xil_Out8(exSelReg,0x01);//set exSel = 1

                		 for (u16 i = triggerAddress; i <= triggerAddress + 620; i++){

                		  ramAddress ++;

                		  if (ramAddress > 1023){
                			  ramAddress = 0;
                		  }

                		  Xil_Out16(exWrAddrReg,ramAddress);

                		  Xil_Out16(exLbusReg,(channel1[i]));
                		  Xil_Out16(exRbusReg,(channel2[i]));



                		  Xil_Out8(exWenReg,1);
                		  Xil_Out8(exWenReg,0); //make sure you clear the ExWen so you can update the bus and address
                		 }
                		//Xil_Out8(exSelReg,0x00);//set exSel = 0
                	    }
                	break;



    	 /*-------------------------------------------------
    	  * Enable / Disable Channel 1 (Left)
    	  *-------------------------------------------------
    	  */
    	 case 'o':

    		if (chan1_state == 1){

    			//printf("TURNING OFF CHAN 1\n");

    			Xil_Out8(exch1enbReg,0x00);
				chan1_state = 0;
    		}else {

    			//printf("TURNING ON CHAN 1\n");

   				Xil_Out8(exch1enbReg,0x01);
    			chan1_state = 1;
    		}


    	break;


        /*-------------------------------------------------
         * Enable / Disable Channel 2 (Right)
         *-------------------------------------------------
         */
        case 'p':

        	if (chan2_state == 1){

        		//printf("TURNING OFF CHAN 2\n");

        		Xil_Out8(exch2enbReg,0x00);
        		chan2_state = 0;
        	}else {

        		//printf("TURNING ON CHAN 2\n");

        		Xil_Out8(exch2enbReg,0x01);
        		chan2_state = 1;
    		}


        	break;

			/*-------------------------------------------------
			 * Unknown character was
			 *-------------------------------------------------
			 */

    		default:
    			printf("unrecognized character: %c\r\n",c);
    			break;
    	} // end case

    } // end while 1



    cleanup_platform();
    return 0;
}




void myISR(void) {
	arrayIndex = arrayIndex + 1;

	if (bufferFull == 0){

		channel1[arrayIndex] = (Xil_In16(lbusOutReg)) ;
		channel2[arrayIndex] = Xil_In16(rbusOutReg);

		if (arrayIndex >= 1023) {
			arrayIndex = 0;
			bufferFull = 1;
		}
	}


	Xil_Out8(flagQReg, 0x01);					// Clear the flag and then you MUST
	Xil_Out8(flagQReg, 0x00);					// allow the flag to be reset later
}





