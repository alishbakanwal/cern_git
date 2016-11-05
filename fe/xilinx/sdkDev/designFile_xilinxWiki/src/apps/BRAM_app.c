#include <stdio.h>
#include "xparameters.h"
#define BRAM_SIZE 0x40000
int main()
{
	 unsigned int uiLoop;
	 unsigned int * uiDataArray = (unsigned int *)XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR;
	 unsigned int uiData;

	 printf("\n\r BRAM Application Starts \n\r");

	 printf("\n\r BRAM Data Initialization \n\r");
	 // BRAM Initialization with specified Pattern.
	 for(uiLoop =0 ; uiLoop < (BRAM_SIZE/4) ; uiLoop++)
	 {
		 *(unsigned int *)(uiDataArray + uiLoop) = uiLoop;

	 }
	 // BRAM Data Verification.
	 for(uiLoop =0 ; uiLoop < (BRAM_SIZE/4) ; uiLoop++)
	 {

		 uiData = *(unsigned int *)(uiDataArray + uiLoop);
		if(uiData != uiLoop)
		{
			printf("BRAM verification failed \n\r");
			return -1;
		}

	 }

	 printf("\n\r BRAM Verification Successful \n\r");

	 return 0;
}
