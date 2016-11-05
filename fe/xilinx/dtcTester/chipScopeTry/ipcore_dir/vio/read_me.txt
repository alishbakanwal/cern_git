HOW TO BUILD EXAMPLE DESIGN:

Example design module is placed in example_design directory during core generation.To implement the example design, follow any of the below methods. 


Method 1 : If Core is generated from CoreGen, to run implementation on the example design through ISE:
	  
           Step 1: Launch a ISE Design Suite Command Line
	   Step 2: Change directory to the implement folder
           Step 3: ./ise_implement.sh or ise_implement.bat


Method 3 : If Core is generated from PlanAhead, to run implementation on example design either through ISE using PlanAhead:
           Execute the below commands in the PlanAhead tcl console:

           Step 1: change directory to the implement folder
           Step 2: source pa_ise_implement.tcl

These are the different scenarios that can be tested using the example design. 

1) If ASYNC_OUT/SYNC_OUT port is selected, user can enter input through VIO console.
2) If SYNC_IN port is selected, Shift operation or walking one pattern is observed on SYNC_IN port. 
3) If ASYNC_IN port is selected, constant 1's are displayed for all signals on this port. 
4) If both ASYNC_OUT and ASYNC_IN are selected, ASYNC_OUT[0] acts as a control to the pattern displayed on ASYNC_IN port.  
5) If both SYNC_OUT and SYNC_IN ports are selected, SYNC_OUT[0] acts as load enable for the shift operation on SYNC_IN port. 
